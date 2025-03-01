import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/waya_colors.dart';

import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/ugt/create_contest_post/create_contest_post.dart';
import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart';
import 'package:wayagram/features/ugt/data/model/contest_state.dart';
import 'package:wayagram/features/ugt/data/model/contest_vote_model.dart';
import 'package:wayagram/features/ugt/data/model/voter_contest_state.dart';

import 'package:wayagram/features/ugt/data/repository/ContestRepo.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/wallet/data/model/external_wallet_model.dart';
import 'package:wayagram/features/wallet/data/model/wallet_model.dart';

import 'package:wayagram/features/wallet/data/repo/wallet_repository.dart';
import 'package:wayagram/shared/features/file/repo/default.dart';
import '../../../core/data/local_data_source.dart';

import '../../../core/service/logger_service.dart';

class VotersContestNotifier extends StateNotifier<VoterDetailState> {
  final ContestRepo _contestRepository;
  final WayaLocalDataSource _localDataSource;
  final WalletRepository? _walletRepository;

  final _logger = getLogger('ContestRepo');

  VotersContestNotifier(
      this._contestRepository, this._localDataSource, this._walletRepository)
      : super(VoterDetailState());

  Future<bool> verifyWalletPin(ValueNotifier<bool> isLoading, String pin,
      Map<String, String> map) async {
    isLoading.value = true;
    final response = await _walletRepository!.confirmWalletPin(ConfirmWalletPin(
        userId: _localDataSource.getUserId().toString(), pin: pin));
    if (response.success) {
      print(map);
      map["profileId"] = _localDataSource.getUserId().toString();
      return await voteContestant(isLoading,map);
    } else {
       isLoading.value = false;
      return false;
    }
  }

  Future<bool> voteContestant(ValueNotifier<bool> isLoading,Map<String, String> map) async {
    final response = await _contestRepository.voteContestant(map);
     isLoading.value = false;
    if (response.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getUserWallet() async {
    state = state.copyWith(isLoading: true);
    final response = await _walletRepository!.getUserWallet();
    if (response.success == true) {
      final walletData = response.data["data"]["wallet"];
      final walletAccountsData = response.data["data"]["walletAccounts"];
      final externalWallets = (walletAccountsData as List)
          .map((walletAccount) => ExternalWalletModel.fromJson(walletAccount))
          .toList();
      state = state.copyWith(
          data: Wallet.fromJson(walletData),
          externalWallets: externalWallets,
          isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getContestantProfileVoteDetails(String contestId) async {
    try {
      final response =
          await _contestRepository.getContestantProfileVoteDetails(contestId);
      List<MyContestContestantModel> contestList = [];
      if (response.success) {
        ContestContestantModelMean responseModel =
            ContestContestantModelMean.fromJson(response.data);
        contestList = responseModel.data ?? [];
        contestList.sort((a, b) => b.votes!.compareTo(a.votes!));
        var model = contestList.firstWhere(
            (e) => e.profileId == _localDataSource.getUserId().toString());
        // createPostId = ;
        state = state.copyWith(
            myContestList: contestList,
            myContestListCopy: contestList,
            createPostId: model.id ?? "");
        // _page++;
        //isLoading = false;
      }
      // return contestList;
    } catch (e) {
      print(e);
    } finally {
      // isLoading = false;
    }
  }

  void searchList(String value) {
    if (value.trim().isEmpty) {
      state = state.copyWith(myContestList: state.myContestListCopy);
    } else {
      var myList = state.myContestListCopy ?? [];
      state = state.copyWith(
          myContestList: myList.where((e) {
        String name = e.contestApplicant?.fullName ?? "";
        return name.toLowerCase().contains(value.toLowerCase());
      }).toList());
    }
  }

  void uploadCreatePost(
      WidgetRef ref,
      BuildContext context,
      ValueNotifier<bool> isLoading,
      String text,
      List<MyMediaType> selectedImages,
      File? videoFile,
      String s) async {
    List<String> imageUrls = [];
    String? videoUrl;
    isLoading.value = true;

    for (var model in selectedImages) {
      if (!model.type) {
        final imageUrl = await WayaFileRepository.instance
            .uploadFile(File(model.path), "ugt-image-${Uuid().v4()}");
        imageUrls.add(imageUrl ?? "");
      }
    }
    if (videoFile != null) {
      videoUrl = await WayaFileRepository.instance
          .uploadFile(File(videoFile.path), "ugt-video-${Uuid().v4()}");
    }

    List<Map<String, dynamic>> listMap = [];
    for (var myImage in imageUrls) {
      listMap.add({"type": "IMAGE", "url": myImage});
    }
    listMap.add({"type": "VIDEO", "url": videoUrl});
    listMap.add({"type": "TEXT", "url": text});

    var map = {
      "contestantProfileId": state.createPostId,
      "description": text,
      "mediaContent": listMap
    };
    print('wert $map');
    final response = await _contestRepository.createContestPost(map);
    isLoading.value = false;
    if (response.success) {
      WayaSnackBar.showToast("Post created successfully!");
      getContestantProfileVoteDetails(
          ref.read(selectedContestProvider.notifier).state.id ?? "");
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } else {
      WayaSnackBar.showToast("Unable to create Post, Please try again later");
    }
  }
}

/* 
  Future<void> createPost(ctx, content, postType, List<XFile> images) async {
    print("before the loop");
    List<UploadedImage> urls = [];
    List<String> publicUrl = [];
    final choiceMap = <String>[];
    // get url
    for (XFile image in images) {
      print("In the loop ${image.name} ${image.path} ${image.mimeType}");

      final uploadImageResponse =
          await _pageRepository.getUploadImage(image.name);

      MediaUploadModel mediaUploadModel =
          MediaUploadModel.fromJson(uploadImageResponse.data);
      urls.add(UploadedImage(
          url: mediaUploadModel.data!.url!,
          file: image.path,
          fileName: image.name));
      publicUrl.add(mediaUploadModel!.data!.publicUrl!);
    }

    // upload
    for (UploadedImage url in urls) {
      final file = File(url.file);
      final putImageResponse = await _pageRepository.putImage(url.url, file);

      //? This is fine.
      if (!(putImageResponse.success && ctx.mounted)) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Failed to create post'),
            backgroundColor: WayaColors.error,
            duration: Duration(seconds: 2),
          ),
        );
        break;
      }

      //? This is fine.
      print("Data ${putImageResponse.data}");
    }
    //WayaHelpers.

    try {
      state = state.copyWith(isLoading: true);
      final response = await _pageRepository.createPost(content, publicUrl, postType);
      //final response = await _pageRepository.createPost(content, choiceMap, postType);
      state = state.copyWith(isLoading: false);
      //? If this is fine...
      if (response.success && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Post created successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }

      //? If it failed...
      else {
        _logger.i('LOGGER  ==>>> ${response.data['error']}');
        print('Create post');
        _logger.i(response.data['data']);
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

 */
final selectedContestantProfile =
    StateProvider<MyContestContestantModel?>((ref) => null);

final authRepositoryProvider = Provider((ref) => ContestRepo());

final votersContestNotifier =
    StateNotifierProvider<VotersContestNotifier, VoterDetailState>(
  (ref) {
    return VotersContestNotifier(
        ContestRepo(), WayaLocalDataSource(), WalletRepository());
  },
);

final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

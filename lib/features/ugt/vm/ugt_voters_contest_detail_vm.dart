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
import 'package:wayagram/features/ugt/data/model/ugt_all_post_contest_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_contest_aplicant_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_single_contestant_profile_model.dart';
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
      map["profileId"] = _localDataSource.getUserId().toString();
      print(map);
      return await voteContestant(isLoading, map);
    } else {
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> verifyAndPayForPaidContest(ValueNotifier<bool> isLoading,
      String pin, Map<String, String> map) async {
    isLoading.value = true;
    final response = await _walletRepository!.confirmWalletPin(ConfirmWalletPin(
        userId: _localDataSource.getUserId().toString(), pin: pin));

    print(map);
    if (response.success) {
      // map[] =  _localDataSource.getUserId().toString();
      return await payForPaidContest(isLoading, map);
    } else {
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> verifyAndPayForPaidStageContest(ValueNotifier<bool> isLoading,
      String pin, Map<String, String> map) async {
    isLoading.value = true;
    final response = await _walletRepository!.confirmWalletPin(ConfirmWalletPin(
        userId: _localDataSource.getUserId().toString(), pin: pin));

    print(map);
    if (response.success) {
      // map[] =  _localDataSource.getUserId().toString();
      return await payForPaidStageContest(isLoading, map);
    } else {
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> voteContestant(
      ValueNotifier<bool> isLoading, Map<String, String> map) async {
    final response = await _contestRepository.voteContestant(map);
    isLoading.value = false;
    if (response.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> payForPaidStageContest(
      ValueNotifier<bool> isLoading, Map<String, String> map) async {
    final response = await _contestRepository.payForPaidStageContest(map);
    isLoading.value = false;
    if (response.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> payForPaidContest(
      ValueNotifier<bool> isLoading, Map<String, String> map) async {
    final response = await _contestRepository.payForPaidContest(map);
    isLoading.value = false;
    if (response.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> startStageContest(
      String stageName, Map<String, String> map) async {
    final response = await _contestRepository.startStage(map);

    //  isLoading.value = false;
    if (response.success) {
      var list = state.stageList.map((stage) {
        if (stage.stageName == stageName) {
          stage.isActive = true; // Change isActive to false
        } else {
          stage.isActive = false;
        }
        return stage;
      }).toList();

      state = state.copyWith(stageList: [...list]);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> qualifyDisqualify(
      String contestId, Map<String, String> map) async {
    final response = await _contestRepository.qualifyDisqualify(map);
    // isLoading.value = false;
    if (response.success) {
      fetchAllContestApplicant(contestId);
      getContestantProfileVoteDetails(contestId);
      //getContestantProfileVoteDetails(contestId);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> acceptFreeStageContest(
      String contestId, Map<String, String> map) async {
    final response = await _contestRepository.acceptFreeStageContest(map);
    // isLoading.value = false;
    if (response.success) {
      fetchAllContestApplicant(contestId);
      getContestantProfileVoteDetails(contestId);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> acceptRejectContestant(
      ValueNotifier<bool> isLoading,
      String contestApplicationId,
      String contestId,
      Map<String, String> map) async {
    isLoading.value = true;
    final response = await _contestRepository.acceptRejectContestants(
        contestApplicationId, map);

    isLoading.value = false;
    if (response.success) {
      fetchAllContestApplicant(contestId);
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

  String getLoggedInUserId() {
    return _localDataSource.getUserId().toString();
  }

  Future<void> getContestantProfileVoteDetails(String contestId) async {
    print("i am here333  $contestId");
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

  Future<void> fetchAllContestPosts(String id) async {
    try {
      final response = await _contestRepository.fetchAllContestGallery(id);
      List<UgtAllPostContestModel> contestList = [];
      if (response.success) {
        UgtAllPostContestModelBase responseModel =
            UgtAllPostContestModelBase.fromJson(response.data);
        contestList = responseModel.data?.docs ?? [];

        state = state.copyWith(myPostList: contestList);
      }
    } catch (e) {
      //print(e);
    } finally {}
  }

  Future<void> fetchAllContestApplicant(String id) async {
    try {
      final response = await _contestRepository.fetchAllContestApplicant(id);
      List<ApplicantContestModel> contestList = [];
      if (response.success) {
        ApplicantContestModelBase responseModel =
            ApplicantContestModelBase.fromJson(response.data);
        contestList = responseModel.data ?? [];

        state = state.copyWith(myContestApplicantList: contestList);
      }
    } catch (e) {
      //print(e);
    } finally {}
  }

  void searchList(String value) {
    if (value.trim().isEmpty) {
      print("i am here $value");
      state = state.copyWith(myContestList: state.myContestListCopy);
    } else {
      print("i am yyyyyy $value");
      var myList = state.myContestListCopy ?? [];
      state = state.copyWith(
          myContestList: myList.where((e) {
        String name = e.contestApplicant?.fullName ?? "";
        return name.toLowerCase().contains(value.toLowerCase());
      }).toList());
      print("i am rrrrrr $value");
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
      "contestId": state.contestId,
      "description": text,
      "mediaContent": listMap
    };
    print('wert $map');
    final response = await _contestRepository.createContestPost(map);
    isLoading.value = false;
    if (response.success) {
      WayaSnackBar.showToast("Post created successfully!", showSuccess: true);
      getContestantProfileVoteDetails(
          ref.read(selectedContestProvider.notifier).state.id ?? "");
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } else {
      WayaSnackBar.showToast("Unable to create Post, Please try again later");
    }
  }

  void updateContestId(String? id) {
    state = state.copyWith(contestId: id);
  }

  void toggleLike(String postId) {
    // Contest? contestPost = null;
    print("Contest for you");
    //state.copyWith(myPostList: contestList)
    var list = state.myPostList.map((post) {
      print("i dey here 11");
      if (post.id == postId) {
        print("i dey here 2");
        //  bool isMyLiked = post.isLiked ?? false;
        // if (isMyLiked) {
        doOnLikeLike(postId);
        //  }
        return post.copyWith(
          isLiked: true,
          likes: post.likes! + 1,
        );
      }
      return post;
    }).toList();
    state = state.copyWith(myPostList: [...list]);
  }

  void doOnLikeLike(String postId) async {
    // print("do like stuff");
    final response = await _contestRepository.likeContest({
      "profileId": _localDataSource.getUserId().toString(),
      "contestId": postId
    });

    if (!response.success) {
      //  print("do like stuff Fail");
      var list = state.myPostList.map((post) {
        print("i dey here 3");
        if (post.id == postId) {
          print("i dey here 3");
          return post.copyWith(
            isLiked: !post.isLiked!,
            likes: post.likes! - 1,
          );
        }
        return post;
      }).toList();
      state = state.copyWith(myPostList: [...list]);
      //  WayaSnackBar.showToast("Unable to like, Please try again");
    } else {
      // WayaSnackBar.showToast("Contest already liked");
      print("Contest already liked");
    }
  }

  void toggleShare(String postId) {
    // Contest? contestPost = null;

    var list = state.myPostList.map((post) {
      print("i dey here wwww");
      if (post.id == postId) {
        print("i dey here pppppp");
        return post.copyWith(
          // isLiked: true,
          shares: post.shares! + 1,
        );
      }
      return post;
    }).toList();
    print("i dey here pppppp");
    state = state.copyWith(myPostList: [...list]);
    doshare(postId);
  }

  void doshare(String postId) async {
    // print("do like stuff");
    final response = await _contestRepository.shareContest({
      "profileId": _localDataSource.getUserId().toString(),
      "contestId": postId
    });

    if (!response.success) {
      //  print("do like stuff Fail");

      var list = state.myPostList.map((post) {
        if (post.id == postId) {
          return post.copyWith(
            shares: post.shares! + 1,
          );
        }
        return post;
      }).toList();
      state = state.copyWith(myPostList: [...list]);
      //  WayaSnackBar.showToast("Unable to like, Please try again");
    } else {
      print("do like stuff Success");
    }
  }

  void addStages(List<Stages> stages) {
    state = state.copyWith(stageList: stages);
  }

  void doFollow(String postId) async {
    // print("do like stuff");
    final response = await _contestRepository.followContest({
      "profileId": _localDataSource.getUserId().toString(),
      "contestId": postId
    });

    if (response.success) {
      //  print("do like stuff Fail");

      WayaSnackBar.showToast("Contest Followed", showSuccess: true);
    } else {
      print("do like stuff Success");
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

final selectedApplicantProfile =
    StateProvider<ApplicantContestModel?>((ref) => null);

final authRepositoryProvider = Provider((ref) => ContestRepo());

final votersContestNotifier =
    StateNotifierProvider<VotersContestNotifier, VoterDetailState>(
  (ref) {
    return VotersContestNotifier(
        ContestRepo(), WayaLocalDataSource(), WalletRepository.instance);
  },
);

final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

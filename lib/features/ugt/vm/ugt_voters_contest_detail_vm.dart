import 'dart:io';

import 'package:flutter/material.dart' hide State;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/quotation/data/model/model.dart';
import 'package:wayagram/features/ugt/create_contest_post/create_contest_post.dart';
import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_all_post_contest_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_contest_aplicant_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart' as model;
import 'package:wayagram/features/ugt/data/model/voter_contest_state.dart';
import 'package:wayagram/features/ugt/data/model/voter_user_list_model.dart';

import 'package:wayagram/features/ugt/data/repository/ContestRepo.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/wallet/data/model/external_wallet_model.dart';
import 'package:wayagram/features/wallet/data/model/wallet_model.dart';

import 'package:wayagram/features/wallet/data/repo/wallet_repository.dart';
import 'package:wayagram/shared/features/file/repo/default.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';
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
    //?check if balance is Zero and return insufficient balance
    /*  if (int.parse(state.data?.balance ?? "0") == 0) {
      WayaSnackBar.showToast(
        "Insufficient Balance!!!",
      );
      return false;
    } */
    isLoading.value = true;

    final response = await _walletRepository!.confirmWalletPin(ConfirmWalletPin(
        userId: _localDataSource.getUserId().toString(), pin: pin));
    if (response.success) {
      debugPrint(map.toString());
      return await voteContestant(isLoading, map);
    } else {
      if (response.data["message"] == null) {
        WayaSnackBar.showToast(
          "An error occurred",
        );
        return false;
      }
      WayaSnackBar.showToast(
        response.data["message"],
      );
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> verifyAndPayForPaidContest(ValueNotifier<bool> isLoading,
      String pin, Map<String, String> map) async {
    isLoading.value = true;
    final response = await _walletRepository!.confirmWalletPin(
      ConfirmWalletPin(
          userId: _localDataSource.getUserId().toString(), pin: pin),
    );
    debugPrint(map.toString());
    if (response.success) {
      // map[] =  _localDataSource.getUserId().toString();
      return await payForPaidContest(isLoading, map);
    } else {
      WayaSnackBar.showToast(
        response.data["message"],
      );
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> verifyAndPayForPaidStageContest(ValueNotifier<bool> isLoading,
      String pin, Map<String, String> map) async {
    isLoading.value = true;
    final response = await _walletRepository!.confirmWalletPin(ConfirmWalletPin(
        userId: _localDataSource.getUserId().toString(), pin: pin));
    debugPrint(map.toString());
    if (response.success) {
      // map[] =  _localDataSource.getUserId().toString();
      return await payForPaidStageContest(isLoading, map);
    } else {
      if (response.data["message"] == null) {
        WayaSnackBar.showToast(
          "An error occurred",
        );
        return false;
      }
      WayaSnackBar.showToast(
        response.data["message"],
      );
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> voteContestant(
      ValueNotifier<bool> isLoading, Map<String, String> map) async {
    isLoading.value = true;
    map["profileId"] = _localDataSource.getUserId().toString();
    final response = await _contestRepository.voteContestant(map);
    isLoading.value = false;
    if (response.success) {
      return true;
    } else {
      if (response.data["message"] == null) {
        WayaSnackBar.showToast(
          "An error occurred",
        );
        return false;
      }
      WayaSnackBar.showToast(
        response.data["message"],
      );

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
      if (response.data["message"] == null) {
        WayaSnackBar.showToast(
          "An error occurred",
        );
        return false;
      }
      WayaSnackBar.showToast(
        response.data["message"],
      );
      return false;
    }
  }

  Future<bool> deletePost(ValueNotifier<bool> isLoading, String postId,
      String contestId, VoidCallback onTap) async {
    final response = await _contestRepository.deletePost(postId);
    isLoading.value = false;
    if (response.success) {
      onTap();
      WayaSnackBar.showToast("Post Deleted Successfully", showSuccess: true);
      fetchAllContestPosts(contestId);
      return true;
    } else {
      WayaSnackBar.showToast(
        response.data["message"],
      );
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
      WayaSnackBar.showToast(
        response.data["message"],
      );
      return false;
    }
  }

  Future<bool> startStageContest(
      String stageName, Map<String, String> map) async {
    debugPrint("mapkkkk $map");
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
      WayaSnackBar.showToast(
        response.data["message"],
      );
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
      WayaSnackBar.showToast(
        response.data["message"],
      );
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
      WayaSnackBar.showToast(
        response.data["message"],
      );
      return false;
    }
  }

  Future<bool> acceptPaidStageContest(
      String contestId, Map<String, String> map) async {
    final response = await _contestRepository.acceptPaidStageContest(map);
    // isLoading.value = false;
    if (response.success) {
      fetchAllContestApplicant(contestId);
      getContestantProfileVoteDetails(contestId);

      return true;
    } else {
      WayaSnackBar.showToast(
        response.data["message"],
      );
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
      WayaSnackBar.showToast(
        response.data["message"],
      );
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
      WayaSnackBar.showToast(
        response.data["message"],
      );
      state = state.copyWith(isLoading: false);
    }
  }

  String? getLoggedInUserId() {
    return _localDataSource.getUserId().toString();
  }

  void changeActive(bool isActive) {
    state = state.copyWith(isActive: isActive);
  }

  bool getActive() {
    return state.isActive ?? false;
  }

  Future<void> getContestantProfileVoteDetails(String contestId) async {
    try {
      final response =
          await _contestRepository.getContestantProfileVoteDetails(contestId);
      List<MyContestContestantModel> contestList = [];

      if (response.success) {
        /*  state = state.copyWith(
          myContestList: [],
          myContestListCopy: [],
        ); */

        ContestContestantModelMean responseModel =
            ContestContestantModelMean.fromJson(response.data);
        contestList = responseModel.data?.docs ?? [];

        MyContestContestantModel? model;

        contestList.sort((a, b) => b.votes!.compareTo(a.votes!));

        //? this may not contain what i am looking for that y i am using try here
        try {
          model = contestList.firstWhere(
              (e) => e.profileId == _localDataSource.getUserId().toString());
        } catch (e) {
          debugPrint(e.toString());
        }

        // createPostId = ;
        final myContestantList = contestList.where((e) {
          print("ErrorOLODO ${e.status?.toLowerCase()}");
          return e.status?.toLowerCase() == "active" &&
              e.contestApplicant != null;
        }).toList();
        final myContestantList2 = contestList.where((e) {
          return e.contestApplicant != null;
        }).toList();

        state = state.copyWith(
            myContestList: myContestantList,
            myContestListCopy: myContestantList,
            myFullContestantList: myContestantList2,
            createPostId: model?.id ?? "");

        updateStateList(contestList);
        // _page++;
        //isLoading = false;
      }
      // return contestList;
    } catch (e) {
      print("ErrorOLODO , ${e.toString()}}");
      _logger.e(e.toString());
    } finally {
      // isLoading = false;
    }
  }

  void updateStateList(List<MyContestContestantModel> contestList) {
    Map<String, int> mapState = {};
    var listStates = <State>[];
    var listStates2 = <State>[];
    // var myState = [];

    for (var model in states) {
      if (model.id != "1") {
        listStates2.add(State(state: model.state, id: model.id));
      }
    }

    for (int i = 0; i < listStates2.length; i++) {
      mapState[listStates2[i].state] = 0;
    }
    for (var contestantModel in contestList) {
      String contestantState = contestantModel.contestApplicant?.state ?? "";

      // Increment count or initialize to 1
      if (mapState.containsKey(contestantState)) {
        mapState[contestantState] = (mapState[contestantState] ?? 0) + 1;
      }
    }

    for (var entry in mapState.entries) {
      print("ErrorOLODO ${entry.key}  ${entry.value.toString()},");
      listStates.add(State(state: entry.key, id: entry.value.toString()));
    }
    listStates.sort((a, b) => b.id.compareTo(a.id));
    state = state.copyWith(listState: listStates);
  }

  void filterByState(String stateName) {
    state = state.copyWith(selectedState: stateName);
    var listContestant = <MyContestContestantModel>[];
    for (var contestantModel in state.myFullContestantList) {
      String contestantState = contestantModel.contestApplicant?.state ?? "";

      if (stateName.toLowerCase() == contestantState) {
        listContestant.add(contestantModel);
      }
    }
    state = state.copyWith(selectedStateContestants: listContestant);
  }

  Future<void> fetchAllContestPosts(String id, {hostApproved = true}) async {
    try {
      final response =
          await _contestRepository.fetchAllContestGallery(id, hostApproved);
      List<UgtAllPostContestModel> contestList = [];
      if (response.success) {
        UgtAllPostContestModelBase responseModel =
            UgtAllPostContestModelBase.fromJson(response.data);
        contestList = responseModel.data?.docs ?? [];

        List<UgtAllPostContestModel> contestList2 = [];
        for (var model in contestList) {
          // print('Hello name one ${model.profileId}');
          var data = await UserResource.getUserDetails(
              model.contestantProfile?.profileId ?? "");
          var userModel = data?.$2;
          var userModel1 = data?.$1;
          print('Hello name one');

          print('Hello ${userModel?.toJson()}');
          print('Hello 2 ${userModel1?.toJson()}');
          print('Hello name one ${userModel?.displayName ?? ""}');
          model.fullName = userModel?.displayName ?? "";
          contestList2.add(model);
        }
        state = state.copyWith(myPostList: contestList2);

        if (state.isActive == false && !hostApproved) {
          state = state.copyWith(pendingPostCount: contestList.length);
        }
      }
    } catch (e) {
      //debugPrint(e.toString());
    } finally {}
  }

  Future<void> fetchAllContestUnApprovedPosts(String id,
      {hostApproved = true}) async {
    try {
      final response =
          await _contestRepository.fetchAllContestGallery(id, hostApproved);
      List<UgtAllPostContestModel> contestList = [];
      if (response.success) {
        UgtAllPostContestModelBase responseModel =
            UgtAllPostContestModelBase.fromJson(response.data);
        contestList = responseModel.data?.docs ?? [];

        //  state = state.copyWith(myPostList: contestList);

        state = state.copyWith(pendingPostCount: contestList.length);
      }
    } catch (e) {
      //debugPrint(e.toString());
    } finally {}
  }

  void approveDisapprovePost(String galleryId) async {
    // debugPrint("do like stuff");
    final response = await _contestRepository.approveDisapprovePost(galleryId);

    if (response.success) {
      WayaSnackBar.showToast("Post status updated successfully",
          showSuccess: true);
    } else {
      WayaSnackBar.showToast("unable to update post status");
      //  debugPrint("Contest already liked");
    }
  }

  Future<void> fetchAllContestApplicant(String id) async {
    try {
      final response = await _contestRepository.fetchAllContestApplicant(id);
      List<ApplicantContestModel> contestList = [];
      if (response.success) {
        ApplicantContestModelBase responseModel =
            ApplicantContestModelBase.fromJson(response.data);
        contestList = responseModel.data ?? [];
        var myFilteredListt = contestList
            .where((e) => e.status?.toLowerCase() == "pending")
            .toList();

        state = state.copyWith(
            myContestApplicantList: contestList,
            myFilteredContestApplicantList: myFilteredListt);
      }
    } catch (e) {
      //debugPrint(e.toString());
    } finally {}
  }

  Future<void> fetchVotersList(String contestantId, bool isFirst) async {
    if (state.isLastPage && isFirst == false) {
      return;
    }
    if (state.isLoading == true) {
      return;
    }

    try {
      try {
        state = state.copyWith(isLoading: true);
      } catch (e) {
        debugPrint(e.toString());
      }
      final response = await _contestRepository.fetchVoterList(
          contestantId, isFirst ? 1 : state.page);
      // List<VoterListBaseModel> contestList = [];
      if (response.success) {
        VoterListBaseModel responseModel =
            VoterListBaseModel.fromJson(response.data);
        state = state.copyWith(
            isLastPage: responseModel.data?.hasNextPage == true ? false : true);
        List<VoterListModel> votersList = [];
        for (VoterListModel model in responseModel.data?.docs ?? []) {
          var data = await UserResource.getUserDetails(model.profileId ?? "");
          var userModel = data?.$1;
          model.name = userModel?.fullname ?? "";
          model.profileImageUrl = userModel?.profilePicture ?? "";
          votersList.add(model);
        }

        if (isFirst) {
          state = state.copyWith(userVotersList: votersList, page: 1);
        } else {
          state = state.copyWith(
              userVotersList: [...state.userVotersList ?? [], ...votersList]);
        }

        // state = state.copyWith(userVotersList: responseModel.data?.docs ?? []);
        // contestList = responseModel.data.docs ?? [];
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      //debugPrint(e.toString());
    } finally {}
  }

  void searchList(String value) {
    if (value.trim().isEmpty) {
      debugPrint("i am here $value");
      state = state.copyWith(myContestList: state.myContestListCopy);
    } else {
      debugPrint("i am yyyyyy $value");
      var myList = state.myContestListCopy;
      state = state.copyWith(
          myContestList: myList.where((e) {
        String name = e.contestApplicant?.fullName ?? "";
        return name.toLowerCase().contains(value.toLowerCase());
      }).toList());
      debugPrint("i am rrrrrr $value");
    }
  }

  void uploadCreatePost(
      WidgetRef ref,
      BuildContext context,
      ValueNotifier<bool> isLoading,
      String text,
      List<MyMediaType> selectedImages,
      File? videoFile,
      String fileExtention,
      String s,
      String contestId,
      VoidCallback onBackPressed) async {
    List<String> imageUrls = [];
    String? videoUrl;
    isLoading.value = true;

    for (var model in selectedImages) {
      if (!model.type) {
        String mimeType = WayaHelpers.getContentTypeFromPath(model.path) ?? "";

        final imageUrl = await WayaFileRepository.instance.uploadFile(
            File(model.path),
            "ugt-image-${Uuid().v4()}.${mimeType.split("/").last}");
        imageUrls.add(imageUrl ?? "");
      }
    }
    if (videoFile != null) {
      String mimeType =
          WayaHelpers.getContentTypeFromPath(videoFile.path) ?? "";

      videoUrl = await WayaFileRepository.instance.uploadFile(
          File(videoFile.path),
          "ugt-video-${Uuid().v4()}.${mimeType.split("/").last}");
    }

    List<Map<String, dynamic>> listMap = [];
    for (var myImage in imageUrls) {
      listMap.add({"type": "IMAGE", "url": myImage});
    }
    if (videoUrl != null) {
      listMap.add({"type": "VIDEO", "url": videoUrl});
    }
    // listMap.add({"type": "TEXT", "url": text});

    var map = {
      "contestantProfileId": state.createPostId,
      // "contestantProfileId": _localDataSource.getUserId(),
      "contestId": contestId,
      "description": text,
      "mediaContent": listMap
    };
    debugPrint('wert $map');
    final response = await _contestRepository.createContestPost(map);
    isLoading.value = false;
    if (response.success) {
      WayaSnackBar.showToast("Post created successfully!", showSuccess: true);
      getContestantProfileVoteDetails(
          ref.read(selectedContestProvider.notifier).state?.id ?? "");

      Future.delayed(
        Duration(seconds: 2),
        () {
          onBackPressed();
        },
      );
    } else {
      WayaSnackBar.showToast(response.data["message"]);
    }
  }

  void updateContestId(String? id) {
    state = state.copyWith(contestId: id);
  }

  void updateContestantId(String? id) {
    state = state.copyWith(createPostId: id);
  }

  void toggleLike(String postId, String galleryId) {
    // Contest? contestPost = null;
    debugPrint("Contest for you");
    //state.copyWith(myPostList: contestList)
    var list = state.myPostList.map((post) {
      debugPrint("i dey here 11");
      if (post.id == galleryId) {
        debugPrint("i dey here 2");
        bool isMyLiked = post.hasLiked ?? false;
        // if (isMyLiked) {
        doOnLikeLike(postId, galleryId);
        //  }
        return post.copyWith(
          hasLiked: !isMyLiked,
          likes: isMyLiked ? post.likes! - 1 : post.likes! + 1,
        );
      }
      return post;
    }).toList();
    state = state.copyWith(myPostList: [...list]);
  }

  void doOnLikeLike(String postId, String galleryId) async {
    // debugPrint("do like stuff");
    final response = await _contestRepository.likeContest({
      "profileId": _localDataSource.getUserId().toString(),
      "contestId": postId,
      "galleryId": galleryId
    });

    if (!response.success) {
      //  debugPrint("do like stuff Fail");
      var list = state.myPostList.map((post) {
        debugPrint("i dey here 3");
        if (post.id == postId) {
          debugPrint("i dey here 3");
          bool isMyLiked = post.hasLiked ?? false;
          return post.copyWith(
            hasLiked: !isMyLiked,
            likes: isMyLiked ? post.likes! - 1 : post.likes! + 1,
          );
        }
        return post;
      }).toList();
      state = state.copyWith(myPostList: [...list]);
      //  WayaSnackBar.showToast("Unable to like, Please try again");
    } else {
      // WayaSnackBar.showToast("Contest already liked");
      debugPrint("Contest already liked");
    }
  }

  void toggleShare(String postId, String galleryId) {
    // Contest? contestPost = null;

    var list = state.myPostList.map((post) {
      debugPrint("i dey here wwww");
      if (post.id == postId) {
        debugPrint("i dey here pppppp");
        return post.copyWith(
          // isLiked: true,
          shares: post.shares! + 1,
        );
      }
      return post;
    }).toList();
    debugPrint("i dey here pppppp");
    state = state.copyWith(myPostList: [...list]);
    doshare(postId, galleryId);
  }

  void doshare(String postId, String galleryId) async {
    // debugPrint("do like stuff");
    final response = await _contestRepository.shareContest({
      "profileId": _localDataSource.getUserId().toString(),
      "contestId": postId,
      "galleryId": galleryId
    });

    if (!response.success) {
      //  debugPrint("do like stuff Fail");

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
      debugPrint("do like stuff Success");
    }
  }

  void addStages(List<model.Stage> stages) {
    state = state.copyWith(stageList: stages);
  }

  void doFollow(String postId) async {
    // debugPrint("do like stuff");
    final response = await _contestRepository.followContest({
      "profileId": _localDataSource.getUserId().toString(),
      "contestId": postId
    });

    if (response.success) {
      //  debugPrint("do like stuff Fail");

      WayaSnackBar.showToast("Contest Followed", showSuccess: true);
    } else {
      debugPrint("do like stuff Success");
    }
  }
}

/* 
  Future<void> createPost(ctx, content, postType, List<XFile> images) async {
    debugPrint("before the loop");
    List<UploadedImage> urls = [];
    List<String> publicUrl = [];
    final choiceMap = <String>[];
    // get url
    for (XFile image in images) {
      debugPrint("In the loop ${image.name} ${image.path} ${image.mimeType}");

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
      debugPrint("Data ${putImageResponse.data}");
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
        debugPrint('Create post');
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

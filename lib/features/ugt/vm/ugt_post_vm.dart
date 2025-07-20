import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/features/ugt/data/model/context_for_you_state.dart';
import 'package:wayagram/features/ugt/data/model/single_contestant_profile.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/data/repository/ContestRepo.dart';
import 'package:wayagram/features/ugt/vm/ugt_contestant_profile_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';

class ContestForYou extends StateNotifier<ContextForYouState> {
  final ContestRepo _contestRepository;
  final WayaLocalDataSource _localDataSource;

  ContestForYou(this._contestRepository, this._localDataSource)
      : super(ContextForYouState(page: 1));

  bool isLoading = false;

  //? Simulate fetching paginated posts
  Future<void> fetchContestForYou(bool isFirst) async {
    try {
      if (state.isLastPage && isFirst == false) {
        return;
      }

      if (state.isLoading == true) {
        return;
      }

      //  state = state.copyWith(isLoading: true);
    } catch (e) {
      debugPrint(e.toString());
      //  state = state.copyWith(isLoading: false);
      return;
    }

    try {
      final response = await _contestRepository.getContestForYou(
          isFirst ? 1 : state.page, state.filter);
      //  List<Contest> contestList = [];
      if (response.success) {
        ContestResponse responseModel = ContestResponse.fromJson(response.data);
        // contestList = responseModel.data?.docs ?? [];
        state = state.copyWith(
            isLastPage: responseModel.data?.hasNextPage == true ? false : true);
        if (isFirst) {
          state = state.copyWith(
              listContestForYou: responseModel.data?.docs ?? [], page: 1);
        } else {
          state = state.copyWith(listContestForYou: [
            ...state.listContestForYou,
            ...responseModel.data?.docs ?? []
          ]);
        }
        state = state.copyWith(page: state.page + 1);

        state = state.copyWith(isLoading: false);
      }
      // return contestList;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint(e.toString());
    } finally {}
  }

  void updateFilter(String? filter) {
    state = state.copyWith(filter: filter);

    fetchContestForYou(true);
  }

  Future<Contest?> fetchSingleContest(
      {required String contestId, WidgetRef? ref}) async {
    try {
      final response = await _contestRepository.fetchSingleContest(contestId);
      Contest? contest;
      if (response.success) {
        ContestResponse responseModel = ContestResponse.fromJson(response.data);
        contest = responseModel.data?.docs?.first;
        if (ref != null) {
          ref.read(selectedContestProvider.notifier).state = contest;
        }
      }
      return contest;
    } catch (error) {
      return null;
    }
  }

  //> generate video preview
  Future<File?> generateVideoPreview(String videoPath) async {
    final thumb = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 250,
      quality: 60,
    );

    return File(thumb.path);
  }

  Future<SingleContestProfileBase?> fetchSingleContestantDetails(
      WidgetRef ref, String contestId, String contestantProfileId) async {
    try {
      final response = await _contestRepository.fetchSingleContestantDetails(
          contestId, contestantProfileId);
      //  SingleContestProfile? contest;
      if (response.success) {
        SingleContestProfileBase responseModel =
            SingleContestProfileBase.fromJson(response.data);

        ref.read(selectedContestantProfile.notifier).state =
            responseModel.data?.docs?.first;

        ref.watch(ugtContestantProfileVm.notifier).fetchSingleContestantPosts(
            responseModel.data?.docs?.first.id ?? "");

        return responseModel;
      }
      // return contestList;
    } finally {}
    return null;
  }

  // Toggle Like
  void toggleLike(String postId) {
    // Contest? contestPost = null;
    debugPrint("Contest for you");
    state = state.copyWith(
        listContestForYou: state.listContestForYou.map((post) {
      if (post.id == postId) {
        doOnLikeLike(postId);
        bool value = post.hasLiked == null ? false : post.hasLiked ?? false;

        return post.copyWith(
          hasLiked: !value,
          likeCount: value ? post.likeCount! - 1 : post.likeCount! + 1,
        );
      }
      return post;
    }).toList());
  }

  void doOnLikeLike(String postId) async {
    // debugPrint("do like stuff");
    final response = await _contestRepository.likeContest({
      "profileId": _localDataSource.getUserId().toString(),
      "contestId": postId
    });

    if (!response.success) {
      //  debugPrint("do like stuff Fail");
      state = state.copyWith(
          listContestForYou: state.listContestForYou.map((post) {
        if (post.id == postId) {
          bool value = post.hasLiked == null ? false : post.hasLiked ?? false;

          return post.copyWith(
            hasLiked: !value,
            likeCount: value ? post.likeCount! - 1 : post.likeCount! + 1,
          );
        }
        return post;
      }).toList());
      //  WayaSnackBar.showToast("Unable to like, Please try again");
    } else {
      //WayaSnackBar.showToast("Contest already liked");
      debugPrint("Contest already liked");
    }
  }

  void doFollow(String postId) async {
    // debugPrint("do like stuff");
    final response = await _contestRepository.followContest({
      "profileId": _localDataSource.getUserId().toString(),
      "contestId": postId
    });
    state = state.copyWith(
        listContestForYou: state.listContestForYou.map((post) {
      if (post.id == postId) {
        bool value =
            post.isFollowing == null ? false : post.isFollowing ?? false;
        return post.copyWith(
          // isLiked: true,
          isFollowing: !value,
        );
      }
      return post;
    }).toList());
    doshare(postId);

    if (response.success) {
      //  debugPrint("do like stuff Fail");

      // WayaSnackBar.showToast("Contest followed", showSuccess: true);
    } else {
      debugPrint("do like stuff Success");
    }
  }

  void toggleShare(String postId) {
    // Contest? contestPost = null;
    state = state.copyWith(
        listContestForYou: state.listContestForYou.map((post) {
      if (post.id == postId) {
        return post.copyWith(
          // isLiked: true,
          shareCount: post.shareCount! + 1,
        );
      }
      return post;
    }).toList());
    doshare(postId);
  }

  void doshare(String postId) async {
    // debugPrint("do like stuff");
    final response = await _contestRepository.shareContest({
      "profileId": _localDataSource.getUserId().toString(),
      "contestId": postId
    });

    if (!response.success) {
      //  debugPrint("do like stuff Fail");
      state = state.copyWith(
          listContestForYou: state.listContestForYou.map((post) {
        if (post.id == postId) {
          return post.copyWith(
            hasLiked: !post.hasLiked!,
            likeCount: post.likeCount! - 1,
          );
        }
        return post;
      }).toList());
      //  WayaSnackBar.showToast("Unable to like, Please try again");
    } else {
      debugPrint("do like stuff Success");
    }
  }

  // Toggle Follow
/*   void toggleFollow(String postId) {
    state = state.map((post) {
      if (post.id == postId) {
        return post.copyWith(isFollowing: !post.isFollowing!);
      }
      return post;
    }).toList();
  } */
}

final selectedContestProvider = StateProvider<Contest?>((ref) {
  return null;
});
// Provider
final postProvider =
    StateNotifierProvider<ContestForYou, ContextForYouState>((ref) {
  return ContestForYou(ContestRepo(), WayaLocalDataSource());
});

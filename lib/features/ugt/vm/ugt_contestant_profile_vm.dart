import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/features/ugt/data/model/ugt_single_contestant_profile_model.dart';
import 'package:wayagram/features/ugt/data/repository/contest_repo.dart';

class UgtContestantProfileVm extends StateNotifier<List<SingleContestantPosts>> {
  final ContestRepo _contestRepository;
  final WayaLocalDataSource _localDataSource;

  UgtContestantProfileVm(this._contestRepository, this._localDataSource) : super([]);

  int page = 1; // Pagination tracking
  bool isLoading = false;

  // Simulate fetching paginated posts
  Future<void> fetchSingleContestantPosts(String id) async {
    if (isLoading) return;
    isLoading = true;

    try {
      final response = await _contestRepository.fetchSingleContestantGallery(id);
      List<SingleContestantPosts> contestList = [];
      if (response.success) {
        SingleContestantPostsBase responseModel = SingleContestantPostsBase.fromJson(response.data);
        contestList = responseModel.data?.docs ?? [];
        //  state = [...state, ...contestList];
        state = [...contestList];
        page++;
        isLoading = false;
      }
      // return contestList;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
    }
  }

  void toggleLike(String postId, String galleryId) {
    // Contest? contestPost = null;
    debugPrint("Contest for you");
    //state.copyWith(myPostList: contestList)
    state = state.map((post) {
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
    //state = state.copyWith(myPostList: [...list]);
  }

  void doOnLikeLike(String postId, String galleryId) async {
    // debugPrint("do like stuff");
    final response = await _contestRepository.likeContest(
        {"profileId": _localDataSource.getUserId().toString(), "contestId": postId, "galleryId": galleryId});

    if (!response.success) {
      //  debugPrint("do like stuff Fail");
      state = state.map((post) {
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
      // state = state.copyWith(myPostList: [...list]);
      //  WayaSnackBar.showToast("Unable to like, Please try again");
    } else {
      // WayaSnackBar.showToast("Contest already liked");
      debugPrint("Contest already liked");
    }
  }

  void toggleShare(String postId) {
    // Contest? contestPost = null;

    state = state.map((post) {
      debugPrint("i dey here wwww");
      if (post.id == postId) {
            return post.copyWith(
          // isLiked: true,
          shares: post.shares! + 1,
        );
      }
      return post;
    }).toList();
    //  state = state.copyWith(myPostList: [...list]);
    doShare(postId);
  }

  void doShare(String postId) async {
    // debugPrint("do like stuff");
    final response = await _contestRepository.shareContest({
      "profileId": _localDataSource.getUserId().toString(),
      "contestId": postId,
    });

    if (!response.success) {
      //  debugPrint("do like stuff Fail");

      state = state.map((post) {
        if (post.id == postId) {
          return post.copyWith(
            shares: post.shares! + 1,
          );
        }
        return post;
      }).toList();
      //  state = state.copyWith(myPostList: [...list]);
      //  WayaSnackBar.showToast("Unable to like, Please try again");
    } else {
      debugPrint("do like stuff Success");
    }
  }
}

/* final selectedContestProvider = StateProvider<Contest?>((ref) {
  return null;
}); */
// Provider
final ugtContestantProfileVm = StateNotifierProvider<UgtContestantProfileVm, List<SingleContestantPosts>>((ref) {
  return UgtContestantProfileVm(ContestRepo(), WayaLocalDataSource());
});

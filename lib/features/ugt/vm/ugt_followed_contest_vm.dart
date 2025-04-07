import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/data/repository/ContestRepo.dart';

class FollowedContestNotifier extends StateNotifier<List<Contest>> {
  final ContestRepo _contestRepository;
  final WayaLocalDataSource _localDataSource;

  FollowedContestNotifier(this._contestRepository, this._localDataSource)
      : super([]);

  int _page = 1; // Pagination tracking
  bool isLoading = false;

  Future<void> fetchFollowedPosts() async {
    if (isLoading) return;
    isLoading = true;

    try {
      final response = await _contestRepository
          .fetchFollowedVoteContest(_localDataSource.getUserId().toString());
      List<Contest> contestList = [];
      if (response.success) {
        ContestResponse responseModel = ContestResponse.fromJson(response.data);
        contestList = responseModel.data?.docs??[];
        state = [...state, ...contestList];
         _page++;
        isLoading = false;
      }
      // return contestList;
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }

  // Toggle Like
  void toggleLike(String postId) {
    // Contest? contestPost = null;
     print("Contest followed post");
    state = state.map((post) {
      if (post.id == postId) {
        if (!post.hasLiked!) {
          doOnLikeLike(postId);
        }
        return post.copyWith(
          hasLiked: true,
          likeCount: post.likeCount! + 1,
        );
      }
      return post;
    }).toList();
  }

  void doOnLikeLike(String postId) async {
    // print("do like stuff");
    final response = await _contestRepository.likeContest({
      "profileId": _localDataSource.getUserId().toString(),
      "contestId": postId
    });

    if (!response.success) {
      //  print("do like stuff Fail");
      state = state.map((post) {
        if (post.id == postId) {
          return post.copyWith(
            hasLiked: !post.hasLiked!,
            likeCount: post.likeCount! - 1,
          );
        }
        return post;
      }).toList();
      //  WayaSnackBar.showToast("Unable to like, Please try again");
    } else {
      // WayaSnackBar.showToast("Contest already liked");
      print("Contest already liked");
    }
  }

  void toggleShare(String postId) {
    // Contest? contestPost = null;
    state = state.map((post) {
      if (post.id == postId) {
        return post.copyWith(
          // isLiked: true,
          shareCount: post.shareCount! + 1,
        );
      }
      return post;
    }).toList();
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
      state = state.map((post) {
        if (post.id == postId) {
          return post.copyWith(
            hasLiked: !post.hasLiked!,
            likeCount: post.likeCount! - 1,
          );
        }
        return post;
      }).toList();
      //  WayaSnackBar.showToast("Unable to like, Please try again");
    } else {
      print("do like stuff Success");
    }
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

// Provider
final followedContestProvider =
    StateNotifierProvider<FollowedContestNotifier, List<Contest>>((ref) {
  return FollowedContestNotifier(ContestRepo(), WayaLocalDataSource());
});

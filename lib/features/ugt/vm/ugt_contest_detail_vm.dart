import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/data/repository/contest_repo.dart';

class ContestDetailNotifier extends StateNotifier<List<Contest>> {
  final ContestRepo _contestRepository;
  final WayaLocalDataSource _localDataSource;

  ContestDetailNotifier(this._contestRepository, this._localDataSource)
      : super([]);

  final int _page = 1; // Pagination tracking
  bool isLoading = false;

  // Simulate fetching paginated posts
  Future<void> fetchHostedContest() async {
    if (isLoading) return;
    isLoading = true;

    /*   await Future.delayed(Duration(seconds: 2)); // Simulating API call

    List<Post> newPosts = List.generate(10, (index) {
      int postNumber = (_page - 1) * 10 + index + 1;
      return Post(
        id: "post_$postNumber",
        content: "This is post $postNumber",
        author: "Author $postNumber",
        likes: postNumber,
      );
    });
 */
    try {
      final response = await _contestRepository.fetchHostedContest(
          _localDataSource.getUserId().toString(), _page);
      List<Contest> contestList = [];
      if (response.success) {
        state = [];
        ContestResponse responseModel = ContestResponse.fromJson(response.data);
        contestList = responseModel.data?.docs ?? [];
        state = [...state, ...contestList];
        // _page++;
        isLoading = false;
      }
      // return contestList;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
    }
  }

/*   // Toggle Like
  void toggleLike(String postId) {
    // Contest? contestPost = null;
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
  } */

  // Toggle Like
  void toggleLike(String postId) {
    // Contest? contestPost = null;
    state = state.map((post) {
      if (post.id == postId) {
        doOnLikeLike(postId);
        bool value = post.hasLiked == null ? false : post.hasLiked ?? false;

        return post.copyWith(
          hasLiked: !value,
          likeCount: value ? post.likeCount! - 1 : post.likeCount! + 1,
        );
      }
      return post;
    }).toList();
  }

  void doOnLikeLike(String postId) async {
    final response = await _contestRepository.likeContest({
      "profileId": _localDataSource.getUserId().toString(),
      "contestId": postId
    });

    if (!response.success) {
      state = state.map((post) {
        if (post.id == postId) {
          bool value = post.hasLiked == null ? false : post.hasLiked ?? false;

          return post.copyWith(
            hasLiked: !value,
            likeCount: value ? post.likeCount! - 1 : post.likeCount! + 1,
          );
        }
        return post;
      }).toList();
      //  WayaSnackBar.showToast("Unable to like, Please try again");
    } else {
      //WayaSnackBar.showToast("Contest already liked");
    }
  }

  void doFollow(String postId) async {
    final response = await _contestRepository.followContest({
      "profileId": _localDataSource.getUserId().toString(),
      "contestId": postId
    });
    state = state.map((post) {
      if (post.id == postId) {
        bool value =
            post.isFollowing == null ? false : post.isFollowing ?? false;
        return post.copyWith(
          // isLiked: true,
          isFollowing: !value,
        );
      }
      return post;
    }).toList();
    doShare(postId);

    if (response.success) {
      // WayaSnackBar.showToast("Contest followed", showSuccess: true);
    } else {}
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
    doShare(postId);
  }

  void doShare(String postId) async {
    final response = await _contestRepository.shareContest({
      "profileId": _localDataSource.getUserId().toString(),
      "contestId": postId
    });

    if (!response.success) {
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
    } else {}
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
final contestDetailProvider =
    StateNotifierProvider<ContestDetailNotifier, List<Contest>>((ref) {
  final contestRepo = ref.watch(contestRepositoryProvider);
  return ContestDetailNotifier(contestRepo, WayaLocalDataSource());
});

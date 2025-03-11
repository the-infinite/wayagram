import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/features/ugt/data/model/ugt_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_single_contestant_profile_model.dart';
import 'package:wayagram/features/ugt/data/repository/ContestRepo.dart';

class UgtContestantProfileVm extends StateNotifier<List<SingleContestantPosts>> {
  final ContestRepo _contestRepository;
  final WayaLocalDataSource _localDataSource;

  UgtContestantProfileVm(this._contestRepository, this._localDataSource) : super([]);

  int _page = 1; // Pagination tracking
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

  
  void toggleLike(String postId) {
    // Contest? contestPost = null;
    print("Contest for you");
    //state.copyWith(myPostList: contestList)
   state = state.map((post) {
      print("i dey here 11");
      if (post.id == postId) {
        print("i dey here 2");
       bool isMyLiked = post.hasLiked ?? false;
        // if (isMyLiked) {
          doOnLikeLike(postId);
      //  }
        return post.copyWith(
          hasLiked: !isMyLiked,
          likes:isMyLiked?post.likes! - 1: post.likes! + 1,
        );
      }
      return post;
    }).toList();
   // state = state.copyWith(myPostList: [...list]);
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
        print("i dey here 3");
        if (post.id == postId) {
          print("i dey here 3");
           bool isMyLiked = post.hasLiked ?? false;
          return post.copyWith(
            hasLiked: !isMyLiked,
            likes:isMyLiked?post.likes! - 1: post.likes! + 1,
          );
        }
        return post;
      }).toList();
     // state = state.copyWith(myPostList: [...list]);
      //  WayaSnackBar.showToast("Unable to like, Please try again");
    } else {
      // WayaSnackBar.showToast("Contest already liked");
      print("Contest already liked");
    }
  }

  void toggleShare(String postId) {
    // Contest? contestPost = null;

     state = state.map((post) {
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
  //  state = state.copyWith(myPostList: [...list]);
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
            shares: post.shares! + 1,
          );
        }
        return post;
      }).toList();
    //  state = state.copyWith(myPostList: [...list]);
      //  WayaSnackBar.showToast("Unable to like, Please try again");
    } else {
      print("do like stuff Success");
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

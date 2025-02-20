import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/ugt/data/model/ugt_model.dart';

class PostNotifier extends StateNotifier<List<Post>> {
  PostNotifier() : super([]);

  int _page = 1; // Pagination tracking
  bool isLoading = false;

  // Simulate fetching paginated posts
  Future<void> fetchPosts() async {
    if (isLoading) return;
    isLoading = true;

    await Future.delayed(Duration(seconds: 2)); // Simulating API call

    List<Post> newPosts = List.generate(10, (index) {
      int postNumber = (_page - 1) * 10 + index + 1;
      return Post(
        id: "post_$postNumber",
        content: "This is post $postNumber",
        author: "Author $postNumber",
        likes: postNumber,
      );
    });

    state = [...state, ...newPosts];
    _page++;
    isLoading = false;
  }

  // Toggle Like
  void toggleLike(String postId) {
    state = state.map((post) {
      if (post.id == postId) {
        return post.copyWith(
          isLiked: !post.isLiked,
          likes: post.isLiked ? post.likes - 1 : post.likes + 1,
        );
      }
      return post;
    }).toList();
  }

  // Toggle Follow
  void toggleFollow(String postId) {
    state = state.map((post) {
      if (post.id == postId) {
        return post.copyWith(isFollowing: !post.isFollowing);
      }
      return post;
    }).toList();
  }
}

// Provider
final postProvider = StateNotifierProvider<PostNotifier, List<Post>>((ref) {
  return PostNotifier();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/post/model/post_reponse_model.dart';
import 'package:wayagram/shared/features/posts/repo/default.dart';
import 'package:wayagram/shared/features/posts/state/default.dart';

class PostNotifier extends StateNotifier<PostState> {
  final repo = PostRepository.instance;
  PostNotifier(super.state);

  /// An API used to fetch all the posts for a given user.
  Future<List<Post>> getPostsForUser(String id) async {
    final result = <Post>[];

    //try {
      // This is fine too.
      final response = await repo.getPostsForUser(id, state.nextPage ?? state.page, state.limit);

      // If this was fine...
      if (response.success) {
        final data = response.data["data"];

        //? Parse the posts as they are in the response object...
        final docs = (data['docs'] as List).map((doc) => Post.fromJson(doc));

        //? Now, add these to what we have here.
        result.addAll(docs);

        //? If the previous page had a next page, offload them onto this place.
        if (state.hasNextPage) {
          result.addAll(state.posts);
        }

        //? This is fine.
        state = state.copyWith(
          posts: result,
          totalSize: data['totalDocs'],
          totalPages: int.tryParse(data['totalPages'].toString()) ?? 1,
          hasNextPage: data['hasNextPage'],
          page: int.tryParse(data['page'].toString()) ?? 1,
          nextPage: int.tryParse(data['nextPage'].toString()) ?? 1,
          hasLoaded: true,
        );
      }

    //   //? After getting these posts...
    // } catch (e) {
    //   // TODO: Actual error handling.
    // }

    // That's fine.
    return result;
  }

  /// Helper function used to reset the state of our entire post notifier.
  void reset() {
    state = PostState.initial;
  }
}

final userPostsProvider = StateNotifierProvider<PostNotifier, PostState>((ref) {
  return PostNotifier(PostState.initial);
});

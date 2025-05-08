import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/shared/cache/post.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';
import 'package:wayagram/shared/features/profile/repo/default.dart';
import 'package:wayagram/shared/features/profile/state/default.dart';

class PostNotifier extends StateNotifier<PostState> {
  final repo = UserProfileRepository.instance;
  PostNotifier(super.state);

  /// An API used to fetch all the posts for a given user.
  Future<List<PostModel>> getPostsForUser(String id) async {
    final result = <PostModel>[];

    try {
      // This is fine too.
      final response = await repo.getPostsForUser(id, state.nextPage ?? state.page, state.limit);

      // If this was fine...
      if (response.success) {
        final data = response.data["data"];

        //? If the previous page had a next page, offload them onto this place.
        if (state.hasNextPage) {
          result.addAll(state.posts);
        }

        //? Parse the posts as they are in the response object...
        final docs = (data['docs'] as List).map((doc) => PostModel.fromJson(doc));

        //? Now, add these ones.
        wayaPostCache.cacheAll(docs);

        //? Now, add these to what we have here which are not from groups or pages.
        //? This is a bit of a hacK, but it works.
        result.addAll(docs.where((post) => post.pageId == null && post.groupId == null));

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

      //? After getting these posts...
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.posts,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    // That's fine.
    return result;
  }

  /// An API used to fetch the list of all saved posts for a given user.
  Future<List<PostModel>> getSavedPostsForUser(String id) async {
    final result = <PostModel>[];

    try {
      // This is fine too.
      final response = await repo.getBookmarksForUser(id, state.nextPage ?? state.page, state.limit);

      // If this was fine...
      if (response.success) {
        final data = response.data["data"];

        //? If the previous page had a next page, offload them
        //? onto this place.
        if (state.hasNextPage) {
          result.addAll(state.posts);
        }

        //? Parse the posts as they are in the response object...
        final docs = (data['docs'] as List).map((doc) => PostModel.fromJson(doc));

        //? Now, add these ones.
        wayaPostCache.cacheAll(docs);

        //? Now, add these to what we have here which are not from groups or pages.
        //? This is a bit of a hacK, but it works.
        result.addAll(docs.where((post) => post.pageId == null && post.groupId == null));

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
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.posts,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    // That's fine.
    return result;
  }

  /// Helper function used to reset the state of our entire post notifier.
  void reset() {
    state = PostState.initial;
  }
}

class SavedPostNotifier extends StateNotifier<SavedPostState> {
  final repo = UserProfileRepository.instance;
  SavedPostNotifier(super.state);

  /// An API used to fetch the list of all saved posts for a given user.
  Future<List<PostModel>> getSavedPostsForUser(String id) async {
    final result = <PostModel>[];

    try {
      // This is fine too.
      final response = await repo.getBookmarksForUser(id, state.nextPage ?? state.page, state.limit);

      // If this was fine...
      if (response.success) {
        final data = response.data["data"];

        //? If the previous page had a next page, offload them
        //? onto this place.
        if (state.hasNextPage) {
          result.addAll(state.posts);
        }

        //? Parse the posts as they are in the response object...
        final docs = (data['docs'] as List).map((doc) => PostModel.fromJson(doc));

        //? Now, add these ones.
        wayaPostCache.cacheAll(docs);

        //? Now, add these to what we have here which are not from groups or pages.
        //? This is a bit of a hacK, but it works.
        result.addAll(docs.where((post) => post.pageId == null && post.groupId == null));

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
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.posts,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    // That's fine.
    return result;
  }

  /// Helper function used to reset the state of our entire post notifier.
  void reset() {
    state = SavedPostState.initial;
  }
}

final userPostsProvider = StateNotifierProvider<PostNotifier, PostState>(
  (ref) => PostNotifier(PostState.initial),
);

final userSavedPostsProvider = StateNotifierProvider<SavedPostNotifier, SavedPostState>(
  (ref) => SavedPostNotifier(SavedPostState.initial),
);

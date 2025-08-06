import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/explore/data/repo/explore_repository.dart';
import 'package:wayagram/features/pages/data/repo/page_repository.dart';
import 'package:wayagram/shared/cache/post.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';
import 'package:wayagram/shared/features/profile/repo/default.dart';
import 'package:wayagram/shared/features/profile/state/default.dart';

class PostNotifier extends StateNotifier<PostState> {
  final repo = UserProfileRepository.instance;
  final pageRepo = PageRepository.instance;

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
          result.addAll(state.docs);
        }

        //? Parse the posts as they are in the response object...
        final docs = await Future.wait((data['docs'] as List).map((doc) async {
          if (doc["originalPostId"] != null && doc['originalPost'] == null) {
            final originalPost = await getSinglePosts(postId: doc["originalPostId"]);
            doc['originalPost'] = originalPost;
          }
          return PostModel.fromJson(doc);
        }));

        //? Now, add these ones.
        wayaPostCache.cacheAll(docs);

        //? Now, add these to what we have here which are not from groups or pages.
        //? This is a bit of a hacK, but it works.
        result.addAll(docs);

        //? This is fine.
        state = state.copyWith(
          docs: result,
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

  /// Helper function used to reset the state of our entire post notifier.
  void reset() {
    state = PostState.initial;
  }

  Future<dynamic> getSinglePosts({required String postId}) async {
    final response = await pageRepo.fetchAPost(postId);
    if (response.success) {
      final data = response.data['data'];
      dynamic result = data;
      result['originalPost'] = null;
      return result;
    } else {
      return null;
    }
  }
}

class CommentedPostNotifier extends StateNotifier<PostState> {
  final exploreRepo = ExploreRepository.instance;

  CommentedPostNotifier(super.state);

  /// An API used to fetch all the posts for a given user.
  Future<List<PostModel>> getCommentedPost(String id) async {
    final result = <PostModel>[];

    try {
      // This is fine too.
      final response = await exploreRepo.fetchCommentedPost(id, state.nextPage ?? state.page, state.limit);

      // If this was fine...
      if (response.success) {
        final data = response.data["data"];

        //? If the previous page had a next page, offload them onto this place.
        if (state.hasNextPage) {
          result.addAll(state.docs);
        }

        //? Parse the posts as they are in the response object...
        final docs = (data['docs'] as List).map((doc) {
          return PostModel.fromJson(doc);
        });

        //? Now, add these ones.
        wayaPostCache.cacheAll(docs);

        //? Now, add these to what we have here which are not from groups or pages.
        //? This is a bit of a hacK, but it works.
        result.addAll(docs);

        //? This is fine.
        state = state.copyWith(
          docs: result,
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

  /// Helper function used to reset the state of our entire post notifier.
  void reset() {
    state = PostState.initial;
  }
}

class LikedPostNotifier extends StateNotifier<PostState> {
  final exploreRepo = ExploreRepository.instance;

  LikedPostNotifier(super.state);

  /// An API used to fetch all the posts for a given user.
  Future<List<PostModel>> getLikedPost(String id) async {
    final result = <PostModel>[];

    try {
      // This is fine too.
      final response = await exploreRepo.fetchLikedPosts(id, state.nextPage ?? state.page, state.limit);

      // If this was fine...
      if (response.success) {
        final data = response.data["data"];

        //? If the previous page had a next page, offload them onto this place.
        if (state.hasNextPage) {
          result.addAll(state.docs);
        }

        //? Parse the posts as they are in the response object...
        final docs = (data['docs'] as List).map((doc) {
          return PostModel.fromJson(doc);
        });

        //? Now, add these ones.
        wayaPostCache.cacheAll(docs);

        //? Now, add these to what we have here which are not from groups or pages.
        //? This is a bit of a hacK, but it works.
        result.addAll(docs);

        //? This is fine.
        state = state.copyWith(
          docs: result,
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

  /// Helper function used to reset the state of our entire post notifier.
  void reset() {
    state = PostState.initial;
  }
}

class RepostedPostNotifier extends StateNotifier<PostState> {
  final exploreRepo = ExploreRepository.instance;
  final pageRepo = PageRepository.instance;

  RepostedPostNotifier(super.state);

  /// An API used to fetch all the posts for a given user.
  Future<List<PostModel>> getRepostedPosts(String id) async {
    final result = <PostModel>[];

    try {
      // This is fine too.
      final response = await exploreRepo.fetchReposts(id, state.nextPage ?? state.page, state.limit);

      // If this was fine...
      if (response.success) {
        final data = response.data["data"];

        //? If the previous page had a next page, offload them onto this place.
        if (state.hasNextPage) {
          result.addAll(state.docs);
        }

        //? Parse the posts as they are in the response object...
        final docs = await Future.wait((data['docs'] as List).map((doc) async {
          if (doc["originalPostId"] != null) {
            final originalPost = await getSinglePosts(postId: doc["originalPostId"]);

            doc['originalPost'] = originalPost;
          }
          return PostModel.fromJson(doc);
        }));

        //? Now, add these ones.
        wayaPostCache.cacheAll(docs);

        //? Now, add these to what we have here which are not from groups or pages.
        //? This is a bit of a hacK, but it works.
        result.addAll(docs);

        //? This is fine.
        state = state.copyWith(
          docs: result,
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

  /// Helper function used to reset the state of our entire post notifier.
  void reset() {
    state = PostState.initial;
  }

  Future<dynamic> getSinglePosts({required String postId}) async {
    final response = await pageRepo.fetchAPost(postId);
    if (response.success) {
      final data = response.data['data'];
      dynamic result = data;
      result['originalPost'] = null;
      return result;
    } else {
      return null;
    }
  }
}

class SavedPostNotifier extends StateNotifier<SavedPostState> {
  final repo = UserProfileRepository.instance;

  final pageRepo = PageRepository.instance;
  SavedPostNotifier(super.state);

  /// An API used to fetch the list of all saved posts for a given user.
  Future<List<PostModel>> getSavedPostsForUser(String id) async {
    final result = <PostModel>[];
    // final bookmarks = <BookmarkModel>[];

    try {
      state = state.copyWith(isLoading: true);

      // This is fine too.
      final response = await repo.getBookmarksForUser(id, state.nextPage ?? state.page, state.limit);

      // If this was fine...
      if (response.success) {
        final data = response.data["data"];

        //? If the previous page had a next page, offload them
        //? onto this place.
        if (state.hasNextPage) {
          result.addAll(state.docs);
        }

        //? Parse the bookmarks as they are in the response object, and retrieve only their posts...
        final docs = await Future.wait((data['docs'] as List).map((doc) async {
          if (doc["originalPostId"] != null) {
            final originalPost = await getSinglePosts(postId: doc["originalPostId"]);

            doc['originalPost'] = originalPost;
          }
          return PostModel.fromJson(doc);
        }));

        // final posts = <PostModel>[];

        // for (final doc in docs) {
        //   var post = doc.post!;
        //   if (post.user == null) {
        //     final data = await UserResource.getUserDetails(post.userId);
        //     post = post.copyWith(user: data?.$1);
        //   }
        //   posts.add(post);
        // }

        //? Now, cache these posts.
        wayaPostCache.cacheAll(docs);

        //? Now, add these to what we have here which are not from groups or pages.
        //? This is a bit of a hacK, but it works.
        result.addAll(docs);

        //? This is fine.
        state = state.copyWith(
          docs: result,
          bookmarks: [],
          totalSize: data['totalDocs'],
          totalPages: int.tryParse(data['totalPages'].toString()) ?? 1,
          hasNextPage: data['hasNextPage'],
          page: int.tryParse(data['page'].toString()) ?? 1,
          nextPage: int.tryParse(data['nextPage'].toString()) ?? 1,
          hasLoaded: true,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
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

  /// An API used to bookmark a single post for a user.
  Future<bool> bookmarkPost(String postId) async {
    try {
      final response = await repo.bookMarkPost(postId);

      if (response.success) {
        await getSavedPostsForUser(ConversationState.self.id);
      }

      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.posts,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    return false;
  }

  /// An API used to delete a bookmarked post for a user.
  Future<bool> removeBookmark(String postId) async {
    try {
      final bookmark = state.find(postId);

      if (bookmark == null) {
        return false;
      }

      //? Remove this one.
      final response = await repo.removeBookMark(bookmark.id);

      if (response.success) {
        await getSavedPostsForUser(ConversationState.self.id);
      }

      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.posts,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    return false;
  }

  Future<dynamic> getSinglePosts({required String postId}) async {
    final response = await pageRepo.fetchAPost(postId);
    if (response.success) {
      final data = response.data['data'];
      dynamic result = data;
      result['originalPost'] = null;
      return result;
    } else {
      return null;
    }
  }

  /// Helper function used to reset the state of our entire post notifier.
  void reset() {
    state = SavedPostState.initial;
  }
}

final otherUserPostsProvider = StateNotifierProvider.family<PostNotifier, PostState, String>((ref, id) {
  return PostNotifier(PostState.initial);
});

final userPostsProvider = StateNotifierProvider<PostNotifier, PostState>(
  (ref) => PostNotifier(PostState.initial),
);

final userLikedPostsProvider = StateNotifierProvider<LikedPostNotifier, PostState>(
  (ref) => LikedPostNotifier(PostState.initial),
);

final userCommentedPostsProvider = StateNotifierProvider<CommentedPostNotifier, PostState>(
  (ref) => CommentedPostNotifier(PostState.initial),
);

final userRepostsProvider = StateNotifierProvider<RepostedPostNotifier, PostState>(
  (ref) => RepostedPostNotifier(PostState.initial),
);

final userSavedPostsProvider = StateNotifierProvider<SavedPostNotifier, SavedPostState>(
  (ref) => SavedPostNotifier(SavedPostState.initial),
);

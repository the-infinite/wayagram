import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/features/pages/data/repo/page_repository.dart';
import 'package:wayagram/features/post/controller/comment.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';
import 'package:wayagram/features/post/state/comment.dart';
import 'package:wayagram/shared/cache/comment.dart';
import 'package:wayagram/shared/features/pages/notifier/default.dart';

import '../../../core/utils/utils.dart';

class CommentNotifier extends StateNotifier<CommentState> {
  final PageRepository _pageRepository;

  // final _logger = getLogger('CommentVm');
  CommentNotifier(super.state, this._pageRepository);

  /// Updates the comment in the cache with the provided [comment] model.
  ///
  /// This method modifies the existing comment data in the local cache to reflect
  /// the new state provided by the [CommentModel] parameter.
  void updateCachedComment(CommentModel comment) {
    wayaCommentCache.cache(comment.id, comment);
  }

  /// Removes a cached comment from memory using its unique identifier
  ///
  /// @param id The unique identifier of the comment to be removed
  void removeCachedComment(String id) {
    wayaCommentCache.deleteItem(id);
  }

  /// Retrieve the comment in the cache with the provided.
  CommentModel? retrieveCachedComment(String commentId) {
    return wayaCommentCache.getCachedData(commentId);
  }

  Future<bool> editComment(String postId, String commentId, String content) async {
    try {
      final response = await _pageRepository.editComment(commentId, content);

      //? If this is fine.
      if (response.success) {
        final comment = CommentModel.fromJson(response.data["data"]);
        updateCachedComment(comment);
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

  Future<CommentModel?> createComment(String postId, String content, [String? parentId]) async {
    try {
      final response = await _pageRepository.commentOnPost(postId, content, parentId);

      if (response.success) {
        final comment = CommentModel.fromJson(response.data["data"]);
        resetComments();
        await getCommentsStream(postId);
        if (parentId != null && parentId == state.replies.firstOrNull?.parentCommentId) {
          await getSingleComment(postId, parentId);
          await getReplies(postId, parentId);
        }
        await myPageNotifier.refreshPost(postId);
        return comment;
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    return null;
  }

  Future<CommentModel?> getSingleComment(String postId, String commentId) async {
    try {
      final response = await _pageRepository.getSingleComment(postId, commentId);

      //? This is fine.
      if (response.success) {
        FetchComment responseModel = FetchComment.fromJson(response.data);
        final data = responseModel.data?.comments ?? [];
        final comment = data.firstOrNull;

        //? Since it is found...
        if (comment != null) {
          updateCachedComment(comment);
        }

        //? This is fine.
        return comment;
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.posts,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Return null by default.
    return null;
  }

  Future<List<CommentModel>> getCommentsStream(String postId) async {
    final result = <CommentModel>[];

    try {
      final response = await _pageRepository.getComments(postId, null, state.page, state.limit);

      //? This
      if (response.success) {
        FetchComment responseModel = FetchComment.fromJson(response.data);

        //? As we move on.
        if (state.page > 1) {
          result.addAll(state.comments);
        }

        //? Then add the newer parts.
        result.addAll(responseModel.data?.comments ?? []);
        wayaCommentCache.cacheAll(responseModel.data?.comments ?? []);

        //? As we move on...
        state = state.copyWith(
          comments: result,
          totalPages: responseModel.data?.totalPages?.toInt(),
          totalCount: responseModel.data?.total?.toInt(),
          page: responseModel.data?.nextPage?.toInt(),
          hasNextPage: responseModel.data?.hasNextPage,
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

    // Return this one.
    return result;
  }

  Future<List<CommentModel>> getReplies(String postId, [String? parentId]) async {
    final result = <CommentModel>[];

    try {
      final response = await _pageRepository.getComments(
        postId,
        parentId,
        state.replyPage,
        state.limit,
      );

      //? This
      if (response.success) {
        FetchComment responseModel = FetchComment.fromJson(response.data);

        //? As we move on.
        if (state.page > 1) {
          result.addAll(state.replies);
        }

        //? Then add the newer parts.
        result.addAll(responseModel.data?.comments ?? []);
        wayaCommentCache.cacheAll(responseModel.data?.comments ?? []);

        //? As we move on...
        state = state.copyWith(
          replies: result,
          replyTotalPages: responseModel.data?.totalPages?.toInt(),
          replyTotalCount: responseModel.data?.total?.toInt(),
          replyPage: responseModel.data?.nextPage?.toInt(),
          replyHasNextPage: responseModel.data?.hasNextPage,
          replyHasLoaded: true,
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

    // Return this one.
    return result;
  }

  Future<bool> likeComment(String postId, String commentId) async {
    try {
      final response = await _pageRepository.likeComment(commentId);

      if (response.success) {
        await getSingleComment(postId, commentId);
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

  Future<bool> unlikeComment(String postId, String commentId) async {
    try {
      final response = await _pageRepository.unlikeComment(commentId);

      if (response.success) {
        await getSingleComment(postId, commentId);
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

  Future<bool> deleteComment(String commentId) async {
    try {
      final postId = CommentInputController.instance.postId;
      final response = await _pageRepository.deleteComment(commentId);

      if (response.success) {
        //? Since it is found...
        removeCachedComment(commentId);

        if (postId != null) {
          await myPageNotifier.refreshPost(postId);
        }
      }

      // Now, return.
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

  void update() {
    state = state.copyWith(typing: !state.typing);
  }

  void reset() {
    state = CommentState.initial;
  }

  void resetComments() {
    state = state.copyWith(
      hasNextPage: true,
      totalCount: 0,
      page: 1,
      totalPages: 0,
      hasLoaded: false,
    );
  }

  void resetReplies() {
    state = state.copyWith(
      replyPage: 1,
      replyHasNextPage: true,
      replyTotalCount: 0,
      replyTotalPages: 0,
      replyHasLoaded: false,
    );
  }
}

final commentProvider = Provider((ref) => PageRepository());
final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

final createCommentProvider = StateNotifierProvider.family<CommentNotifier, CommentState, String>((ref, id) {
  return CommentNotifier(CommentState.initial, PageRepository());
});

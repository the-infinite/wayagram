import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/features/pages/data/repo/page_repository.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';
import 'package:wayagram/features/post/state/comment.dart';

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
    final inComment = state.comments.indexWhere((value) => value.id == comment.id);
    final inReplies = state.replies.indexWhere((value) => value.id == comment.id);

    //? If we found it in replies.
    if (inReplies != -1) {
      final old = state.replies[inReplies];
      final replacement = state.replies;

      //? This is fine.
      replacement[inReplies] = comment.copyWith(user: old.user);
      state = state.copyWith(
        replies: [...replacement],
      );
      updateCacheNotifier.value = updateCacheNotifier.value + 1;
      debugPrint("Comments Logs: Cache updated for reply comment ${comment.id}");
    }

    //? If we found it in comments.
    if (inComment != -1) {
      final old = state.comments[inComment];
      final replacement = state.comments;

      //? This is fine.
      replacement[inComment] = comment.copyWith(user: old.user);
      state = state.copyWith(
        comments: [...replacement],
      );
      updateCacheNotifier.value = updateCacheNotifier.value + 1;
      debugPrint("Comments Logs: Cache updated for comment ${comment.id}");
    }
  }

  void removeCachedComment(String id) {
    final inComment = state.comments.indexWhere((value) => value.id == id);
    final inReplies = state.replies.indexWhere((value) => value.id == id);

    //? If we found it in replies.
    if (inReplies != -1) {
      final replacement = state.replies;

      //? This is fine.
      replacement.removeAt(inReplies);
      state = state.copyWith(replies: [...replacement]);
      updateCacheNotifier.value = updateCacheNotifier.value + 1;
      debugPrint("Comments Logs: Cache deleted for reply comment $id");
    }

    //? If we found it in comments.
    if (inComment != -1) {
      final replacement = state.comments;

      //? This is fine.
      replacement.removeAt(inComment);
      state = state.copyWith(comments: [...replacement]);
      updateCacheNotifier.value = updateCacheNotifier.value + 1;
      debugPrint("Comments Logs: Cache updated for comment $id");
    }
  }

  /// Retrieve the comment in the cache with the provided.
  CommentModel? retrieveCachedComment(String commentId) {
    final inComment = state.comments.indexWhere((value) => value.id == commentId);
    final inReplies = state.replies.indexWhere((value) => value.id == commentId);

    //? If we found it in comments.
    if (inComment != -1) {
      return state.comments.elementAtOrNull(inComment);
    }

    //? If we found it in replies.
    if (inReplies != -1) {
      return state.replies.elementAtOrNull(inReplies);
    }

    //? Return null.
    return null;
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
        updateCachedComment(comment);
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
        debugPrint("Comments Logs: liked $commentId");
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
        debugPrint("Comments Logs: unliked $commentId");
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
      final response = await _pageRepository.deleteComment(commentId);

      if (response.success) {
        //? Since it is found...
        removeCachedComment(commentId);
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

final createCommentProvider = StateNotifierProvider<CommentNotifier, CommentState>((ref) {
  return CommentNotifier(CommentState.initial, PageRepository());
});

final updateCacheNotifier = ValueNotifier(0);

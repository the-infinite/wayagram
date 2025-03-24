import 'package:flutter/material.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';

class CommentState {
  final bool isLoading;
  final bool hasLoaded;
  final ScrollController controller;
  final List<CommentModel> comments;
  final List<CommentModel> replies;
  final int limit;
  final int page;
  final bool hasNextPage;
  final bool typing;
  final int totalCount;
  final int totalPages;
  final int replyPage;
  final bool replyHasNextPage;
  final bool replyHasLoaded;
  final int replyTotalCount;
  final int replyTotalPages;

  CommentState({
    required this.isLoading,
    required this.hasLoaded,
    required this.comments,
    required this.replies,
    required this.limit,
    required this.controller,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
    required this.page,
    required this.typing,
    required this.replyPage,
    required this.replyHasNextPage,
    required this.replyTotalCount,
    required this.replyTotalPages,
    required this.replyHasLoaded,
  });

  static final initial = CommentState(
    isLoading: false,
    hasLoaded: false,
    comments: [],
    limit: 200,
    controller: ScrollController(),
    totalCount: 0,
    replies: [],
    totalPages: 0,
    hasNextPage: true,
    page: 1,
    typing: false,
    replyPage: 1,
    replyHasNextPage: true,
    replyTotalCount: 0,
    replyTotalPages: 0,
    replyHasLoaded: false,
  );

  CommentState copyWith({
    bool? isLoading,
    bool? hasLoaded,
    List<CommentModel>? comments,
    List<CommentModel>? replies,
    int? page,
    bool? hasNextPage,
    int? totalCount,
    int? totalPages,
    ScrollController? controller,
    bool? typing,
    int? replyPage,
    bool? replyHasNextPage,
    bool? replyHasLoaded,
    int? replyTotalCount,
    int? replyTotalPages,
  }) {
    return CommentState(
      isLoading: isLoading ?? this.isLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      comments: comments ?? this.comments,
      limit: limit,
      replies: replies ?? this.replies,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      page: page ?? this.page,
      typing: typing ?? this.typing,
      controller: controller ?? this.controller,
      replyPage: replyPage ?? this.replyPage,
      replyHasNextPage: replyHasNextPage ?? this.replyHasNextPage,
      replyTotalCount: replyTotalCount ?? this.replyTotalCount,
      replyTotalPages: replyTotalPages ?? this.replyTotalPages,
      replyHasLoaded: replyHasLoaded ?? this.replyHasLoaded,
    );
  }
}

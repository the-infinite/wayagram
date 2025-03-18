import 'package:flutter/material.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';

class CommentState {
  final bool isLoading;
  final bool hasLoaded;
  final ScrollController controller;
  final List<Comments> comments;
  final int limit;
  final int page;
  final bool hasNextPage;
  final int totalCount;
  final int totalPages;
  final String? postId;

  CommentState({
    required this.isLoading,
    required this.hasLoaded,
    required this.comments,
    required this.limit,
    required this.controller,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
    required this.page,
    required this.postId,
  });

  static final initial = CommentState(
    isLoading: false,
    hasLoaded: false,
    comments: [],
    limit: 100,
    controller: ScrollController(),
    totalCount: 0,
    totalPages: 0,
    hasNextPage: true,
    page: 1,
    postId: null,
  );

  CommentState copyWith({
    bool? isLoading,
    bool? hasLoaded,
    List<Comments>? comments,
    int? page,
    bool? hasNextPage,
    int? totalCount,
    int? totalPages,
    ScrollController? controller,
    bool? typing,
    String? postId,
  }) {
    return CommentState(
      isLoading: isLoading ?? this.isLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      comments: comments ?? this.comments,
      limit: limit,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      page: page ?? this.page,
      controller: controller ?? this.controller,
      postId: postId ?? this.postId,
    );
  }
}

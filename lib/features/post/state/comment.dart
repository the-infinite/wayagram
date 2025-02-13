import 'package:flutter/material.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';

class CommentState {
  final bool isLoading;
  //final FetchComment? comment;
  final ScrollController controller;
  final List<Comments> comments;
  final int limit;
  final int page;
  final bool hasNextPage;
  final int totalCount;
  final int totalPages;

  // This is fine.
  CommentState({
    required this.isLoading,
    required this.comments,
    //required this.messages,
    required this.limit,
    required this.controller,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
    required this.page,
  });

  // This is fine.
  static final initial = CommentState(
    isLoading: false,
    //comment: null,
    comments: [],
    limit: 100,
    controller: ScrollController(),
    totalCount: 0,
    totalPages: 0,
    hasNextPage: true,
    page: 1,
  );

  /// A helper function used to copy the contents of this chat's internal state
  /// and then pass it around.
  CommentState copyWith({
    bool? isLoading,
    List<Comments>? comments,
    int? page,
    bool? hasNextPage,
    int? totalCount,
    int? totalPages,
    ScrollController? controller,
    bool? typing,
  }) {
    return CommentState(
      isLoading: isLoading ?? this.isLoading,
      comments: comments ?? this.comments,
      //messages: messages ?? this.messages,
      limit: limit,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      page: page ?? this.page,
      controller: controller ?? this.controller,
    );
  }
}

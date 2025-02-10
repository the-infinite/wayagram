import 'package:flutter/material.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/message.dart';

class ChatState {
  final bool isLoading;
  final ChatModel? chat;
  final ScrollController controller;
  final List<MessageModel> messages;
  final int limit;
  final int page;
  final bool hasNextPage;
  final int totalCount;
  final int totalPages;
  final bool typing;

  // This is fine.
  const ChatState({
    required this.isLoading,
    required this.chat,
    required this.messages,
    required this.limit,
    required this.controller,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
    required this.page,
    required this.typing,
  });

  // This is fine.
  static final initial = ChatState(
    isLoading: false,
    chat: null,
    messages: [],
    limit: 100,
    controller: ScrollController(),
    totalCount: 0,
    totalPages: 0,
    hasNextPage: true,
    page: 1,
    typing: false,
  );

  /// A helper function used to copy the contents of this chat's internal state
  /// and then pass it around.
  ChatState copyWith({
    bool? isLoading,
    ChatModel? chat,
    List<MessageModel>? messages,
    int? page,
    bool? hasNextPage,
    int? totalCount,
    int? totalPages,
    ScrollController? controller,
    bool? typing,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      chat: chat ?? this.chat,
      messages: messages ?? this.messages,
      limit: limit,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      page: page ?? this.page,
      controller: controller ?? this.controller,
      typing: typing ?? this.typing,
    );
  }
}

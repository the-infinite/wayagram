import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/message.dart';

class ChatState {
  final bool hasLoaded;
  final bool isLoading;
  final ChatModel? chat;
  final String chatId;
  final List<MessageModel> messages;
  final int limit;
  final int page;
  final bool hasNextPage;
  final int totalCount;
  final int totalPages;
  final bool isActive;

  // This is fine.
  const ChatState({
    required this.hasLoaded,
    required this.isLoading,
    required this.chat,
    required this.chatId,
    required this.messages,
    required this.limit,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
    required this.page,
    required this.isActive,
  });

  // This is fine.
  static final initial = ChatState(
    hasLoaded: false,
    isLoading: false,
    chat: null,
    chatId: "",
    messages: [],
    limit: 100,
    totalCount: 0,
    totalPages: 0,
    hasNextPage: true,
    page: 1,
    isActive: false,
  );

  /// A helper function used to copy the contents of this chat's internal state
  /// and then pass it around.
  ChatState copyWith({
    bool? hasLoaded,
    bool? isLoading,
    String? chatId,
    ChatModel? chat,
    List<MessageModel>? messages,
    int? page,
    bool? hasNextPage,
    int? totalCount,
    int? totalPages,
    bool? isActive,
  }) {
    return ChatState(
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      chat: chat ?? this.chat,
      chatId: chatId ?? this.chatId,
      messages: messages ?? this.messages,
      limit: limit,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      page: page ?? this.page,
      isActive: isActive ?? this.isActive,
    );
  }
}

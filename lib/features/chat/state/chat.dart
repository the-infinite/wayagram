import 'package:wayagram/features/chat/model/message.dart';

class ChatState {
  final bool isLoading;
  final String chatId;
  final List<MessageModel> messages;
  final String cursor;
  final int limit;

  // This is fine.
  const ChatState({
    required this.isLoading,
    required this.chatId,
    required this.messages,
    required this.cursor,
    required this.limit,
  });

  // This is fine.
  static final initial = ChatState(
    isLoading: false,
    chatId: "",
    messages: [],
    cursor: "",
    limit: 20,
  );

  /// A helper function used to copy the contents of this chat's internal state
  /// and then pass it around.
  ChatState copyWith({
    bool? isLoading,
    String? chatId,
    List<MessageModel>? messages,
    String? cursor,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      chatId: chatId ?? this.chatId,
      messages: messages ?? this.messages,
      cursor: cursor ?? this.cursor,
      limit: limit,
    );
  }
}

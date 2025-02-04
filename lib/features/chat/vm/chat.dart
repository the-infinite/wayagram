import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/dto/chat.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/chat.dart';
import 'package:wayagram/features/chat/state/default.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier(super.state);

  Future<List<MessageModel>> getMessages([bool restart = false]) async {
    final result = <MessageModel>[];

    //? If we are not starting from the top, add what needs to be added.
    if (!restart) result.addAll(state.messages);

    // TODO: Do not forget to reverse this contents of the array of chats that
    // todo| would be retrieved over network.

    // Now, use the values you have retrieved to update state.
    state = state.copyWith(
      messages: result,
      cursor: result.lastOrNull?.id,
    );

    // Next, we set the rest.
    return result;
  }

  Future<bool> sendMessage(SendMessageDto message) async {
    final messageId = WayaValueHelper.createUid();
    final messages = [
      ...state.messages,
      MessageModel(
        id: messageId,
        chatId: state.chatId,
        content: message.body,
        media: message.files,
        originalMessage: message.replyTo,
        contacts: message.contacts,
        senderId: ConversationState.self.id!,
        messageType: message.type,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        mediaUrl: null,
        edited: false,
        originalMessageId: message.replyToId,
        forwardedFrom: null,
        isReply: message.replyToId != null,
        status: [
          MessageStatus(
            id: "stat_${WayaValueHelper.createUid()}",
            messageId: messageId,
            userId: ConversationState.self.id!,
            status: MessageStatusCode.sent,
            createdAt: DateTime.now(),
          ),
        ],
        messageReaction: [],
      ),
    ];

    //? Tell the listeners that this has been updated.
    state = state.copyWith(
      messages: messages,
    );

    //? Since we are in test mode, it would always succeed.
    return true;
  }

  //? When you change the chat...
  void setChat(ChatModel chat) {
    state = state.copyWith(
      chatId: chat.id,
      messages: [...chat.unread],
    );
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ChatState.initial);
});

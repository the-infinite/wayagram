import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/dto/chat.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/repo/message.dart';
import 'package:wayagram/features/chat/state/chat.dart';
import 'package:wayagram/features/chat/state/default.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  final repo = MessageRepository();
  ChatNotifier(super.state);

  /// Helper function used to get the list of messages from the back-end so they
  /// can be stored locally on this device.
  Future<List<MessageModel>> getMessages([bool reset = false]) async {
    final result = <MessageModel>[];

    //? Now, we are loading bro.
    state = state.copyWith(isLoading: true);

    //? This is fine.
    final response = await repo.getMessages(state.chat!.id, state.limit, state.page);

    //? This is fine.
    if (response.success) {
      //? If the previous page had a next page, offload them onto this place.
      if (!reset && state.hasNextPage) {
        result.addAll(state.messages);
      }

      //? Parse the conversations as they are in the response object...
      final docs = (response.data['docs'] as List<Map<String, dynamic>>).map((doc) => MessageModel.fromJson(doc));

      //? This is fine.
      result.addAll(docs);

      //? Update state.
      state = state.copyWith(
        messages: result,
        totalCount: response.data['totalDocs'],
        totalPages: response.data['totalPages'],
        hasNextPage: response.data['hasNextPage'],
        page: int.tryParse(response.data['nextPage'].toString()) ?? 1,
        isLoading: false,
      );
    }

    //? Since it failed.
    else {
      state = state.copyWith(isLoading: false);
    }

    //? Scroll to the last possible message.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.controller.animateTo(state.controller.position.maxScrollExtent,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    });

    //? Return this collated result.
    return result;
  }

  /// A helper function used to send a message to a given chat. The multipart
  /// file specification
  Future<MessageModel?> sendMessage(SendMessageDto message) async {
    final messageId = WayaValueHelper.createUid();

    //? While waiting for this message to be sent...
    final placeholder = MessageModel(
      id: messageId,
      chatId: state.chat!.id,
      content: message.content,
      media: message.media,
      originalMessage: message.originalMessage,
      contacts: message.contacts,
      senderId: ConversationState.self.id!,
      messageType: message.type,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      mediaUrl: message.media?.firstOrNull,
      edited: false,
      originalMessageId: message.originalMessageId,
      forwardedFrom: null,
      isReply: message.originalMessageId != null,
      status: [],
      messageReaction: [],
    );

    //? Tell the listeners that this has been updated to first add the message to
    //? our list of messages.
    state = state.copyWith(
      messages: [...state.messages, placeholder],
      isLoading: true,
    );

    //? This is fine.
    final response = await repo.sendMessage(message);

    //? If this went well...
    if (response.success) {
      final result = MessageModel.fromJson(response.data);
      final conversation = state.messages;
      final found = conversation.lastIndexWhere((message) => message.id == messageId);

      //? Now, replace this.
      if (found != -1) {
        conversation[found] = result;
      }

      //? Now update the UI with our changes...
      state = state.copyWith(
        messages: conversation,
        isLoading: false,
      );

      //? Scroll to the last possible message.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        state.controller.animateTo(state.controller.position.maxScrollExtent,
            duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
      });
    }

    //? This is not loading.
    else {
      state = state.copyWith(isLoading: false);
    }

    //? Since we are in test mode, it would always succeed.
    return null;
  }

  /// A helper function that is used to aggregate the total number of messages
  /// that this user is yet to read.
  Future<int?> getUnreadMessageCount() async {
    final response = await repo.getUnreadMessagesCount();

    //? Then return it directly.
    return response.success ? response.data : null;
  }

  /// A helper function that is used to mark all messages in the chat as read by
  /// the user.
  Future<bool> markAllAsRead() async {
    final response = await repo.readAllInChat(state.chat!.id);

    //? We need to fetch the messages again.

    //? This is fine.
    return response.success;
  }

  /// An API used to update the status of a message in the API.
  Future<bool> updateMessageStatus(MessageStatusCode status, String id) async {
    final response = await repo.updateMessageStatus(status, id);

    return response.success;
  }

  /// An API used to edit a message.
  Future<bool> editMessage(String id, String content) async {
    final response = await repo.editMessage(id, content);

    return response.success;
  }

  /// A helper API used to delete a message.
  Future<bool> deleteMessage(String id, MessageDeleteAction action) async {
    final response = await repo.deleteMessage([id], action);

    //? Return whether this is fine or not.
    return response.success;
  }

  /// A helper API used to forward a message to a given list of chats.
  Future<bool> forwardMessage(String id, List<String> recipients) async {
    final response = await repo.forwardAMessage(recipients, id);

    //? This is good.
    return response.success;
  }

  /// A helper API used to forward a message to a given list of chats.
  Future<bool> reactToMessage(String id,String reaction) async {
    final response = await repo.reactToMessage(id, reaction);

    //? This is good.
    return response.success;
  }

  /// A helper function used to update the currently viewable chat on screen. It
  /// would clear out all visible messages and only retrieve messages sent by
  /// a given user.
  void setChat(ChatModel chat) {
    //? When this is disposed.
    state.controller.dispose();

    //? This is fine.
    state = state.copyWith(
      chat: chat,
      messages: [],
      controller: ScrollController(),
    );
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ChatState.initial);
});

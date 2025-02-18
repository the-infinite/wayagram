import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/controller/socket.dart';
import 'package:wayagram/features/chat/dto/chat.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/repo/message.dart';
import 'package:wayagram/features/chat/state/chat.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  final repo = MessageRepository();
  ChatNotifier(super.state);

  /// Helper function used to get the list of messages from the back-end so they
  /// can be stored locally on this device.
  Future<List<MessageModel>> getMessages([bool reset = false]) async {
    final result = <MessageModel>[];

    //? This is fine.
    final response = await repo.getMessages(state.chat!.id, state.limit, state.page);

    //? This is fine.
    if (response.success) {
      // The data.
      final data = response.data['data'];

      //? Parse the conversations as they are in the response object...
      final docs = (data['docs'] as List).map((doc) => MessageModel.fromJson(doc));

      //? This is fine.
      result.addAll(docs.where((msg) => msg.myStatus?.status != MessageStatusCode.deleted).toList().reversed);

      //? If the previous page had a next page, offload them onto this place.
      if (!reset && state.hasNextPage) {
        result.addAll(state.messages);
      }

      //? Update state.
      state = state.copyWith(
        hasLoaded: true,
        messages: result,
        totalCount: data['totalDocs'],
        totalPages: int.tryParse(data['totalPages'].toString()) ?? 1,
        hasNextPage: data['hasNextPage'],
        page: int.tryParse(data['nextPage'].toString()) ?? 1,
      );
    }

    //? Since it failed.
    else {
      // TODO: Actual error handling.
    }

    //? Return this collated result.
    return result;
  }

  /// A helper function used to set whether or not the other user is not
  /// currently typing in at the moment.
  void setTyping(bool value) {
    state = state.copyWith(typing: value);
  }

  /// A helper function used to get the updated state of a SINGLE message.
  Future<MessageModel?> getMessage(String id, [bool replace = true]) async {
    //? This is fine.
    final response = await repo.getMessage(id);

    //? This is fine.
    if (response.success) {
      final result = MessageModel.fromJson(response.data['data']);
      final pos = state.messages.indexWhere((message) => message.id == id);

      //? If this was found...
      if (replace && pos != -1) {
        final messages = state.messages;
        final previous = messages[pos];

        //? Fix the bug where the latest message is not always guaranteed to be
        //? showing up here.
        messages[pos] = result.copyWith(false, previous.originalMessage);

        //? Then update this.
        state = state.copyWith(messages: messages);
      }

      //? If this message is not in your list of messages.
      else {
        //? First, get the messages.
        final messages = state.messages;

        //? Finally, scroll infinitely.
        state = state.copyWith(messages: [result, ...messages]);
      }

      //? Return this result.
      return result;
    }

    //? Since it failed.
    else {
      // TODO: Proper error handling.
    }

    //? Return null.
    return null;
  }

  /// A helper function used to get the current state of this one.
  ChatState getState() {
    return state;
  }

  /// A helper function used to send a message to a given chat. The multipart
  /// file specification
  Future<MessageModel?> sendMessage(SendMessageDto message, [String? originalId]) async {
    final messageId = originalId ?? WayaValueHelper.createUid();

    //? If this is not an attempt to resend...
    if (originalId == null) {
      final placeholder = message.buildMessage(messageId);

      //? Tell the listeners that this has been updated to first add the message to
      //? our list of messages.
      state = state.copyWith(messages: [...state.messages, placeholder], isLoading: true);
    }

    //? Else, we just flag this message as something that is not an error.
    else {
      final conversation = state.messages;
      final found = conversation.lastIndexWhere((message) => message.id == messageId);

      //? Now, replace this.
      if (found != -1) {
        conversation[found] = conversation[found].copyWith(false, message.originalMessage);
      }

      //? Now update the UI with our changes...
      state = state.copyWith(messages: [...conversation], isLoading: true);
    }

    //? Try to send the message.
    try {
      //? This is fine.
      final response = await repo.sendMessage(await message.uploadFiles());

      //? If this went well...
      if (response.success) {
        final result = MessageModel.fromJson(response.data['data']);
        final conversation = state.messages;
        final found = conversation.lastIndexWhere((message) => message.id == messageId);

        //? Now, replace this.
        if (found != -1) {
          conversation[found] = result.copyWith(false, message.originalMessage);
        }

        //? Now update the UI with our changes...
        state = state.copyWith(messages: [...conversation], isLoading: false);

        // Notify everyone of it.
        WayaSocketController.instance.emit(WayaChatSocketArgs.sendMessage(state.chat!.id, result.id));

        //? Return the result.
        return result;
      }

      //? Turn this into an error.
      else {
        final conversation = state.messages;
        final found = conversation.lastIndexWhere((message) => message.id == messageId);

        //? Now, replace this.
        if (found != -1) {
          conversation[found] = conversation[found].copyWith(true, message.originalMessage);
        }

        //? Now update the UI with our changes...
        state = state.copyWith(messages: [...conversation], isLoading: false);
      }
    } catch (_) {
      final conversation = state.messages;
      final found = conversation.lastIndexWhere((message) => message.id == messageId);

      //? Now, replace this.
      if (found != -1) {
        conversation[found] = conversation[found].copyWith(true, message.originalMessage);
      }

      //? Now update the UI with our changes...
      state = state.copyWith(messages: [...conversation], isLoading: false);
    }

    //? Since we are in test mode, it would always succeed.
    return null;
  }

  /// A helper function that is used to aggregate the total number of messages
  /// that this user is yet to read.
  Future<int?> getUnreadMessageCount() async {
    final response = await repo.getUnreadMessagesCount();

    //? Then return it directly.
    return response.success ? response.data['data'] : null;
  }

  /// A helper function that is used to mark all messages in the chat as read by
  /// the user.
  Future<bool> markAllAsRead() async {
    final response = await repo.readAllInChat(state.chat!.id);

    //? We need to fetch the messages again.
    if (response.success) {
      getMessages(true);

      // This is fine.
      WayaSocketController.instance.emit(WayaChatSocketArgs.markAllAsRead(state.chat!.id));
    }

    //? This is fine.
    return response.success;
  }

  /// A helper function used to remove a message from the list of messages in
  /// this conversation's state object.
  void removeMessage(String id) {
    final conversation = state.messages;
    final found = conversation.lastIndexWhere((message) => message.id == id);

    //? Now, replace this.
    if (found != -1) {
      conversation.removeAt(found);

      //? Now update the UI with our changes...
      state = state.copyWith(messages: conversation);
    }
  }

  /// An API used to update the status of a message in the API.
  Future<bool> updateMessageStatus(MessageStatusCode status, String id) async {
    final response = await repo.updateMessageStatus(status, id);

    //? If this was fine...
    if (response.success) {
      //? If this was read.
      WayaSocketController.instance.emit(WayaChatSocketArgs.sendMessage(state.chat!.id, id));

      // Now, pull all messages.
      getMessage(id);
    }

    //? If this was fine...
    return response.success;
  }

  /// An API used to edit a message.
  Future<bool> editMessage(String id, String content) async {
    final response = await repo.editMessage(id, content);

    //? If this was fine...
    if (response.success) {
      //? If this was read.
      WayaSocketController.instance.emit(WayaChatSocketArgs.sendMessage(state.chat!.id, id));

      // Now, pull all messages.
      getMessage(id);
    }

    // Then we succeeded.
    return response.success;
  }

  /// A helper API used to delete a message.
  Future<bool> deleteMessage(String id, MessageDeleteAction action) async {
    final response = await repo.deleteMessage([id], action);

    //? If this went well...
    if (response.success) {
      // Notify everyone of it.
      if (action == MessageDeleteAction.deleteForEveryone) {
        WayaSocketController.instance.emit(WayaChatSocketArgs.deleteMessage(state.chat!.id, id));
      }

      // Remove this.
      removeMessage(id);
    }

    //? Return whether this is fine or not.
    return response.success;
  }

  /// A helper API used to forward a message to a given list of chats.
  Future<bool> forwardMessage(String id, List<String> recipients) async {
    final response = await repo.forwardAMessage(recipients, id);

    //? If this succeeded...
    if (response.success) {
      // Notify everyone of it.
      WayaSocketController.instance.emit(WayaChatSocketArgs.sendMessage(state.chat!.id, id));

      // This is fine.
      getMessage(id);
    }

    //? This is good.
    return response.success;
  }

  /// A helper API used to forward a message to a given list of chats.
  Future<bool> reactToMessage(String id, String reaction) async {
    final response = await repo.reactToMessage(id, reaction);

    //? If this succeeded...
    if (response.success) {
      // Notify everyone of it.
      WayaSocketController.instance.emit(WayaChatSocketArgs.sendMessage(state.chat!.id, id));

      // This is fine.
      getMessage(id);
    }

    //? This is good.
    return response.success;
  }

  /// A nice way of resetting this to its primal origin.
  void reset() {
    state = ChatState.initial;
  }

  /// A helper function used to update the currently viewable chat on screen. It
  /// would clear out all visible messages and only retrieve messages sent by
  /// a given user.
  void setChat(ChatModel chat) {
    state = state.copyWith(
      chat: chat,
      messages: [],
    );
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ChatState.initial);
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/controller/preloader.dart';
import 'package:wayagram/features/chat/controller/message.dart';
import 'package:wayagram/features/chat/controller/socket.dart';
import 'package:wayagram/features/chat/dto/chat.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/media.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/repo/message.dart';
import 'package:wayagram/features/chat/state/chat.dart';
import 'package:wayagram/features/shop/shop_dispute/data/repo/shop_dispute_repository.dart';

final _controllers = <String, MessageController>{};
final _removed = <String, int>{};

class ChatNotifier extends StateNotifier<ChatState> {
  final repo = MessageRepository();
  final shopDisputeRepo = ShopDisputeRepository();
  final _typingList = <String, bool>{};
  final typingNotifier = ValueNotifier(0);

  ChatNotifier(super.state);

  /// A helper function used to retrieve the
  bool get isActive => state.isActive;

  /// A helper function used to retrieve the list of users that are currently#
  /// typing.
  Iterable<String> get usersTyping => _typingList.keys;

  /// Helper function used to get or create and then get a message controller for
  /// a chat using the ID of the chat.
  MessageController? getController(MessageModel message) {
    if (_removed.containsKey(message.id)) {
      return null;
    }

    final id = message.id;
    var found = _controllers[id];

    if (found == null) {
      found = MessageController(id);
      found.updateData(message);
      _controllers[id] = found;
    }

    // Do it like this.
    return found;
  }

  /// Helper function used to get the list of messages from the back-end so they
  /// can be stored locally on this device.
  Future<List<MessageModel>> getSupportMessages([bool reset = false]) async {
    final result = <MessageModel>[];

    //? For now, pause for a bit to emulate network requests.
    await Future.delayed(const Duration(milliseconds: 450));

    //? Just update state.
    state = state.copyWith(
      hasLoaded: true,
      messages: result,
    );

    //? Return this collated result.
    return result;
  }

  /// Helper function used to get the list of messages from the back-end so they
  /// can be stored locally on this device.
  Future<List<MessageModel>> getMessages([bool reset = false, bool onlyIfEmpty = false]) async {
    //? If this should only operate if this is empty.
    if (onlyIfEmpty && state.messages.isNotEmpty) {
      return state.messages;
    }

    //? We can do it like this then.
    final result = <MessageModel>[];

    //? This is fine.
    final response = await repo.getMessages(state.chatId, state.limit, state.page);

    //? This is fine.
    if (response.success) {
      // The data.
      final data = response.data['data'];

      //? Parse the conversations as they are in the response object...
      final docs = (data['docs'] as List).map((doc) => MessageModel.fromJson(doc));

      //? If the previous page had a next page, offload them onto this place.
      if (!reset && state.hasNextPage) {
        result.addAll(state.messages);
      }

      //? Add our new messages
      result.addAll(docs.where((msg) => msg.myStatus?.status != MessageStatusCode.deleted).toList().reversed);

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

    //? Return this collated result.
    return result;
  }

  /// Retrieves a list of media items associated with the chat.
  ///
  /// Returns a [Future] that completes with a list of [ChatMediaModel] objects.
  ///
  /// Throws an exception if the media retrieval fails.
  Future<List<ChatMediaModel>> getChatMedia() async {
    final result = <ChatMediaModel>[];

    //? Show the preloader
    WayaPreloaderController.instance.show();

    try {
      //? This is fine.
      final response = await repo.getMessages(state.chatId, state.limit, state.page);

      //? This is fine.
      if (response.success) {
        // The data.
        final data = response.data['data'];

        //? Parse the conversations as they are in the response object...
        final docs = (data['docs'] as List).map((doc) => ChatMediaModel.fromJson(doc));

        //? Add our new messages
        result.addAll(docs);

        //? Update state.
        state = state.copyWith(
          media: result,
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    //? Dismiss the preloader
    WayaPreloaderController.instance.hide();

    //? Return this collated result.
    return result;
  }

  /// A helper function used to add a user to the list of people that are currently
  /// typing in this chat.
  void startTyping(String userId) {
    _typingList[userId] = true;
    typingNotifier.value = typingNotifier.value + 1;
  }

  /// A helper function used to remove a user from the list of people that are
  /// currently typing in this chat.
  void stopTyping(String userId) {
    _typingList.remove(userId);
    typingNotifier.value = typingNotifier.value - 1;
  }

  /// A helper function used to get the updated state of a SINGLE message.
  Future<MessageModel?> getMessage(String id, [bool replace = true]) async {
    //? This is fine.
    final response = await repo.getMessage(id);

    //? This is fine.
    if (response.success) {
      final result = MessageModel.fromJson(response.data['data']);
      final pos = state.messages.indexWhere((message) => message.id == id);
      final controller = getController(result);

      //? If this was not found in the list of messages...
      if (pos < 0) {
        //? First, get the messages.
        final messages = state.messages;

        //? Finally, scroll infinitely.
        state = state.copyWith(messages: [...messages, result]);
      }

      //? You can go ahead to update the value of this message in its controller.
      else {
        controller?.updateData(result);
      }

      //? Return this result.
      return result;
    }

    //? Since it failed.
    else {
      WayaDebugConsoleController.instance.addException(
        response.responseCodeError ?? "An unknown error occurred",
        response,
        WayaDebugEventModule.chats,
      );
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
    final messageId = originalId ?? message.id;

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
      final found = conversation.lastIndexWhere((bubble) => bubble.id == messageId);

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
        final found = state.messages.lastIndexWhere((bubble) => bubble.id == messageId);

        //? Now, replace this.
        if (found != -1) {
          final controller = getController(state.messages[found]);
          if (controller != null) {
            controller.updateData(result.copyWith(false, message.originalMessage), result.id);
            _controllers[result.id] = controller;
            _controllers.remove(messageId);
          }
          state.messages[found] = result;

          //? Update state.
          state = state.copyWith();
        }

        // Notify everyone of it.
        WayaSocketController.instance.emit(WayaChatSocketArgs.sendMessage(state.chatId, result.id));

        //? Return the result.
        return result;
      }

      //? Turn this into an error.
      else {
        final found = state.messages.lastIndexWhere((bubble) => bubble.id == messageId);

        //? Now, replace this.
        if (found != -1) {
          final controller = getController(state.messages[found]);
          final result = state.messages[found];
          controller?.updateData(result.copyWith(true, message.originalMessage));
        }

        //? Now update the UI with our changes...
        // state = state.copyWith(messages: [...conversation], isLoading: false);
      }
    } catch (e) {
      debugPrint('$e');

      //? This is fine.
      final found = state.messages.lastIndexWhere((bubble) => bubble.id == messageId);

      //? Now, replace this.
      if (found != -1) {
        final controller = getController(state.messages[found]);
        final result = state.messages[found];
        controller?.updateData(result.copyWith(true, message.originalMessage));
      }
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
    final response = await repo.readAllInChat(state.chatId);

    //? We need to fetch the messages again.
    if (response.success) {
      getMessages(true);

      // This is fine.
      WayaSocketController.instance.emit(WayaChatSocketArgs.markAllAsRead(state.chatId));
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
      final controller = getController(state.messages[found]);
      conversation.removeAt(found);

      //? Now update the UI with our changes...
      state = state.copyWith(messages: conversation);

      //? After that, dispose of this controller.
      controller?.setRemoved(true);
      _removed[id] = 1;
      _controllers.remove(id);
    }
  }

  /// An API used to update the status of a message in the API.
  Future<bool> updateMessageStatus(MessageStatusCode status, String id) async {
    final response = await repo.updateMessageStatus(status, id);

    //? If this was fine...
    if (response.success) {
      //? If this was read.
      WayaSocketController.instance.emit(WayaChatSocketArgs.sendMessage(state.chatId, id));

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
      WayaSocketController.instance.emit(WayaChatSocketArgs.sendMessage(state.chatId, id));

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
      //? Update the conversation here.

      // Notify everyone of it.
      if (action == MessageDeleteAction.deleteForEveryone) {
        WayaSocketController.instance.emit(WayaChatSocketArgs.deleteMessage(state.chatId, id));
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
      WayaSocketController.instance.emit(WayaChatSocketArgs.sendMessage(state.chatId, id));

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
      WayaSocketController.instance.emit(WayaChatSocketArgs.sendMessage(state.chatId, id));

      // This is fine.
      getMessage(id);
    }

    //? This is good.
    return response.success;
  }

  /// A helper function used to update the currently viewable chat on screen. It
  /// would clear out all visible messages and only retrieve messages sent by a
  /// given user.
  void setChat(ChatModel chat) {
    if (state.chat != null) {
      return;
    }

    // Log.
    debugPrint("Activating ${chat.id}");

    // Clear the controllers and then update the chat we are listening to.
    state = state.copyWith(
      chat: chat,
      isActive: true,
    );
  }

  /// A helper function used to notify the state that the chat is no longer in
  /// the foreground.
  void setInactive() {
    //? If this is already inactive, then we can just return.
    if (!state.isActive) {
      return;
    }

    // Log.
    debugPrint("Deactivating ${state.chat?.id}");

    //? Clear the controllers and then update the chat we are listening to.
    state = state.copyWith(
      isActive: false,
      chat: null,
    );
  }
}

final chatProvider = StateNotifierProvider.family<ChatNotifier, ChatState, String>(
  (ref, id) => ChatNotifier(
    ChatState.initial.copyWith(chatId: id),
  ),
);

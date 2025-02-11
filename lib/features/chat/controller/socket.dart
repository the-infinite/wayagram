import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/task.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';

class WayaChatSocketArgs {
  final String chatId;
  final String command;
  final String senderId;
  final String? messageId;
  final String? content;
  final String? action;
  final bool? isSynced;
  final bool? isFlag;

  //? This is fine.
  WayaChatSocketArgs._({
    required this.command,
    required this.chatId,
    required this.senderId,
    this.action,
    this.content,
    this.messageId,
    this.isSynced,
    this.isFlag,
  });

  factory WayaChatSocketArgs.typing(String chatId, bool isTyping, [bool? isSynced, bool? isFlagged]) {
    return WayaChatSocketArgs._(
      command: "typing",
      chatId: chatId,
      senderId: ConversationState.self.id!,
      action: isTyping ? 'start-typing' : 'stop-typing',
      isSynced: isSynced,
      isFlag: isFlagged,
    );
  }

  factory WayaChatSocketArgs.sendMessage(String chatId, String messageId, [bool? isSynced, bool? isFlagged]) {
    return WayaChatSocketArgs._(
      command: "sendMessage",
      chatId: chatId,
      senderId: ConversationState.self.id!,
      messageId: messageId,
      isSynced: isSynced,
      isFlag: isFlagged,
    );
  }

  factory WayaChatSocketArgs.markAsRead(String chatId, String messageId, [bool? isSynced, bool? isFlagged]) {
    return WayaChatSocketArgs._(
      command: "markAsRead",
      chatId: chatId,
      senderId: ConversationState.self.id!,
      messageId: messageId,
      isSynced: isSynced,
      isFlag: isFlagged,
    );
  }

  factory WayaChatSocketArgs.markAllAsRead(String chatId, [bool? isSynced, bool? isFlagged]) {
    return WayaChatSocketArgs._(
      command: "markAllAsRead",
      chatId: chatId,
      senderId: ConversationState.self.id!,
      isSynced: isSynced,
      isFlag: isFlagged,
    );
  }

  factory WayaChatSocketArgs.deleteMessage(String chatId, String messageId, [bool? isSynced, bool? isFlagged]) {
    return WayaChatSocketArgs._(
      command: "deleteMessage",
      chatId: chatId,
      senderId: ConversationState.self.id!,
      messageId: messageId,
      isSynced: isSynced,
      isFlag: isFlagged,
    );
  }

  factory WayaChatSocketArgs.join(String chatId, [bool? isSynced, bool? isFlagged]) {
    return WayaChatSocketArgs._(
      command: "join",
      chatId: chatId,
      senderId: ConversationState.self.id!,
      isSynced: isSynced,
      isFlag: isFlagged,
    );
  }

  factory WayaChatSocketArgs.special(
    String command,
    String chatId, {
    String? action,
    String? messageId,
    bool? isSynced,
    bool? isFlagged,
  }) {
    return WayaChatSocketArgs._(
      command: command,
      chatId: chatId,
      senderId: ConversationState.self.id!,
      action: action,
      messageId: messageId,
      isSynced: isSynced,
      isFlag: isFlagged,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      if (messageId != null) 'messageId': messageId,
      if (content != null) 'content': content,
      if (action != null) 'action': action,
      if (isSynced != null) 'isSynced': isSynced,
      if (isFlag != null) 'isFlag': isFlag,
    };
  }

  factory WayaChatSocketArgs.fromJson(Map<String, dynamic> json) {
    return WayaChatSocketArgs._(
      command: "",
      chatId: json['chatId'],
      senderId: json['senderId'],
      messageId: json['messageId'],
      content: json['content'],
      action: json['action'],
      isSynced: json['isSynced'],
      isFlag: json['isFlag'],
    );
  }
}

class WayaSocketController {
  static final instance = WayaSocketController._();

  // Now the fields.
  final _rooms = <String>[];
  final _retryDuration = const Duration(milliseconds: 500);
  final secureDataSource = WayaSecureDataSource();
  WidgetRef? ref;
  socket_io.Socket? _socket;

  WayaChatSocketArgs _quickDecode(dynamic data) {
    return WayaChatSocketArgs.fromJson(jsonDecode(data.toString()));
  }

  // This is fine.
  WayaSocketController._();

  /// Our utility function used to connect to the chat socket for this client.
  Future<void> connect(WidgetRef ref) async {
    //? This is fine too.
    this.ref = ref;

    //? This should only be update when necessary.
    _socket = socket_io.io(
      WayaConstants.baseUrl,
      socket_io.OptionBuilder()
          .setPath("/communication-service/socket.io/")
          .setTransports(['websocket', 'polling']) // Our transport options.
          .disableAutoConnect() // disable auto-connection
          .setReconnectionDelay(_retryDuration.inMilliseconds)
          .setReconnectionDelayMax(_retryDuration.inMilliseconds)
          .setQuery({
            'token': await secureDataSource.getToken(),
          })
          .setExtraHeaders({
            'Authorization': 'Bearer ${await secureDataSource.getToken()}',
          })
          .build(),
    );

    //? When we connect to this one...
    _socket!.onConnect(
      (data) {
        debugPrint("socket-log> Connected to socket");
      },
    );

    //? When something goes wrong.
    _socket!.onError((event) {
      debugPrint("socket-error> Error: $event");
    });

    //? Connect our socket.
    _socket = _socket!.connect();
  }

  /// Our utility function to disconnect the network controller.
  Future<void> disconnect() async {
    if (_socket == null) return;
    debugPrint("socket-log> Socket disconnected");
    _socket!.disconnect();
    _socket!.dispose();
    _socket = null;
  }

  /// Our utility function that is used to start listening for socket events.
  Future<void> listen() async {
    final socket = _socket!;
    final chatNotifier = ref!.watch(chatProvider.notifier);
    final notifier = ref!.watch(conversationProvider.notifier);

    //? On any event.
    socket.onAny(
      (event, args) {
        debugPrint("socket-${args.command}> #$args");
      },
    );

    //? First, listen for the request to fetch chat lists again.
    socket.on(
      "chatListUpdate",
      (data) async {
        //? This is fine.
        debounce(key: "chat-list-update", () async {
          await notifier.getChats(true);
          await notifier.getArchivedChats(true);
        })();
      },
    );

    //? Second, listen for the request to mark a certain chat as read.
    socket.on(
      "messageRead",
      (data) async {
        final args = _quickDecode(data);
        final state = chatNotifier.getState();

        //? If this is not fine.
        if (state.chat?.id != args.chatId) return;

        //? Since we are in this chat...
        chatNotifier.getMessages(true);
      },
    );

    //? Third, listen for when the other user starts typing.
    socket.on(
      "start-typing",
      (data) async {
        final args = _quickDecode(data);
        final state = chatNotifier.getState();

        //? If this is not fine.
        if (state.chat?.id != args.chatId) return;

        // This is fine.
        chatNotifier.setTyping(true);
      },
    );

    //? Fourth, listen for when the other user stops typing.
    socket.on(
      "stop-typing",
      (data) async {
        final args = _quickDecode(data);
        final state = chatNotifier.getState();

        //? If this is not fine.
        if (state.chat?.id != args.chatId) return;

        // This is fine.
        chatNotifier.setTyping(false);
      },
    );

    //? Fifth, listen for when a message has been deleted from the conversation.
    socket.on(
      "messageDeleted",
      (data) async {
        final args = _quickDecode(data);
        final state = chatNotifier.getState();

        //? If this is not fine.
        if (state.chat?.id != args.chatId || args.messageId == null) return;

        // This is fine.
        chatNotifier.removeMessage(args.messageId!);
      },
    );

    //? Sixth, listen for when a message has been received by me.
    socket.on(
      "receiveMessage",
      (data) async {
        final args = _quickDecode(data);
        final state = chatNotifier.getState();

        //? If this is not fine.
        if (state.chat?.id != args.chatId || args.messageId == null) return;

        // This is fine.
        chatNotifier.getMessage(args.messageId!);
      },
    );

    //? Seventh, listen for when all messages should be read by me.
    socket.on(
      "readMessages",
      (data) async {
        final args = _quickDecode(data);
        final state = chatNotifier.getState();

        //? If this is not fine.
        if (state.chat?.id != args.chatId || args.messageId == null) return;

        // This is fine.
        chatNotifier.markAllAsRead();
      },
    );
  }

  /// Our utility used to emit a given notification to the chat stream.
  Future<void> emit(WayaChatSocketArgs args) async {
    if (_socket == null) return;
    _socket!.emit(args.command, args.toJson());
    debugPrint("socket-${args.command}> \$${args.toJson()}");
  }

  /// Our utility function used to emit a join instruction so we can enter all
  /// the rooms we need to enter.
  Future<void> join(String room) async {
    if (_rooms.contains(room)) return;
    emit(WayaChatSocketArgs.join(room));
    _rooms.add(room);
  }
}

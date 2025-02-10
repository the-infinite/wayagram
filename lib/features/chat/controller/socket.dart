import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';

class SocketController {
  //? This is fine.
  static final instance = SocketController._();

  // Now the fields.
  final _retryDuration = const Duration(seconds: 3, milliseconds: 500);
  final secureDataSource = WayaSecureDataSource();
  WidgetRef? ref;
  socket_io.Socket? _socket;

  Map<String, dynamic> _quickDecode(dynamic data) {
    return jsonDecode(data.toString());
  }

  // This is fine.
  SocketController._();

  /// Our utility function used to connect to the chat socket for this client.
  Future<void> connect(WidgetRef ref) async {
    //? This is fine too.
    this.ref = ref;

    //? This should only be update when necessary.
    _socket ??= socket_io.io(
      "${WayaConstants.baseUrl}communication-service/api/v2",
      socket_io.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
          .setReconnectionDelay(_retryDuration.inMilliseconds)
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
        _socket!.emit("fetchChatLists");
      },
    );

    //? Connect our socket.
    _socket = _socket!.connect();
  }

  /// Our utility function to disconnect the network controller.
  Future<void> disconnect() async {
    _socket!.disconnect();
  }

  /// Our utility function that is used to start listening for socket events.
  Future<void> listen() async {
    final socket = _socket!;
    final chatNotifier = ref!.watch(chatProvider.notifier);
    final notifier = ref!.watch(conversationProvider.notifier);
    final controller = ChatInputController.instance;

    //? First, listen for the request to fetch chat lists again.
    socket.on(
      "chatListUpdate",
      (data) async {
        await notifier.getChats(true);
        await notifier.getArchivedChats(true);
      },
    );

    //? Second, listen for the request to mark a certain chat as read.
    socket.on(
      "messageRead",
      (data) async {
        final args = _quickDecode(data);
      },
    );

    //? Third, listen for the other things
  }

  /// Our utility used to tell
}

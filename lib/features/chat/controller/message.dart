import 'package:flutter/material.dart';
import 'package:wayagram/features/chat/model/message.dart';

class MessageController extends ValueNotifier<MessageModel> {
  String _temporaryId = "";

  MessageController(super.value);

  /// Used to set the temporary ID of the chat that this message controller is
  /// actually focusing on currently.
  void setMessageId(String id) {
    _temporaryId = id;
    notifyListeners();
  }

  /// Get the ID of this one.
  String get temporaryId => _temporaryId;
}

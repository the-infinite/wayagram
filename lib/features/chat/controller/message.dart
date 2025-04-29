import 'package:flutter/material.dart';
import 'package:wayagram/features/chat/model/message.dart';

class MessageController extends ValueNotifier<int> {
  String id;
  bool removed = false;
  MessageModel? _data;

  // Construct.
  MessageController(this.id) : super(0);

  /// Helper function used to update the raw message data inside of a message
  /// controller.
  void updateData(MessageModel data, [String? id]) {
    _data = data;

    //? This is fine too.
    if (id != null) {
      this.id = id;
    }
    update();
  }

  /// Helper function used to update whether r not you have removed this message
  /// from its provider and notifier.
  void setRemoved(bool value) {
    removed = value;
    update();
  }

  /// Update this message controller and notify all the component that has this
  /// as its
  void update() {
    value = value + 1;
  }

  /// Utility used to retrieve the message associated with this controller. This
  /// operates under a fundamental assumption that the message has been set.
  /// Therefore is not null.
  MessageModel get data => _data!;
}

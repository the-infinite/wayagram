import 'dart:async';

import 'package:flutter/material.dart';

enum WayaDebugEventType {
  /// The error is a HTTP error. Which means it is happening because of an API or
  /// network request.
  http,

  /// The error is a flutter error. Which means it is happening because of some
  /// odd and unhandled exception in the WidgetTree.
  flutter,

  /// The error is a logical error which means a condition that should otherwise
  /// never be, is somehow true.
  logical,

  /// This is a runtime error that occurred directly in the Flutter framework.
  /// Meaning, it is more than likely not your fault. These should be rare.
  runtime,

  /// This is a run off the mill exception. Which means it is just one more
  /// problem that is in the app's own code which the developer did not account
  /// for.
  exception,
}

enum WayaDebugEventModule {
  /// A generic event which did not specify what module it occurred inside of.
  unknown,

  /// An event that occurred in the shop module.
  shops,

  /// An event that occurred in the quotation module.
  quotations,

  /// An event that occurred in the chat module.
  chats,

  /// This is something that has to do with moments.
  moments,

  /// An event that occurred in the events module.
  events,

  /// An event that occurred in the groups module.
  groups,

  /// An event that occurred in the pages module.
  pages,

  /// An event that occurred in the notifications module.
  notifications,

  /// An event that occurred in the follower and following module.
  relationships,

  /// An event that occurred in the posts module.
  posts,

  /// An event that occurred in the donations module.
  donations,

  /// An event that occurred in the polls module.
  polls,

  /// This is happening because of feed.
  feed,

  /// An event that occurred in the support module.
  support,

  /// An event that occurred in the disputes module.
  disputes,

  /// An event that occurred in the wallet module.
  wallets,

  /// An event that occurred in the UGT module.
  ugt,

  /// An event that occurred in the promotion module.
  promotion,
}

class WayaDebugEvent {
  final WayaDebugEventType type;
  final WayaDebugEventModule module;
  final String message;
  final Object? raw;
  final StackTrace? stackTrace;
  final DateTime timestamp;
  final read = ValueNotifier(false);

  // Construct.
  WayaDebugEvent({
    required this.type,
    required this.module,
    required this.message,
    required this.raw,
    required this.stackTrace,
    required this.timestamp,
  });
}

class WayaDebugConsoleController {
  static final instance = WayaDebugConsoleController._();
  final errors = <WayaDebugEvent>[];

  /// A value notifier that is used to refresh the debug console component.
  final refreshNotifier = ValueNotifier(0);
  var _awaiter = Completer<void>();
  bool visible = false;
  bool inDetail = false;

  /// Helper function used to get the total count of all unread messages.
  int get unreadCount => errors.where((error) => !error.read.value).length;

  // Construct.
  WayaDebugConsoleController._();

  /// A utility function used to collapse the debug console to make it easier to
  /// interact with content on the screen.
  void collapse() {
    visible = false;
    refresh();
    _awaiter.complete();
    _awaiter = Completer<void>();
  }

  /// A utility function used to expand the debug console to make it easier to
  /// read the current contents of the debug console in order for all of us to
  /// know what the hell is going on. This returns a future that is completed
  /// when the debug console is collapsed once more.
  Future<void> expand() {
    //? Just leave it is already visible.
    if (visible) _awaiter.future;

    //? Since it is not, you can do this.
    visible = true;
    refresh();
    return _awaiter.future;
  }

  /// A function that serves no purpose but to manually trigger a console refresh.
  /// It is naturally obvious that this is not a function with a lot of utility
  /// when there is no problem you are trying to investigate.
  void refresh() {
    refreshNotifier.value = refreshNotifier.value + 1;
  }

  /// A function that is used to mark a given debug log as read using its index.
  void markAsRead(int index) {
    //? Now, we resolve this issue.
    if (index >= errors.length) return;

    //? Since we can, try to resolve this issue.
    errors[index].read.value = true;
  }

  /// A function used to toggle whether or not we are currently viewing anything
  /// in detail.
  void setDetail(bool value) {
    inDetail = value;
    refresh();
  }

  /// A function that is used to mark all messages past the unread starting
  /// point as read.
  void markAllAsRead() {
    //? For each message we have that is unread...
    for (int i = 0; i < errors.length; i++) {
      errors[i].read.value = true;
    }

    //? Refresh this.
    refresh();
  }

  /// A function used to add a new debug event so it becomes visible to the
  /// people who can view the debug message.
  void addDebugEvent(WayaDebugEvent event) {
    errors.insert(0, event);
    refresh();
  }

  /// A function used to add a new exception to the list of errors. Care and
  /// attention should be paid while using this function because it is kind of
  /// a wrapper around its more complicated predecessor.
  void addException(
    String message,
    dynamic error,
    WayaDebugEventModule module, [
    StackTrace? stackTrace,
    WayaDebugEventType type = WayaDebugEventType.exception,
  ]) {
    addDebugEvent(
      WayaDebugEvent(
        type: type,
        module: module,
        message: message,
        raw: error,
        stackTrace: stackTrace,
        timestamp: DateTime.now(),
      ),
    );
  }
}

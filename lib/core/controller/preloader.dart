import 'package:flutter/material.dart';

class WayaPreloaderController {
  static final instance = WayaPreloaderController._();
  final notifier = ValueNotifier(false);

  // Construct.
  WayaPreloaderController._();

  /// A utility function that is supposed to be used to show the preloader so
  /// that it is now visible.
  void show() {
    notifier.value = true;
  }

  /// A utility function that is supposed to be used to hide the preloader so
  /// that it is no longer visible.
  void hide() {
    notifier.value = false;
  }
}

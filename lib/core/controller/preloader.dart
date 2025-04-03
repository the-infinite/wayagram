import 'package:flutter/material.dart';

class WayaPreloaderController {
  static final instance = WayaPreloaderController._();
  final notifier = ValueNotifier(false);
  bool hideOnEnd = false;

  // Construct.
  WayaPreloaderController._();

  /// A utility function that is supposed to be used to show the preloader so
  /// that it is now visible.
  void show() {
    notifier.value = true;
  }

  /// A utility function that is supposed to be used to hide the preloader so
  /// that it is no longer visible. This would IMMEDIATELY hide the preloader
  /// such that it is no longer visible on screen.
  void dismiss() {
    hideOnEnd = false;
    notifier.value = false;
  }

  /// A utility function used to choose when to hide the preloader ONLY after
  /// the next cycle of frames is rendered.
  void hide() {
    hideOnEnd = true;
  }
}

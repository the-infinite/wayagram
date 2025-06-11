import 'package:flutter/material.dart';
import 'package:wayagram/core/data/local_data_source.dart';

class ChatSettingsNotifier extends ValueNotifier<int> {
  final storage = WayaLocalDataSource.instance;
  bool _isDark = false;
  double _scaleFactor = 1;

  static final instance = ChatSettingsNotifier._();

  ChatSettingsNotifier._() : super(0);

  /// Utility used to retrieve whether or not chats should be viewed in dark
  /// mode.
  bool get isDarkMode => _isDark;

  /// Utility used to retrieve the multiplier used to scale font for the text in
  /// messages in chats.
  double get textScale => _scaleFactor;

  /// Utility function used to initialize the value of the variables inside of
  /// this notifier to elements already inside of the device storage.
  void reload() {
    _scaleFactor = storage.getChatFontSize();
    _isDark = storage.getChatTheme();
    update();
  }

  /// Utility function used to update the dark mode configuration for all chats
  /// inside this app.
  void setDarkMode(bool value) async {
    await storage.saveChatTheme(value);
    _isDark = value;
    update();
  }

  /// Utility function used to update the font size configuration for all chats
  /// inside this app.
  void setTextScale(double value) async {
    await storage.saveChatFontSize(value);
    _scaleFactor = value;
    update();
  }

  /// Utility function used to update the value of this get controller. Useful
  /// when we try to figure out how many times it was redrawn.
  void update() {
    value = value + 1;
  }
}

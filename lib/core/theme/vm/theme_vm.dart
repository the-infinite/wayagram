import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final WayaLocalDataSource _localDataSource = WayaLocalDataSource();
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = _localDataSource.getCurrentThemeMode() ?? false;

    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() async {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    _localDataSource.saveThemeModeBoolean(state == ThemeMode.dark);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);

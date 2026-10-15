import 'package:flutter/material.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

enum SnackbarType { success, failure }

class SnackbarConfig {
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final DismissDirection dismissDirection;
  final EdgeInsets margin;
  final double barBlur;
  final Color messageColor;
  final bool isFloating;
  final bool isDismissible;

  SnackbarConfig({
    required this.backgroundColor,
    required this.textColor,
    required this.borderRadius,
    required this.dismissDirection,
    required this.margin,
    required this.barBlur,
    required this.messageColor,
    required this.isFloating,
    required this.isDismissible,
  });
}

class SnackbarService {
  SnackbarService._internal();
  static final SnackbarService _instance = SnackbarService._internal();
  factory SnackbarService() => _instance;

  final Map<SnackbarType, SnackbarConfig> _snackbarConfigs = {};

  void registerCustomSnackbarConfig({
    required SnackbarType variant,
    required SnackbarConfig config,
  }) {
    _snackbarConfigs[variant] = config;
  }

  void showCustomSnackbar({
    required SnackbarType variant,
    required String message,
  }) {
    final config = _snackbarConfigs[variant];
    final context = WayaNav.navigatorKey.currentContext;
    if (context != null && config != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: config.textColor),
          ),
          backgroundColor: config.backgroundColor,
          behavior: config.isFloating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
          margin: config.margin,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(config.borderRadius),
          ),
          dismissDirection: config.dismissDirection,
        ),
      );
    } else if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }
}

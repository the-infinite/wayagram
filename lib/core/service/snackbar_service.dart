import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackbarType { success, failure }

class SnackbarConfig {
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final DismissDirection dismissDirection;
  final EdgeInsets margin;
  final double barBlur;
  final Color messageColor;
  final SnackPosition snackPosition;
  final SnackStyle snackStyle;

  SnackbarConfig({
    required this.backgroundColor,
    required this.textColor,
    required this.borderRadius,
    required this.dismissDirection,
    required this.margin,
    required this.barBlur,
    required this.messageColor,
    required this.snackPosition,
    required this.snackStyle,
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
    if (config != null) {
      Get.snackbar(
        '',
        message,
        backgroundColor: config.backgroundColor,
        colorText: config.textColor,
        borderRadius: config.borderRadius,
        dismissDirection: config.dismissDirection,
        margin: config.margin,
        barBlur: config.barBlur,
        snackPosition: config.snackPosition,
        snackStyle: config.snackStyle,
        
      );
    } else {
      Get.snackbar('', message); 
    }
  }
}
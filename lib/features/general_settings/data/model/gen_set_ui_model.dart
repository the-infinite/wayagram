import 'package:flutter/material.dart';

class GeneralSettingsOptionModel {
  final String title;
  final VoidCallback? onTap;
  final String iconPath;
  final bool isRealPath;

  GeneralSettingsOptionModel({required this.title, this.onTap, required this.iconPath, this.isRealPath = false});
}

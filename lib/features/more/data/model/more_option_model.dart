import 'package:flutter/material.dart';

class MoreOptionModel {
  final String title;
  final String content;
  final String asset;
  final VoidCallback onTap;

  MoreOptionModel(
      {required this.asset, required this.content, required this.title, required this.onTap});
}

import 'dart:io';

import 'package:flutter/material.dart';

enum StatusType { text, media }

class MomentState {
  final Color backgroundColor;
  final TextStyle textStyle;
  final String text;
  final StatusType type;
  final File? selectedImage;
  final String caption;
  final bool showCaption;

  MomentState({
    required this.backgroundColor,
    required this.textStyle,
    this.text = '',
    this.type = StatusType.text,
    this.selectedImage,
    this.caption = '',
    this.showCaption = false
  });

  MomentState copyWith(
      {Color? backgroundColor,
      TextStyle? textStyle,
      String? text,
      StatusType? type,
      File? selectedImage,
      bool? showCaption,
      String? caption}) {
    return MomentState(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        textStyle: textStyle ?? this.textStyle,
        text: text ?? this.text,
        caption: caption ?? this.caption,
        showCaption: showCaption ?? this.showCaption,
        selectedImage: selectedImage ?? this.selectedImage,
        type: type ?? this.type);
  }
}

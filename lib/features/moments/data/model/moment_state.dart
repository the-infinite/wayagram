import 'dart:io';

import 'package:flutter/material.dart';

enum StatusType { text, media }

enum MediaType { image, video }

class MomentState {
  final Color backgroundColor;
  final TextStyle textStyle;
  final String text;
  final StatusType type;
  final File? selectedFile;
  final MediaType? mediaType;
  final String caption;
  final bool showCaption;
  final bool isImagePickerOpen;
  final bool isLoadingUserMoments;
  final bool isCreatingMoment;

  MomentState(
      {required this.backgroundColor,
      required this.textStyle,
      this.text = '',
      this.selectedFile,
      this.type = StatusType.text,
      this.mediaType,
      this.caption = '',
      this.isCreatingMoment = false,
      this.isImagePickerOpen = false,
      this.showCaption = false,
      this.isLoadingUserMoments = false});

  MomentState copyWith({
    Color? backgroundColor,
    TextStyle? textStyle,
    String? text,
    StatusType? type,
    File? selectedFile,
    bool? showCaption,
    bool? isImagePickerOpen,
    MediaType? mediaType,
    bool? isLoadingUserMoments,
    String? caption,
    bool? isCreatingMoment
  }) {
    return MomentState(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      text: text ?? this.text,
      caption: caption ?? this.caption,
      isImagePickerOpen: isImagePickerOpen ?? this.isImagePickerOpen,
      showCaption: showCaption ?? this.showCaption,
      selectedFile: selectedFile ?? this.selectedFile,
      mediaType: mediaType ?? this.mediaType,
      isLoadingUserMoments: isLoadingUserMoments ?? this.isLoadingUserMoments,
      type: type ?? this.type,
      isCreatingMoment: isCreatingMoment ?? this.isCreatingMoment
    );
  }
}

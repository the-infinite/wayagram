import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wayagram/features/moments/data/model/moment_response_model.dart';

enum StatusType { text, media }

enum MediaType { image, video }

class MomentState {
  final Color backgroundColor;
  final TextStyle textStyle;
  final String text;
  final StatusType type;
  final File? selectedFile;
  final MediaType? mediaType;
  final String? mediaUrl;
  final String caption;
  final bool showCaption;
  final bool isImagePickerOpen;
  final bool isLoadingUserMoments;
  final bool isCreatingMoment;
  final bool isLoadingUserMoment;
  final List<MomentData> myMoments;
  final List<MomentData> moments;
  final bool isReportingMoment;
  final String userId;
  final bool isEditingMode;
  final String momentId;

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
      this.isLoadingUserMoment = false,
      this.myMoments = const [],
      this.userId = '',
      this.moments = const [],
      this.isEditingMode = false,
      this.isReportingMoment =false,
      this.mediaUrl = '',
      this.momentId = '',
      this.isLoadingUserMoments = false});

  MomentState copyWith(
      {Color? backgroundColor,
      TextStyle? textStyle,
      String? text,
      StatusType? type,
      File? selectedFile,
      bool? showCaption,
      bool? isImagePickerOpen,
      MediaType? mediaType,
      bool? isLoadingUserMoments,
      String? caption,
      String? userId,
      bool? isLoadingUserMoment,
      List<MomentData>? myMoments,
      bool? isEditingMode,
      String? momentId,
      String? mediaUrl,
      bool? isReportingMoment,
      List<MomentData>? moments,
      bool? isCreatingMoment}) {
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
        userId: userId ?? this.userId,
        isEditingMode: isEditingMode ?? this.isEditingMode,
        moments: moments ?? this.moments,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        momentId: momentId ?? this.momentId,
        isReportingMoment: isReportingMoment ?? this.isReportingMoment,
        isLoadingUserMoment: isLoadingUserMoment ?? this.isLoadingUserMoment,
        myMoments: myMoments ?? this.myMoments,
        isCreatingMoment: isCreatingMoment ?? this.isCreatingMoment);
  }
}

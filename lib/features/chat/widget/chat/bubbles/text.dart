import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/model/message.dart';

class TextMessageWidget extends StatelessWidget {
  final MessageModel data;
  final Color textColor;

  // Construct.
  const TextMessageWidget({
    super.key,
    required this.data,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return WayaCollapsibleText(
      data.content ?? '',
      initialState: true,
      textColor: textColor,
      buttonColor: textColor,
      maxLines: 10,
      style: WayaTextStyles.bodyMedium.copyWith(
        fontSize: 15.sp,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
    );
  }
}

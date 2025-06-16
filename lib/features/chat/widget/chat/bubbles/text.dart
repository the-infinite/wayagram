import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/general_settings/chat_settings/vm.dart';

class TextMessageWidget extends StatelessWidget {
  final MessageModel data;
  final Color textColor;
  final bool isMyMessage;

  // Construct.
  const TextMessageWidget({
    super.key,
    required this.data,
    required this.textColor,
    this.isMyMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    return WayaCollapsibleText(
      data.content ?? '',
      textColor: textColor,
      buttonColor: textColor,
      linkCustomColor: isMyMessage ? WayaColors.white : null,
      maxLines: 10,
      fontSize: 15.sp * ChatSettingsNotifier.instance.textScale,
      style: WayaTextStyles.bodyMedium.copyWith(
        fontSize: 15.sp * ChatSettingsNotifier.instance.textScale,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
    );
  }
}

import 'package:flutter/material.dart';
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
    return Text(
      data.content!,
      style: WayaTextStyles.bodyMedium.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
    );
  }
}

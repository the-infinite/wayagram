import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';

class WayaNoticeModal extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onPress;
  final String buttonText;
  final Widget icon;

  const WayaNoticeModal(
      {super.key,
      required this.title,
      required this.message,
      required this.buttonText,
      required this.icon,
      required this.onPress})
     ;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context).colorScheme;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 60),
        decoration: BoxDecoration(
          color: wayaTheme.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const Gap(30),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: WayaTextStyles.descriptionStyle,
            ),
            const Gap(24),
            WayaButton(
                callback: () {
                 // Navigator.of(context).pop();
                  onPress();
                },
                text: buttonText)
          ],
        ),
      ),
    );
  }
}

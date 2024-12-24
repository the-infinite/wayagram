import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class WayaRichText extends StatelessWidget {
  final String title1;
  final String title2;
  final VoidCallback? onTap2;
  const WayaRichText({
    required this.title1,
    required this.title2,
    this.onTap2,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 18.0, // Default font size
          color: Colors.black, // Default color
        ),
        children: [
          TextSpan(
              text: title1,
              style: wayaTheme.textTheme.hintStyle
                  .wayaCopyWith(fontWeight: FontWeight.w500, color: wayaTheme.colorScheme.black)),
          TextSpan(
            text: title2,
            style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
              color: wayaTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap2,
          ),
        ],
      ),
    );
  }
}

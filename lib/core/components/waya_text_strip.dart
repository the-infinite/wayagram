import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/theme.dart';

class WayaTextStrip extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final Color backgroundColor;
  final Color textColor;
  final Color? dividerColor;

  const WayaTextStrip(
    this.text, {
    super.key,
    this.style,
    this.backgroundColor = WayaColors.scaffoldColor2,
    this.textColor = WayaColors.greyColor400,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Divider(
          color: dividerColor ?? textColor,
        ),

        //? If this is not empty...
        if (text != null && text!.isNotEmpty)
          Container(
            color: backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              text!,
              style: style == null
                  ? WayaTextStyles.bodyMedium.copyWith(
                      backgroundColor: backgroundColor,
                      color: textColor,
                    )
                  : style?.copyWith(
                      backgroundColor: backgroundColor,
                      color: textColor,
                    ),
            ),
          )
      ],
    );
  }
}

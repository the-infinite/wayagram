
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

class DonationTabButton extends StatelessWidget {
  final bool isSelected;
  final bool isLongerTab;
  final String text;
  final VoidCallback onTap;

  final double? width;
  final Widget? end;

  const DonationTabButton({
    super.key,
    required this.isSelected,
    required this.text,
    required this.onTap,
    this.width,
    this.isLongerTab = false,
    this.end,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = context.width;
    double fontSize = 0;
    if (isLongerTab) {
      fontSize = screenWidth * 0.030;
    } else {
      fontSize = screenWidth * 0.038;
    }

    //?
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: isSelected ? theme.colorScheme.primar50
                : theme.colorScheme.white,
            border: Border.all(
                color: isSelected
                      ? theme.colorScheme.primar50
                      : theme.colorScheme.greyColor300,
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            spacing: 5,
            children: [
              //? Fill available space.
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.greyColor500,
                  ),
                ),
              ),

              //? Put the thing here if needed.
              if (end != null) end!,
            ],
          ),
        ),
      ),
    );
  }
}
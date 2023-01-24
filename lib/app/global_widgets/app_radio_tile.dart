import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../../core/theme/app_themes.dart';

class AppRadioTile extends StatelessWidget {
  const AppRadioTile({
    Key? key,
    required this.title,
    this.isSelected = false,
    this.subtitle,
    this.subtitleisRed = true, this.onChanged,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final bool isSelected;
  final bool subtitleisRed;
  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppThemes.lightTheme.copyWith(
        unselectedWidgetColor: AppColors.spanishGray,
      ),
      child: Row(
        children: [
          Transform.translate(
            offset: const Offset(-10, 0),
            child: Radio(
              visualDensity: VisualDensity.compact,
              value: isSelected,
              groupValue: true,
              // overlayColor: MaterialStateProperty.all(AppColors.onyx),
              activeColor: AppColors.bostonUniRed,
              onChanged: onChanged,
            ),
          ),
          Transform.translate(
            offset: const Offset(-10, 0),
            child: Text(
              title,
              style:
                  AppTextStyle.bodyText2.copyWith(color: AppColors.spanishGray),
            ),
          ),
          subtitle != null ? const Spacer() : const SizedBox.shrink(),
          subtitle != null
              ? Text(
                  subtitle!,
                  style: AppTextStyle.bodyText2.copyWith(
                    color:
                        subtitleisRed ? AppColors.bostonUniRed : Colors.white,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

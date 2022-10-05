import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';

class DateItemButton extends StatelessWidget {
  const DateItemButton({
    Key? key,
    required this.title,
    this.color = AppColors.bostonUniRed,
    this.textColor = Colors.white,
  }) : super(key: key);

  final String title;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
          width: 1,
        ),
      ),
      child: Text(
        title,
        style: theme.textTheme.caption!.copyWith(color: textColor),
      ),
    );
  }
}

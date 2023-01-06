import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';

class DateItemButton extends StatelessWidget {
  DateItemButton({
    Key? key,
    required this.title,
    this.color = Colors.black,
    this.textColor = Colors.black,
    this.icon
  }) : super(key: key);

  final String title;
  final Color color;
  final Color textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF828282),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.purple,
            size: Get.width * 0.050,
          ),
          SizedBox(width: Get.width * 0.030),
          Text(
            title,
            style: theme.textTheme.subtitle1!.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}

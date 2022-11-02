import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';

class DateItemButton extends StatelessWidget {
  const DateItemButton({
    Key? key,
    required this.title,
    this.color = Colors.black,
    this.textColor = Colors.black,
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
          color: const Color(0xFF828282),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: theme.textTheme.subtitle1!.copyWith(color: textColor),
      ),
    );
  }
}

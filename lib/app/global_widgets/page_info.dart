import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';

class PageInfo extends StatelessWidget {
  const PageInfo({
    Key? key,
    required this.title,
    required this.subtitle,
    this.subtitleisRed = false, this.fontSize,
  }) : super(key: key);
  final String title;
  final String subtitle;
  final bool subtitleisRed;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.bodyText2.copyWith(color: AppColors.spanishGray),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          textAlign: TextAlign.justify,
          style: AppTextStyle.bodyText2.copyWith(
            height: 1.6,
            fontSize: fontSize,
            color: subtitleisRed ? AppColors.bostonUniRed : null,
          ),
        ),
      ],
    );
  }
}

class HorizontalPageInfo extends StatelessWidget {
  const HorizontalPageInfo({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        const SizedBox(width: 10),
        Text(subtitle),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class GroupedWidgetHeader extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String subTitle;

  const GroupedWidgetHeader(
      {super.key,
      required this.onTap,
      required this.subTitle,
      required this.title});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(title, style: wayaTheme.textTheme.titleLarge),
            const Gap(3),
            Text(
              subTitle,
              style: wayaTheme.textTheme.hintStyle,
            )
          ],
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            "See All",
            style: TextStyle().wayaCopyWith(
                color: wayaTheme.colorScheme.customPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }
}

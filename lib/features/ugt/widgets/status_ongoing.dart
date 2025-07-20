import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';

class StatusOngoing extends StatelessWidget {
  final String title;
  final String content;
  const StatusOngoing({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    //final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: WayaTextStyles.hintStyleBold.wayaCopyWith(
            color: WayaColors.greyColor500,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Gap(5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(content.toLowerCase() == "active" ? "Ongoing" : content,
              style: WayaTextStyles.bodyMedium.copyWith(color: Colors.green)),
        ),
      ],
    );
  }
}

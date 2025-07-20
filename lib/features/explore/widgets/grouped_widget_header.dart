import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';

class GroupedWidgetHeader extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String subTitle;
  final bool isVisible;

  const GroupedWidgetHeader({
    super.key,
    this.onTap,
    required this.subTitle,
    this.isVisible = true,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Visibility(
      visible: isVisible,
      child: Row(
        spacing: 2.w,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: wayaTheme.textTheme.titleLarge?.copyWith(),
                ),
                const Gap(3),
                Text(
                  subTitle,
                  style: WayaTextStyles.hintStyleBold.wayaCopyWith(
                    color: WayaColors.greyColor500,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: onTap != null,
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                "See All",
                style: WayaTextStyles.hintStyleBold
                    .wayaCopyWith(color: WayaColors.primary500),
              ),
            ),
          )
        ],
      ),
    );
  }
}

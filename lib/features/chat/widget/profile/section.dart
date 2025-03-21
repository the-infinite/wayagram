import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

class SectionCountButton extends StatelessWidget {
  final String title;
  final int count;
  final int value;
  final ValueNotifier<int> controller;

  // Construct.
  const SectionCountButton({
    super.key,
    required this.title,
    required this.count,
    required this.value,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == controller.value;
    final theme = Theme.of(context);

    // Our component.
    return GestureDetector(
      onTap: () {
        controller.value = value;
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary50 : theme.colorScheme.transparent,
          borderRadius: BorderRadius.circular(6.r),
          border: isSelected ? null : Border.fromBorderSide(BorderSide(color: theme.colorScheme.greyColor300)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //? First, the text.
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.greyColor400,
                fontSize: 14.sp,
              ),
            ),

            //? Finally, the other thing.
            ClipPath(
              clipper: ShapeBorderClipper(
                shape: StadiumBorder(),
              ),
              child: ColoredBox(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.scaffoldColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    WayaValueHelper.formatNumber(count),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected ? theme.colorScheme.white : theme.colorScheme.greyColor500,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

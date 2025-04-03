import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class EngagementRange extends StatelessWidget {
  final String? topLeft;

  final String bottomRight;
  final String bottomLeft;
  final double range;
  const EngagementRange(
      {super.key,
      required this.bottomLeft,
      required this.bottomRight,
      required this.range,
      this.topLeft});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (topLeft != null)
          Text(
            topLeft!,
            style: TextStyle().wayaCopyWith(
                color: wayaTheme.colorScheme.customBlack,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500),
          ),
        const Gap(8),
        SizedBox(
          width: double.infinity,
          height: 10,
          child: Stack(
           clipBehavior: Clip.hardEdge,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: wayaTheme.colorScheme.greyColor200,
                ),
                height: 10,
                width: double.infinity,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: wayaTheme.colorScheme.customPrimary,
                ),
                height: 10,
                width: context.width * range,
              ),
            ],
          ),
        ),
        const Gap(8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              bottomLeft,
              style: TextStyle().wayaCopyWith(
                  color: wayaTheme.colorScheme.customBlack,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              bottomRight,
              textAlign: TextAlign.end,
              style: TextStyle().wayaCopyWith(
                  color: wayaTheme.colorScheme.customBlack,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const Gap(20),
      ],
    );
  }
}


//
//
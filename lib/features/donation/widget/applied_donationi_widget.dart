

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class AppliedDonationWidget extends ConsumerWidget {
  final VoidCallback? onTap;
  final String text;
  final int? donationCount;
  final String? title;
  final String? image;
  final String? targetAmount;
  final String? amountRaised;
  final String? dayLeft;
  final double buttonWidth;
  final double rangeRatio;
  const AppliedDonationWidget({
    super.key,

    required this.onTap,
    required this.text,
    required this.donationCount,
    required this.title,
    required this.image,
    required this.targetAmount,
    required this.amountRaised,
    required this.dayLeft,
    required this.buttonWidth,
    required this.rangeRatio,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);

    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              color: wayaTheme.colorScheme.white,
              border: Border.all(color: wayaTheme.colorScheme.greyColor200, width: 1),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaImage(
                  imageUrl: '$image',
                  height: 180.h,
                  width: double.infinity,
                  radius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$title',
                        overflow: TextOverflow.ellipsis,
                        style: wayaTheme.textTheme.bodyMedium,
                      ),
                   Gap(10),
                    ],
                  ),
                )
              ],
            )),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';

class AppliedDonationWidget extends ConsumerWidget {
  final VoidCallback? onTap;
  final String privacy;
  final String? title;
  final String? status;
  final String? image;
  final String? targetAmount;
  final String? startDate;
  final String? endDate;
  final Color color;
  final Color textColor;
  const AppliedDonationWidget({
    super.key,

    required this.onTap,
    required this.privacy,
    required this.title,
    required this.status,
    required this.image,
    required this.targetAmount,
    required this.startDate,
    required this.endDate,
    required this.color,
    required this.textColor,

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
                      Gap(20),
                      Row(children: [
                        summary(context, 'Start date', startDate),
                        const Gap(30),
                        summary(context, 'End date', endDate),
                      ],),
                      Gap(20),
                      Row(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Application',
                              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.greyColor600 ),
                            ),
                            const Gap(5),
                            Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: 20.h,
                              width: 68.w,
                              child: Text(
                               '$status',
                                style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: WayaConstants.fontFamily,
                                    color: textColor ),
                                textAlign:TextAlign.center ,
                              ),

                            ),
                          ],
                        ),
                        const Gap(50),
                        summary(context, 'Target Amount', targetAmount),
                        const Gap(30),
                        summary(context, 'Privacy Settings', privacy),
                      ],),
                      Gap(20),
                      WayaButton(
                        text: 'View Application Details',
                        color: wayaTheme.colorScheme.primary500,
                        textColor: wayaTheme.colorScheme.white,
                        border:
                        Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
                        callback: onTap,
                        height: 32,
                        textStyle: WayaTextStyles.bodySmall.copyWith(
                            fontSize: 14.sp,
                            fontFamily: WayaConstants.fontFamily,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.white ),

                      ),
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
  Widget summary(ctx, title, subTitle){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Theme.of(ctx).colorScheme.greyColor600 ),
        ),
        const Gap(5),
        Text(
          subTitle,
          style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(ctx).colorScheme.black ),
        ),
      ],
    );
  }
}
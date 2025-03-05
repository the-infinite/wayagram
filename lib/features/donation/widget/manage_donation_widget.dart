import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/shared/components/engagement_range.dart';

import '../model/my_donation_model.dart';

class ManageDonationWidget extends ConsumerWidget {
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
  const ManageDonationWidget({
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 220.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$title',
                                  overflow: TextOverflow.ellipsis,
                                  style: wayaTheme.textTheme.bodyMedium,
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                Text(
                                  '$amountRaised raised from $targetAmount',
                                  style: wayaTheme.textTheme.hintStyle,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: buttonWidth,
                            child: WayaButton(
                              centerWidget: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    text,
                                    style: TextStyle().wayaCopyWith(
                                        color: wayaTheme.colorScheme.customPrimary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              radius: 5,
                              height: 30,
                              callback: onTap,
                              color: wayaTheme.colorScheme.primar50,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      EngagementRange(
                          bottomLeft:
                              '$donationCount ${donationCount == 0 || donationCount == 1 ? 'Donation' : 'Donations'}',
                          bottomRight: "$dayLeft ${dayLeft == '1' ? 'day' : 'days'} left",
                          range: rangeRatio
                          //donationCount == 0 ? 0.0 : 0.4
                      )
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

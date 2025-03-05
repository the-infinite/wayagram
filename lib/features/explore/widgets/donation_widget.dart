import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/donation/model/my_donation_model.dart';
import 'package:wayagram/shared/components/engagement_range.dart';

class DonationWidget extends ConsumerWidget {
  final MyDonationDocs donation;
  const DonationWidget({super.key, required this.donation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);

    int daysLeft = DateTime.parse(donation.expirationDate!)
        .difference(DateTime.now())
        .inDays;

    if (daysLeft < 0) {
      daysLeft = 0;
    }

    int amountRaised = double.parse(donation.amountRaised!).toInt();

    int targetedAmount = double.parse(donation.targetAmount!).toInt();

    double ratioLeft = amountRaised / targetedAmount;

    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              color: wayaTheme.colorScheme.white,
              border: Border.all(
                  color: wayaTheme.colorScheme.greyColor200, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaImage(
                  imageUrl: donation.imageURL ?? '',
                  height: 180.h,
                  width: double.infinity,
                  radius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
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
                                  "${donation.title?.capitalizeFirst}",
                                  overflow: TextOverflow.ellipsis,
                                  style: wayaTheme.textTheme.bodyMedium,
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                Text(
                                  "${WayaHelpers.formatPrice(double.parse(donation.amountRaised!).toInt())} raised from ${WayaHelpers.formatPrice(double.parse(donation.targetAmount!).toInt())}",
                                  style: wayaTheme.textTheme.hintStyle,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 65,
                            child: WayaButton(
                              callback: () {
                                WayaNav.toNamed('/donationDetails',
                                    arguments: {
                                      'title':
                                          '${donation.title?.capitalizeFirst}',
                                      'image': '${donation.imageURL}',
                                      'amountRaised':
                                          '${donation.amountRaised?.replaceAll('.00', '')}',
                                      'targetAmount':
                                          '${donation.targetAmount?.replaceAll('.00', '')}',
                                      'desc': '${donation.description}',
                                      'solution': '${donation.solution}',
                                      'impact': '${donation.impact}',
                                      'url': '${donation.url}',
                                      'minimumDonationAmount':
                                          '${donation.minimumDonationAmount}',
                                      'daysLeft': '$daysLeft',
                                      'id': '${donation.id}',
                                    });
                              },
                              text: "Donate",
                              height: 30,
                              color: wayaTheme.colorScheme.primar50,
                              textStyle: TextStyle(fontSize: 12, color:  wayaTheme.colorScheme.customPrimary),
                              textColor: wayaTheme.colorScheme.customPrimary,
                              radius: 5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      EngagementRange(
                          bottomLeft: "${donation.donationCount} Donation",
                          bottomRight:
                              "$daysLeft ${daysLeft > 0 ? "Days" : "Day"} left",
                          range: ratioLeft)
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

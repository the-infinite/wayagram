import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/shared/components/engagement_range.dart';

class DonationWidget extends ConsumerWidget {
  const DonationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
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
                  imageUrl: "",
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
                                  "Send Micheal to oxford university",
                                  overflow: TextOverflow.ellipsis,
                                  style: wayaTheme.textTheme.bodyMedium,
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                Text(
                                  "${WayaHelpers.formatPrice(20000)} raised from ${WayaHelpers.formatPrice(100000)}",
                                  style: wayaTheme.textTheme.hintStyle,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 65,
                            child: WayaButton(
                              callback: () {},
                              text: "Donate",
                              height: 30,
                              color: wayaTheme.colorScheme.primar50,
                              textStyle: wayaTheme.textTheme.hintStyle
                                  .wayaCopyWith(
                                      color:
                                          wayaTheme.colorScheme.customPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                              radius: 5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      EngagementRange(
                          bottomLeft: "500 Donators",
                          bottomRight: "20 days left",
                          range: 0.4)
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

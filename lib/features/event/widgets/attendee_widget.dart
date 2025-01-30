import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

class AttendeeWidget extends ConsumerWidget {
  const AttendeeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.greyColor100,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        WayaImage(
                          imageUrl: "",
                          height: 60,
                          width: 60,
                          radius: BorderRadius.circular(16),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 150.w,
                              child: Text("Emeka Henderson",
                                  overflow: TextOverflow.ellipsis,
                                  style: wayaTheme.textTheme.bodyMedium),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            SizedBox(
                              width: 150.w,
                              child: Text(
                                "@maleek 2024",
                                style: wayaTheme.textTheme.hintStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        )
                      ],
                    ),

                    SizedBox(
                      width: 60,
                      child: WayaButton(
                        callback: () {},
                        text: 'Follow',
                        height: 30,
                        textStyle: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                            color: wayaTheme.colorScheme.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                        radius: 5,
                      ),
                    ),

                    // SizedBox(
                    //   width: 80,
                    //   child: WayaButton(
                    //     callback: () {},
                    //     text:  'Following',
                    //     height: 30,
                    //     textStyle: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                    //         color: wayaTheme.colorScheme.customPrimary,
                    //         fontSize: 12,
                    //         fontWeight: FontWeight.w500),
                    //     radius: 5,
                    //     color: wayaTheme.colorScheme.transparent,
                    //     border: Border.all(
                    //         width: 1,
                    //         color: wayaTheme.colorScheme.customPrimary),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  "Find your sound . Discuss writing, composing, recording, and much more",
                  style: wayaTheme.textTheme.hintStyle,
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

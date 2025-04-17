import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';

class PromotedService extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final bool showTimeLeft;
  final bool isTextExtended;

  const PromotedService(
      {super.key,
      this.showTimeLeft = false,
      required this.title,
      required this.description,
      this.isTextExtended = false,
      required this.image});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return 
    InkWell(
      splashColor: theme.colorScheme.primary.withAlpha(30),
      focusColor: const Color.fromARGB(255, 179, 173, 170).withAlpha(30),
      highlightColor: theme.colorScheme.primary.withAlpha(30),
      onTap: (){},
    child:Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(color: theme.colorScheme.scaffoldColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 6.h,
              children: [
                WayaImage(
                  imageUrl: "",
                  height: 50,
                  width: 50,
                  radius: BorderRadius.circular(12),
                ),
                SizedBox(
                  width: showTimeLeft ? 150.w : 220.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 3.h,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        description,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.descriptionStyle
                            .copyWith(fontSize: 12.sp),
                      )
                    ],
                  ),
                )
              ],
            ),
            if (showTimeLeft)
              SizedBox(
                width: 60.w,
                child: WayaButton(
                    callback: () {},
                    height: null,
                    color: theme.colorScheme.primary50,
                    horizontalPadding: 8,
                    verticalPadding: 8,
                    centerWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(WayaAssets.icons.dclock.path),
                        Gap(3),
                        Text(
                          "7 Days left",
                          style: theme.textTheme.hintStyle.copyWith(
                              color: theme.colorScheme.customPrimary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    )),
              )
          ],
        )));
  }
}

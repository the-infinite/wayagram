import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/string_extension.dart';
import 'package:wayagram/core/utils/waya_routes.dart';
import 'package:wayagram/core/utils/waya_utils.dart';

class PromotedService extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final bool showTimeLeft;
  final bool isTextExtended;
  final String? timeLeft;
  final String? id;

  const PromotedService(
      {super.key,
      this.showTimeLeft = false,
      required this.title,
      required this.description,
      this.isTextExtended = false,
      this.timeLeft = '',
      this.id,
      required this.image});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
        splashColor: theme.colorScheme.primary.withAlpha(30),
        focusColor: const Color.fromARGB(255, 179, 173, 170).withAlpha(30),
        highlightColor: theme.colorScheme.primary.withAlpha(30),
        onTap: id != null
            ? () {
                WayaAppRoutes.getPromotionDetailScreen(id ?? '');
              }
            : null,
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            decoration: BoxDecoration(
                color: theme.colorScheme.scaffoldColor,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 6.h,
                  children: [
                    WayaImage(
                      imageUrl: image,
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
                            title.capitalizeFirst,
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
                    width: 85.w,
                    child: WayaButton(
                        callback: () {},
                        height: 30,
                        color: theme.colorScheme.primary50,
                        horizontalPadding: 4,
                        verticalPadding: 8,
                        centerWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(WayaAssets.icons.dclock.path),
                            Gap(2.w),
                            Text(
                              timeLeft != null
                                  ? WayaUtils.timeLeftUntil(timeLeft!)
                                  : "",
                              style: theme.textTheme.hintStyle.copyWith(
                                  color: theme.colorScheme.customPrimary,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        )),
                  )
              ],
            )));
  }
}

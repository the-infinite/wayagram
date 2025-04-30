import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class WayaErrorDialog extends StatelessWidget {
  final String title;
  final String subtitle;

  // Construct.
  const WayaErrorDialog({
    super.key,
    required this.title,
    this.subtitle = '',
  });

  // This is fine.
  @override
  Widget build(BuildContext context) {
    //? First, we obtain all things needed to build this widget.
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: Get.width,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Some space to give a decent amount of spacing between concerned
              // sections.
              Gap(30.h),

              //? First, the user's profile picture.
              Align(
                alignment: Alignment.center,
                child: WayaAssets.icons.erError.svg(
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.error,
                    BlendMode.srcIn,
                  ),
                  height: 80,
                  width: 80,
                ),
              ),

              // Something like space.
              Gap(10.h),

              //? Next, the title of this popup.
              Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.customBlack,
                  ),
                ),
              ),

              //? When there are subtitles...
              if (subtitle.isNotEmpty) ...[
                // Some space.
                Gap(5.h),

                //? Next, this user's username.
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.greyColor400,
                    ),
                  ),
                ),
              ],

              // Some space.
              Gap(25.h),

              //? Our block button.
              WayaButton(
                color: theme.colorScheme.primary,
                callback: WayaNav.goBack,
                text: "Close",
              ),

              // Some space.
              Gap(25.h),
            ],
          ),
        ),
      ),
    );
  }
}

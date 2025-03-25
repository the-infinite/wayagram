import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class WayaComingSoonDialog extends StatelessWidget {
  final bool variant;

  // Construct.
  const WayaComingSoonDialog({
    super.key,
    required this.variant,
  });

  // This is fine.
  @override
  Widget build(BuildContext context) {
    //? First, we obtain all things needed to build this widget.
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
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
          WayaAssets.icons.comingSoon.svg(
            height: 80.h,
            width: 80.h,
          ),

          // Something like space.
          Gap(10.h),

          //? Next, the title of this popup.
          Align(
            alignment: Alignment.center,
            child: Text(
              variant ? "Exciting Things Are Brewing!" : "Good Things Take Time!",
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.customBlack,
              ),
            ),
          ),

          //? When there are subtitles...
          // Some space.
          Gap(5.h),

          //? Next, this user's username.
          Align(
            alignment: Alignment.center,
            child: Text(
              variant
                  ? "This feature isn't available just yet, but trust us it'll be worth the wait. Stay tuned for updates!"
                  : "This feature isn't live yet, but we're working hard to bring it to you. Stay tuned!",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.greyColor400,
              ),
            ),
          ),

          // Some space.
          Gap(25.h),

          //? Our block button.
          WayaButton(
            color: theme.colorScheme.primary,
            callback: WayaNav.goBack,
            text: variant ? "Got it!" : "Alright, I'll wait!",
          ),

          // Some space.
          Gap(25.h),
        ],
      ),
    );
  }
}

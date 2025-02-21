import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

class SuccessfulSupportRequestDialog extends StatelessWidget {
  final String id;

  // Construct.
  const SuccessfulSupportRequestDialog({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    // Our real component.
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //? First, the celebration image.
            WayaAssets.images.successugt.image(),

            // Some space.
            Gap(30.h),

            //? Second, the title.
            Text(
              'Support Request Submitted',
              style: wayaTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: wayaTheme.colorScheme.black,
              ),
              textAlign: TextAlign.center,
            ),

            // Some space.
            Gap(3.h),

            //? Third, the message.
            Text(
              "Your request (#$id) has been logged. We'll get back to you shortly.",
              style: wayaTheme.textTheme.hintStyle,
              textAlign: TextAlign.center,
            ),

            // Some space.
            Gap(20.h),

            //? Finally, our button to explore wayagram.
            WayaButton(
              callback: () async {
                WayaNav.offNamed(BottomView.route);
              },
              text: "Explore Wayagram",
            ),
          ],
        ),
      ),
    );
  }
}

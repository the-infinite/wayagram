import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

class BuyerDisputeFailureModal extends StatelessWidget {
  const BuyerDisputeFailureModal({super.key});

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
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: wayaTheme.colorScheme.error500.withAlpha(30),
              ),
              child: Center(
                child: Icon(
                  Icons.cancel,
                  size: 50,
                  color: wayaTheme.colorScheme.error500,
                ),
              ),
            ),

            // Some space.
            Gap(30.h),

            //? Second, the title.
            Text(
              'Unable to submit your dispute',
              textAlign: TextAlign.center,
              style: wayaTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: wayaTheme.colorScheme.black,
              ),
            ),

            // Some space.
            Gap(3.h),

            //? Third, the message.
            Text(
              "We are unable to receive your dispute request at this time. Please try again later.",
              style: wayaTheme.textTheme.hintStyle,
              textAlign: TextAlign.center,
            ),

            // Some space.
            Gap(20.h),

            //? Finally, our button to explore wayagram.
            WayaButton(
              callback: () async {
                WayaNav.goBack(result: true);
              },
              text: "Try Again",
            ),
          ],
        ),
      ),
    );
  }
}

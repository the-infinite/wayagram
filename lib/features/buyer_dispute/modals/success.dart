import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

class BuyerDisputeSuccessModal extends StatelessWidget {
  const BuyerDisputeSuccessModal({super.key});

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
                color: wayaTheme.colorScheme.success50,
              ),
              child: Center(
                child: Icon(
                  Icons.check_circle,
                  size: 50,
                  color: wayaTheme.colorScheme.success,
                ),
              ),
            ),

            // Some space.
            Gap(30.h),

            //? Second, the title.
            Text(
              'Your dispute has been submitted successfully',
              textAlign: TextAlign.center,
              style: wayaTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: wayaTheme.colorScheme.black,
              ),
            ),

            // Some space.
            Gap(3.h),

            //? Third, the message.
            Text(
              "Our team is reviewing your claim",
              style: wayaTheme.textTheme.hintStyle,
              textAlign: TextAlign.center,
            ),

            // Some space.
            Gap(20.h),

            //? Finally, our button to explore wayagram.
            WayaButton(
              callback: () async {
                WayaNav.toNamed(WayaAppRoutes.getDisputeDetailsRoute("XXXXXX-XXXX-XXXX-XXXXXXXX"));
              },
              text: "View Dispute Details",
            ),
          ],
        ),
      ),
    );
  }
}

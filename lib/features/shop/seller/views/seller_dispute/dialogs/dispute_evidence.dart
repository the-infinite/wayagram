import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

class DisputeEvidence extends StatelessWidget {
  final String disputeImage;

  const DisputeEvidence({super.key, required this.disputeImage});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    // This is fine
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: context.width,
        height: context.height * 0.6,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        decoration: BoxDecoration(
          color: wayaTheme.colorScheme.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Evidence Detail",
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              Text(
                "Here is the image of the evidence",
                textAlign: TextAlign.start,
                style: wayaTheme.textTheme.descriptionStyle,
              ),
              const Gap(24),

              //? The dispute image.
              WayaImage(imageUrl: disputeImage, height: 300),

              // Space.
              const Gap(20),

              //? A button for going back.
              WayaButton(
                callback: () {
                  WayaNav.goBack();
                },
                textColor: wayaTheme.colorScheme.greyColor500,
                color: wayaTheme.colorScheme.transparent,
                border: Border.all(color: wayaTheme.colorScheme.greyColor500, width: 1),
                text: 'Cancel',
              )
            ],
          ),
        ),
      ),
    );
  }
}

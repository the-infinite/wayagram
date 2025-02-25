import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class BuyerDisputeEvidenceModal extends StatelessWidget {
  final String image;

  // Construct.
  const BuyerDisputeEvidenceModal({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    // This is fine.
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            //? First, the title of the popup.
            Text(
              "Evidence Details",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),

            // Some space.
            const Gap(5),

            Text(
              "Here is the full description of your evidence",
              style: theme.textTheme.descriptionStyle.copyWith(
                fontSize: 14,
              ),
            ),

            // Some space.
            Gap(30.h),

            //? For the dispute image.
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: image,
                width: size.width - 32,
                fit: BoxFit.cover,
              ),
            ),

            // Some space.
            Gap(50.h),

            //? Fair enough.
            WayaButton(
              callback: () => WayaNav.goBack(),
              textColor: theme.colorScheme.greyColor500,
              color: theme.colorScheme.transparent,
              border: Border.all(color: theme.colorScheme.greyColor300, width: 1),
              text: "Close",
            ),
          ],
        ),
      ),
    );
  }
}

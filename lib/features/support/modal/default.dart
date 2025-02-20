import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/support/views/chat.dart';
import 'package:wayagram/features/support/views/dispute.dart';
import 'package:wayagram/features/support/views/request.dart';

class SupportTypeDialog extends StatelessWidget {
  // Construct.
  const SupportTypeDialog({super.key});

  // This is fine.
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* The title.
                Text(
                  "How can we help you today?",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                //* The dismiss button.
                IconButton(
                  onPressed: () => WayaNav.goBack(),
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.all(2),
                    backgroundColor: theme.colorScheme.greyColor200,
                  ),
                  icon: WayaAssets.icons.actonDismiss.svg(
                    color: theme.colorScheme.black,
                  ),
                ),
              ],
            ),

            // Something like space.
            const Gap(10),

            //? Second, the grid of actions.
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: [
                //? First, for live chat
                WayaActionButton(
                  icon: WayaAssets.icons.mSupport.path,
                  title: "Livechat Support",
                  iconSize: 40.h,
                  description: "Talk to one of our agents about an experience to get help with any issues you are facing",
                  spacing: 6.h,
                  callback: () {
                    WayaNav.toNamed(SupportChatScreen.route);
                  },
                ),

                //? Second, for dispute requests.
                WayaActionButton(
                  icon: WayaAssets.icons.dispute.path,
                  title: "Dispute Resolution",
                  iconSize: 40.h,
                  description: "Reach out to our dedicated team about any disputes you have encountered while making a purchase.",
                  spacing: 6.h,
                  iconBackground: theme.colorScheme.info.withAlpha(30),
                  callback: () {
                    WayaNav.toNamed(SupportDisputeScreen.route);
                  },
                ),

                //? Third, for support requests.
                WayaActionButton(
                  icon: WayaAssets.icons.requestIcon.path,
                  title: "Support Request",
                  iconSize: 40.h,
                  description: "If you're looking for something else, you can create a ticket that gets sent to our support team.",
                  spacing: 6.h,
                  iconBackground: theme.colorScheme.error.withAlpha(30),
                  callback: () {
                    WayaNav.toNamed(SupportRequestScreen.route);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

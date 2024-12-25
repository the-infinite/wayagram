import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class SuccessfulSetup extends ConsumerWidget {
  const SuccessfulSetup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WayaScaffold(
      removeAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/auth/explore.png"),
                const Gap(50),
                Text(
                  "You are all set",
                  textAlign: TextAlign.center,
                  style: WayaTextStyles.titleLarge,
                ),
                const Gap(15),
                Text(
                  "Your referral code and virtual account are now \n active! You can easily access them anytime on \n your profile.",
                  textAlign: TextAlign.center,
                  style: WayaTextStyles.descriptionStyle,
                ),
              ],
            ),
          ),
          WayaButton(
            callback: () {
              WayaNav.toNamed("/forgot-password");
            },
            text: "Explore Wayagram",
          ),
          const Gap(20)
        ],
      ),
    );
  }
}

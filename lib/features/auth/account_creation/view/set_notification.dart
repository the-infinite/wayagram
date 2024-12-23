import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/account_creation/view/explore.dart';

class SetNotification extends ConsumerWidget {
  const SetNotification({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Padding(
      padding: WayaEdgeInsetsExtension.fromPercentage(
          lefthorizontalPercentage: 24,
          righthorizontalPercentage: 24,
          topverticalPercentage: 12,
          bottomverticalPercentage: 10,
          context: context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Image.asset("assets/images/auth/set-notification.png"),
          ),
          Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Don’t miss out on what your \n friends are up to",
                  textAlign: TextAlign.center,
                  style: WayaTextStyles.titleLarge,
                ),
                const Gap(20),
                Text(
                  "Enable notifications so you won’t miss anything \n important",
                  textAlign: TextAlign.center,
                  style: WayaTextStyles.descriptionStyle,
                ),
                const Gap(20),
                ElevatedButton(
                  onPressed: () {
                   WayaNav.toNamed('/account-setup-success');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WayaColors.customPrimary,
                  ),
                  child: Text("Turn on Notification"),
                ),
                const Gap(20),
                Align(
                    child: GestureDetector(
                  onTap: () {
                    WayaNav.toNamed('/account-setup-success');
                  },
                  child: Text(
                    "Skip for now",
                    style: TextStyle().wayaCopyWith(
                        color: WayaColors.customPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                )),
                const Gap(20),
              ]),
          const Gap(20)
        ],
      ),
    ));
  }
}

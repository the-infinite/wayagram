import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/account_creation/view/successful_setup.dart';

class SetNotification extends ConsumerWidget {
  const SetNotification({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final wayaTheme = Theme.of(context);
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
                WayaButton(
                  callback: () {
                   WayaNav.toNamed('/account-setup-success');
                  },
                 
              text:"Turn on Notification",
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
                        color: wayaTheme.colorScheme.customPrimary,
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

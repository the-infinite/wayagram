import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';

class SetNotification extends ConsumerWidget {
  final Function goToNextTab;
  const SetNotification({super.key, required this.goToNextTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
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
                  goToNextTab();
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
                  goToNextTab();
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
    );
  }
}

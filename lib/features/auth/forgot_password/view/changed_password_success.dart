import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/theme.dart';

class ChangedPasswordSuccess extends ConsumerWidget {
  const ChangedPasswordSuccess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Scaffold(
        body: Padding(
      padding: WayaEdgeInsetsExtension.fromPercentage(
          lefthorizontalPercentage: 24,
          righthorizontalPercentage: 24,
          topverticalPercentage: 12,
          bottomverticalPercentage: 0,
          context: context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/auth/forgot-password-lock.png"),
            const Gap(30),
            Text(
              "You are all set",
              textAlign: TextAlign.center,
              style: WayaTextStyles.titleLarge,
            ),
            const Gap(15),
            Text(
              "Your password has been updated. You can  \n now log in with your new password.",
              textAlign: TextAlign.center,
              style: WayaTextStyles.descriptionStyle,
            ),
            const Gap(20),
            WayaButton(
              callback: () {},
            
              text:"Take Me to Login",
            ),
          ],
        ),
      ),
    ));
  }
}

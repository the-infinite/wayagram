import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class ChangedPasswordSuccess extends ConsumerWidget {
  static const route = '/changed-password-success';
  const ChangedPasswordSuccess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return WayaScaffold(
      removeAppBar: true,
      body: Center(
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
              callback: () {
                WayaNav.toNamed('/login-cover-page');
              },
              text: "Take Me to Login",
            ),
          ],
        ),
      ),
    );
  }
}

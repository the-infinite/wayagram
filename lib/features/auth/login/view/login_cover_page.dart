import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class LoginCoverPage extends ConsumerWidget {
  const LoginCoverPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      removeAppBar: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(Get.height * 0.2),
            WayaAssests.images.wayalogoUnlabelled.image(scale: 2),
            Gap(10),
            Text(
              "Connect.Trade.Share\nAll in One Place",
              style: wayaTheme.textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            Gap(10),
            Text(
              "Welcome to Social Marketplace",
              style: wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                color: wayaTheme.colorScheme.greyColor600,
              ),
            ),
            Gap(Get.height * 0.22),
            WayaButton(
              color: wayaTheme.colorScheme.secondaryColor,
              callback: () {},
              leadingIcon: SvgPicture.asset('assets/icons/google.svg'),
              text: "Continue with Google",
              textColor: wayaTheme.colorScheme.black,
            ),
            Gap(10),
            WayaButton(
              color: wayaTheme.colorScheme.black,
              callback: () {},
              leadingIcon: SvgPicture.asset('assets/icons/apple.svg'),
              text: "Continue with Google",
              textColor: wayaTheme.colorScheme.onPrimary,
            ),
            Gap(10),
            WayaButton(
              color: wayaTheme.colorScheme.primary500,
              callback: () {
                WayaNav.toNamed("/login");
              },
              text: "Continue with Email Address",
              textColor: wayaTheme.colorScheme.onPrimary,
            ),
            Gap(20),
            WayaRichText(
              title1: 'Don\'t have an account? ',
              title2: 'Create an account',
              onTap2: () {
                WayaNav.toNamed("/account-creation");
              },
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class WelcomeBackPage extends ConsumerStatefulWidget {
  const WelcomeBackPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WelcomeBackPageState();
}

class _WelcomeBackPageState extends ConsumerState<WelcomeBackPage> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      removeAppBar: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome Back Maleek",
              style: wayaTheme.textTheme.headlineLarge,
            ),
            Gap(20),
            SizedBox(
              width: 303.w,
              child: Text(
                "Enter your login details to access your account",
                style: wayaTheme.textTheme.bodyMedium
                    ?.wayaCopyWith(fontSize: 15, color: wayaTheme.colorScheme.greyColor600),
                textAlign: TextAlign.center,
              ),
            ),
            Gap(30),
            WayaDp(),
            Gap(10),
            Text('Maleek Rufai', style: wayaTheme.textTheme.bodyMedium),
            Gap(10),
            Text('Remove Account',
                style: wayaTheme.textTheme.hintStyleBold
                    .wayaCopyWith(fontWeight: FontWeight.w500, color: wayaTheme.colorScheme.primary500)),
            Gap(10),
            WayaTextFormField(
              keyboardType: TextInputType.name,
              controller: TextEditingController(),
              label: 'Password',
              isPassword: true,
              hintText: 'Enter your password',
            ),
            Gap(Get.height * 0.2),
            WayaButton(
              text: 'Login',
              callback: () {},
              color: wayaTheme.colorScheme.primary500,
              textColor: wayaTheme.colorScheme.white,
            ),
            Gap(Get.height * 0.03),
            Chip(
                label: WayaRichText(
              title1: "Don't have an account? ",
              title2: "Create new account",
              onTap2: () {
                WayaNav.toNamed("/account-creation");
              },
              style1: wayaTheme.textTheme.hintStyle.wayaCopyWith(color: wayaTheme.colorScheme.black),
            )),
          ],
        ),
      ),
    );
  }
}



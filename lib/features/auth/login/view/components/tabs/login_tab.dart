import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

import '../../../../../../core/utils/waya_navigation.dart';

class PersonalAccountView extends StatelessWidget {
  const PersonalAccountView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
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
        Gap(20),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: wayaTheme.colorScheme.greyColor200,
                thickness: 1,
              ),
            ),
            Gap(10),
            Text(
              "OR",
              style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                color: wayaTheme.colorScheme.greyColor600,
              ),
            ),
            Gap(10),
            Expanded(
              child: Divider(
                color: wayaTheme.colorScheme.greyColor200,
                thickness: 1,
              ),
            ),
          ],
        ),
        Gap(20),
        WayaTextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: TextEditingController(),
          hintText: 'Enter your email address',
          label: 'Email Address',
        ),
        Gap(10),
        WayaTextFormField(
          keyboardType: TextInputType.name,
          controller: TextEditingController(),
          hintText: 'Password',
          label: 'Enter your password',
        ),
        Gap(15),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => WayaNav.toNamed('/forgot-password'),
            child: Text('Forgot Password?',
                style: wayaTheme.textTheme.bodySemiBold
                    .wayaCopyWith(fontSize: 14, color: wayaTheme.colorScheme.customPrimary)),
          ),
        ),
        Gap(20),
        WayaButton(
          color: wayaTheme.colorScheme.primary500,
          callback: () {
            WayaNav.toNamed("/welcome-back");
          },
          text: "Login",
          textColor: wayaTheme.colorScheme.onPrimary,
        ),
        Gap(20),
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
    );
  }
}

class BusinessAccountView extends StatelessWidget {
  const BusinessAccountView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
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
        Gap(20),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: wayaTheme.colorScheme.greyColor200,
                thickness: 1,
              ),
            ),
            Gap(10),
            Text(
              "OR",
              style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                color: wayaTheme.colorScheme.greyColor600,
              ),
            ),
            Gap(10),
            Expanded(
              child: Divider(
                color: wayaTheme.colorScheme.greyColor200,
                thickness: 1,
              ),
            ),
          ],
        ),
        Gap(20),
        WayaTextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: TextEditingController(),
          hintText: 'Enter your business ID',
          label: 'Business ID',
        ),
        Gap(10),
        WayaTextFormField(
          keyboardType: TextInputType.name,
          controller: TextEditingController(),
          label: 'Password',
          hintText: 'Enter your password',
        ),
        Gap(15),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => WayaNav.toNamed('/forgot-password'),
            child: Text('Forgot Password?',
                style: wayaTheme.textTheme.bodySemiBold
                    .wayaCopyWith(fontSize: 14, color: wayaTheme.colorScheme.customPrimary)),
          ),
        ),
        Gap(20),
        WayaButton(
          color: wayaTheme.colorScheme.primary500,
          callback: () {
            WayaNav.toNamed("/welcome-back");
          },
          text: "Login",
          textColor: wayaTheme.colorScheme.onPrimary,
        ),
        Gap(20),
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
    );
  }
}

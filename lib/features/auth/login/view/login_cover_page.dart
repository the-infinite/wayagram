import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'dart:io' show Platform;

import 'package:wayagram/features/auth/login/vm/login_vm.dart';

class LoginCoverPage extends ConsumerWidget {
  static const route = '/login-cover-page';
  const LoginCoverPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(loginVmProvider.notifier);
    final wayaTheme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;

    return WayaScaffold(
      removeAppBar: true,
      isScrollable: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(height * 0.2),
          WayaAssets.images.wayalogoUnlabelled.image(
            scale: 2,
          ),
          const Gap(10),
          Text(
            "Connect.Trade.Share\nAll in One Place",
            style: wayaTheme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const Gap(10),
          Text(
            "Welcome to Social Marketplace",
            style: wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
              color: wayaTheme.colorScheme.greyColor600,
            ),
          ),
          Gap(height * 0.25),
          if (!WayaConstants.isProduction || kDebugMode) ...[
            Platform.isAndroid
                ? WayaButton(
                    color: wayaTheme.colorScheme.secondaryColor,
                    callback: () {
                      viewModel.signinWithGoogle();
                    },
                    leadingIcon: SvgPicture.asset('assets/icons/google.svg'),
                    text: "Continue with Google",
                    textColor: wayaTheme.colorScheme.black,
                  )
                : WayaButton(
                    color: wayaTheme.colorScheme.black,
                    callback: () {
                      viewModel.signinWithApple();
                    },
                    leadingIcon: SvgPicture.asset('assets/icons/apple.svg'),
                    text: "Continue with Apple",
                    textColor: wayaTheme.colorScheme.onPrimary,
                  ),
            const Gap(10),
          ],
          WayaButton(
            color: wayaTheme.colorScheme.primary500,
            callback: () {
              WayaNav.toNamed("/login");
            },
            text: "Continue with Email Address",
            textColor: wayaTheme.colorScheme.onPrimary,
          ),
          const Gap(30),
          WayaRichText(
            title1: 'Don\'t have an account? ',
            title2: 'Create an account',
            onTap2: () {
              WayaNav.toNamed("/account-creation");
            },
          )
        ],
      ),
    );
  }
}

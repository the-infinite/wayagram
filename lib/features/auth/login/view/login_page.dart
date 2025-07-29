import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/auth/login/view/components/tabs/login_tab.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const route = '/login';
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;

    return WayaScaffold(
      isScrollable: true,
      removeAppBar: true,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gap(height * 0.03),
              WayaAssets.images.wayalogoUnlabelled.image(scale: 2),
              const Gap(20),
              Text(
                "Login to your Account",
                style: wayaTheme.textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const Gap(10),
              Text("Welcome to Social Marketplace",
                  style: wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                    color: wayaTheme.colorScheme.greyColor600,
                  )),
              Gap(height * 0.02),
              const Gap(20),
              SizedBox(height: height * 0.8, child: PersonalAccountView()),
              const Gap(50),
            ],
          ),
        ),
      ),
    );
  }
}

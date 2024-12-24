import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isScrollable: true,
      removeAppBar: true,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gap(Get.height * 0.04),
              WayaAssests.images.wayalogoUnlabelled.image(scale: 2),
              Gap(20),
              Text(
                "Login to your Account",
                style: wayaTheme.textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              Gap(10),
              Text("Welcome to Social Marketplace",
                  style: wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                    color: wayaTheme.colorScheme.greyColor600,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

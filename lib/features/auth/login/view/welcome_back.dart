import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

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
            CircleAvatar(
              radius: 75,
              backgroundColor: wayaTheme.colorScheme.greyColor200,
              child: Icon(
                Icons.person,
                size: 50,
                color: wayaTheme.colorScheme.greyColor600,
              ),
            ),
            Gap(10),
            Text('Maleek Rufai', style: wayaTheme.textTheme.bodyMedium),
            Gap(10),
            Text('Remove Account',
                style: wayaTheme.textTheme.hintStyleBold.wayaCopyWith(color: wayaTheme.colorScheme.primary500)),
            WayaTextFormField(
              keyboardType: TextInputType.name,
              controller: TextEditingController(),
              label: 'Password',
              isPassword: true,
              hintText: 'Enter your password',
            ),
          ],
        ),
      ),
    );
  }
}

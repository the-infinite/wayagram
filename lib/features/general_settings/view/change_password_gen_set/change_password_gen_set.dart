import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

class ChangePasswordGenSettings extends ConsumerStatefulWidget {
  const ChangePasswordGenSettings({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChangePasswordGenSettingsState();
}

class _ChangePasswordGenSettingsState extends ConsumerState<ChangePasswordGenSettings> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      title: 'Change Password',
      body: Column(
        spacing: 20,
        children: [
          WayaTextFormField(
            controller: TextEditingController(),
            label: 'Old Password',
            suffixIconColor: wayaTheme.colorScheme.customBlack,
            hintText: 'Enter your old password',
            isPassword: true,
          ),
          WayaTextFormField(
            controller: TextEditingController(),
            label: 'New Password',
            hintText: 'Enter your new password',
            suffixIconColor: wayaTheme.colorScheme.customBlack,
            isPassword: true,
          ),
          WayaTextFormField(
            controller: TextEditingController(),
            label: 'Confirm New Password',
            suffixIconColor: wayaTheme.colorScheme.customBlack,
            hintText: 'Re-enter your new password',
            isPassword: true,
          ),
          Gap(10),
          WayaButton(
            text: 'Confirm Change',
            color: wayaTheme.colorScheme.primary500,
            callback: () {},
          ),
        ],
      ),
    );
  }
}

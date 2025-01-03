import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/general_settings/change_password_gen_set/vm/change_password_vm.dart';

class ChangePasswordGenSettings extends ConsumerStatefulWidget {
  const ChangePasswordGenSettings({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChangePasswordGenSettingsState();
}

class _ChangePasswordGenSettingsState extends ConsumerState<ChangePasswordGenSettings> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final changePasswordVm = ref.watch(changePasswordNotifierProvider);
    return WayaScaffold(
      title: 'Change Password',
      body: Form(
        key: formKey,
        child: Column(
          spacing: 20,
          children: [
            WayaTextFormField(
              controller: oldPassword,
              label: 'Old Password',
              suffixIconColor: wayaTheme.colorScheme.customBlack,
              hintText: 'Enter your old password',
              validator: (data) => WayaValidators.isValidInput(data!, message: 'Old Password is required'),
              isPassword: true,
            ),
            WayaTextFormField(
              controller: newPassword,
              label: 'New Password',
              hintText: 'Enter your new password',
              validator: (data) => WayaValidators.passwordValidator(data!),
              suffixIconColor: wayaTheme.colorScheme.customBlack,
              isPassword: true,
            ),
            WayaTextFormField(
              controller: confirmPassword,
              label: 'Confirm New Password',
              validator: (data) => WayaValidators.isValidPasswordChange(data!, newPassword.text, confirmPassword.text),
              suffixIconColor: wayaTheme.colorScheme.customBlack,
              hintText: 'Re-enter your new password',
              isPassword: true,
            ),
            Gap(10),
            WayaButton(
              text: 'Confirm Change',
              isLoading: changePasswordVm.isLoading,
              color: wayaTheme.colorScheme.primary500,
              callback: () {
                if (formKey.currentState!.validate()) {
                  changePassword();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void changePassword() async {
    await ref.read(changePasswordNotifierProvider.notifier).changePassword(
        oldPassword: oldPassword.text, newPassword: newPassword.text, confirmPassword: confirmPassword.text);
  }

  @override
  void dispose() {
    super.dispose();
  }
}

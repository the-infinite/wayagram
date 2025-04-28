import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/general_settings/change_password_gen_set/vm/change_password_vm.dart';

class ChangePasswordGenSettings extends ConsumerStatefulWidget {
  static const route = '/change-password-gen-set';
  const ChangePasswordGenSettings({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordGenSettingsState();
}

class _ChangePasswordGenSettingsState
    extends ConsumerState<ChangePasswordGenSettings> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool isOldPasswordFocused = false;
  bool isNewPasswordFocused = false;
  bool isConfirmPasswordFocused = false;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final changePasswordVm = ref.watch(changePasswordNotifierProvider);
    return WayaScaffold(
      title: 'Change Password',
      isScrollable: true,
      isLoading: changePasswordVm.isLoading,
      body: Form(
        key: formKey,
        child: Column(
          spacing: 20,
          children: [
            FormField<String>(validator: (value) {
              return WayaValidators.passwordValidator(oldPassword.text);
            }, builder: (formState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {
                        isOldPasswordFocused = hasFocus;
                      });
                    },
                    child: WayaTextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: oldPassword,
                      borderColor: formState.hasError && !isOldPasswordFocused
                          ? wayaTheme.colorScheme.error
                          : null,
                      hintText: 'Enter your old password',
                      label: 'Old Password',
                      isPassword: true,
                    ),
                  ),
                  if (formState.hasError && !isOldPasswordFocused)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        formState.errorText!,
                        style: TextStyle(
                            color: wayaTheme.colorScheme.error,
                            fontSize: 12.sp),
                      ),
                    ),
                ],
              );
            }),
            FormField<String>(validator: (value) {
              return WayaValidators.passwordValidator(newPassword.text);
            }, builder: (formState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {
                        isNewPasswordFocused = hasFocus;
                      });
                    },
                    child: WayaTextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: newPassword,
                      borderColor: formState.hasError && !isNewPasswordFocused
                          ? wayaTheme.colorScheme.error
                          : null,
                      hintText: 'Enter your new password',
                      label: 'New Password',
                      isPassword: true,
                    ),
                  ),
                  if (formState.hasError && !isNewPasswordFocused)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        formState.errorText!,
                        style: TextStyle(
                            color: wayaTheme.colorScheme.error,
                            fontSize: 12.sp),
                      ),
                    ),
                ],
              );
            }),
            FormField<String>(validator: (value) {
              return WayaValidators.isValidPasswordChange(
                  confirmPassword.text, newPassword.text, confirmPassword.text);
            }, builder: (formState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {
                        isConfirmPasswordFocused = hasFocus;
                      });
                    },
                    child: WayaTextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: confirmPassword,
                      borderColor:
                          formState.hasError && !isConfirmPasswordFocused
                              ? wayaTheme.colorScheme.error
                              : null,
                      hintText: 'Re-enter your new password',
                      label: 'Confirm Password',
                      isPassword: true,
                    ),
                  ),
                  if (formState.hasError && !isConfirmPasswordFocused)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        formState.errorText!,
                        style: TextStyle(
                            color: wayaTheme.colorScheme.error,
                            fontSize: 12.sp),
                      ),
                    ),
                ],
              );
            }),
            Gap(10),
            WayaButton(
              text: 'Confirm Change',
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
        oldPassword: oldPassword.text,
        newPassword: newPassword.text,
        confirmPassword: confirmPassword.text);
  }

  @override
  void dispose() {
    super.dispose();
  }
}

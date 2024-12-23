import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/components/waya_text_form_field.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/forgot_password/vm/create_new_password_vm.dart';

class CreateNewPassword extends ConsumerStatefulWidget {
  const CreateNewPassword({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNewPasswordState();
}

class _CreateNewPasswordState extends ConsumerState<CreateNewPassword> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModelState = ref.watch(createNewPasswordProvider);
    final viewModel = ref.watch(createNewPasswordProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Create New Password", style: WayaTextStyles.titleLarge),
        const Gap(5),
        Text("Create new password and try not forget \n this time",
            style: WayaTextStyles.hintStyle),
        const Gap(30),
        Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(20),
                FormField<String>(validator: (value) {
                  if (viewModelState.password.text.isEmpty) {
                    return 'Password is required';
                  }
                  if (viewModelState.password.text.length < 8) {
                    return 'Password must be at least 8';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: viewModelState.password,
                        borderColor: formState.hasError &&
                                viewModelState.password.text.isEmpty
                            ? WayaColors.error
                            : null,
                        hintText: 'Enter Your Password',
                        label: 'Password',
                        obscureText: !viewModelState.isPasswordVisible,
                        suffixIcon: IconButton(
                          onPressed: () {
                            viewModel.togglePasswordVisibility();
                          },
                          icon: Icon(viewModelState.isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          color: WayaColors.greyColor300,
                        ),
                      ),
                      if (formState.hasError &&
                          viewModelState.password.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: const TextStyle(
                                color: WayaColors.error, fontSize: 12),
                          ),
                        ),
                    ],
                  );
                }),
                const Gap(5),
                FormField<String>(validator: (value) {
                  if (viewModelState.confirmPassword.text.isEmpty) {
                    return 'Password is required';
                  }
                  if (viewModelState.confirmPassword.text.length < 8) {
                    return 'Password must be at least 8';
                  }
                  if (viewModelState.password.text !=
                      viewModelState.confirmPassword.text) {
                    return 'Password does not match';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: viewModelState.confirmPassword,
                        borderColor: formState.hasError &&
                                viewModelState.confirmPassword.text.isEmpty
                            ? WayaColors.error
                            : null,
                        hintText: 'Enter your Password',
                        label: 'Confirm Password',
                        obscureText: !viewModelState.isConfirmPasswordVisible,
                        suffixIcon: IconButton(
                          onPressed: () {
                            viewModel.toggleConfirmPasswordVisibility();
                          },
                          icon: Icon(viewModelState.isConfirmPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          color: WayaColors.greyColor300,
                        ),
                      ),
                      if (formState.hasError &&
                          viewModelState.confirmPassword.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: const TextStyle(
                                color: WayaColors.error, fontSize: 12),
                          ),
                        ),
                    ],
                  );
                }),
                const Gap(50),
                WayaButton(
                    callback: _formKey.currentState?.validate() == true
                        ? () {
                            WayaNav.toNamed('/changed-password-success');
                          }
                        : null,
                   text:"Save New Password")
              ],
            ))
      ],
    );
  }
}

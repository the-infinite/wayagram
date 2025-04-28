import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/auth/account_creation/vm/verify_account_vm.dart';
import 'package:wayagram/features/auth/forgot_password/vm/create_new_password_vm.dart';
// import 'package:wayagram/features/auth/forgot_password/vm/credential_input_vm.dart';

class CreateNewPassword extends ConsumerStatefulWidget {
  final String email;
  const CreateNewPassword({super.key, required this.email});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNewPasswordState();
}

class _CreateNewPasswordState extends ConsumerState<CreateNewPassword> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createNewPasswordProvider);
    //final credential = ref.watch(credentialInputProvider);
    final verify = ref.watch(verifyAccountProvider);
    final wayaTheme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Create New Password", style: WayaTextStyles.titleLarge),
        const Gap(5),
        Text("Create new password and try not forget this time",
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
                  if (viewModel.password.text.isEmpty) {
                    return 'Password is required';
                  }
                  if (viewModel.password.text.length < 8) {
                    return 'Password must be at least 8';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: viewModel.password,
                        borderColor: formState.hasError &&
                                viewModel.password.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        hintText: 'Enter Your Password',
                        label: 'Password',
                        obscureText: !viewModel.isPasswordVisible,
                        suffixIcon: IconButton(
                          onPressed: () {
                            viewModel.togglePasswordVisibility();
                          },
                          icon: Icon(viewModel.isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          color: wayaTheme.colorScheme.greyColor300,
                        ),
                      ),
                      if (formState.hasError && viewModel.password.text.isEmpty)
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
                const Gap(5),
                FormField<String>(validator: (value) {
                  if (viewModel.confirmPassword.text.isEmpty) {
                    return 'Password is required';
                  }
                  if (viewModel.confirmPassword.text.length < 8) {
                    return 'Password must be at least 8';
                  }
                  if (viewModel.password.text !=
                      viewModel.confirmPassword.text) {
                    return 'Password does not match';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: viewModel.confirmPassword,
                        borderColor: formState.hasError &&
                                viewModel.confirmPassword.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        hintText: 'Enter your Password',
                        label: 'Confirm Password',
                        obscureText: !viewModel.isConfirmPasswordVisible,
                        suffixIcon: IconButton(
                          onPressed: () {
                            viewModel.toggleConfirmPasswordVisibility();
                          },
                          icon: Icon(viewModel.isConfirmPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          color: wayaTheme.colorScheme.greyColor300,
                        ),
                      ),
                      if (formState.hasError &&
                          viewModel.confirmPassword.text.isEmpty)
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
                const Gap(50),
                WayaButton(
                  callback: !viewModel.isLoading
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            viewModel.onSubmit(widget.email, verify.inputCode);
                          }
                        }
                      : null,
                  centerWidget: LoadingState(
                      loading: viewModel.isLoading, text: "Save New Password"),
                )
              ],
            ))
      ],
    );
  }
}

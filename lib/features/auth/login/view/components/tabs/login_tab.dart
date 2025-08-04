import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/auth/login/vm/login_vm.dart';
import 'dart:io' show Platform;

class PersonalAccountView extends ConsumerStatefulWidget {
  const PersonalAccountView({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PersonalAccountViewState();
}

class _PersonalAccountViewState extends ConsumerState<PersonalAccountView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(loginVmProvider);
    final notifier = ref.read(loginVmProvider.notifier);
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
        if (kDebugMode) ...[
          Platform.isAndroid
              ? WayaButton(
                  color: wayaTheme.colorScheme.secondaryColor,
                  callback: notifier.signinWithGoogle,
                  leadingIcon: SvgPicture.asset('assets/icons/google.svg'),
                  text: "Continue with Google",
                  textColor: wayaTheme.colorScheme.black,
                )
              : WayaButton(
                  color: wayaTheme.colorScheme.black,
                  callback: notifier.signinWithApple,
                  leadingIcon: SvgPicture.asset('assets/icons/apple.svg'),
                  text: "Continue with Apple",
                  textColor: wayaTheme.colorScheme.onPrimary,
                ),
          const Gap(25),
          WayaTextStrip("OR"),
          const Gap(25),
        ],
        Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormField<String>(validator: (value) {
                  if (emailController.text.isEmpty) {
                    return 'Email is required';
                  }
                  final RegExp regexp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!regexp.hasMatch(emailController.text)) {
                    return 'Invalid email address';
                  }
                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        hintText: 'example@gmail.com',
                        borderColor:
                            formState.hasError && emailController.text.isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                        label: 'Email Address',
                      ),
                      if (formState.hasError)
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
                const Gap(10),
                FormField<String>(validator: (value) {
                  return WayaValidators.passwordValidator(
                      passwordController.text);
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Focus(
                        onFocusChange: (hasFocus) {
                          ref
                              .read(loginVmProvider.notifier)
                              .setPasswordFocus(hasFocus);
                        },
                        child: WayaTextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController,
                          borderColor: formState.hasError &&
                                  passwordController.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          hintText: 'Enter Your Password',
                          label: 'Password',
                          obscureText: !viewModel.isPasswordVisible,
                          suffixIcon: IconButton(
                            onPressed: () {
                              ref
                                  .read(loginVmProvider.notifier)
                                  .togglePasswordVisibility();
                            },
                            autofocus: false,
                            icon: Icon(viewModel.isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            color: wayaTheme.colorScheme.greyColor300,
                          ),
                          helperText:
                              "Password must be 8 or more character and contain at least 1 number and 1 special character",
                        ),
                      ),
                      if (formState.hasError && !viewModel.isPasswordFocused)
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
                const Gap(15),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => WayaNav.toNamed('/forgot-password'),
                    child: Text('Forgot Password?',
                        style: wayaTheme.textTheme.bodySemiBold.wayaCopyWith(
                            fontSize: 14.sp,
                            color: wayaTheme.colorScheme.customPrimary)),
                  ),
                ),
                const Gap(30),
                WayaButton(
                  color: wayaTheme.colorScheme.primary500,
                  callback: !viewModel.isLoading
                      ? () async {
                          if (_formKey.currentState!.validate()) {
                            ref.read(loginVmProvider.notifier).onSubmit(
                                ref: ref,
                                email: emailController.text,
                                password: passwordController.text);
                          }
                        }
                      : null,
                  centerWidget:
                      LoadingState(loading: viewModel.isLoading, text: "Login"),
                  textColor: wayaTheme.colorScheme.onPrimary,
                ),
              ],
            )),
        const Gap(25),
        InkWell(
          onTap: () {
            WayaNav.toNamed("/account-creation");
          },
          child: Chip(
              label: WayaRichText(
            title1: "Don't have an account? ",
            title2: "Create new account",
            style1: wayaTheme.textTheme.hintStyle
                .wayaCopyWith(color: wayaTheme.colorScheme.black),
          )),
        ),
      ],
    );
  }
}

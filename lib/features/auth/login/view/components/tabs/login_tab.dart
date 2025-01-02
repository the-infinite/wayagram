import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_validators.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/auth/login/vm/login_vm.dart';

import '../../../../../../core/utils/waya_navigation.dart';

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
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(loginVmProvider);
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
        WayaButton(
          color: wayaTheme.colorScheme.secondaryColor,
          callback: () {},
          leadingIcon: SvgPicture.asset('assets/icons/google.svg'),
          text: "Continue with Google",
          textColor: wayaTheme.colorScheme.black,
        ),
        Gap(10),
        WayaButton(
          color: wayaTheme.colorScheme.black,
          callback: () {},
          leadingIcon: SvgPicture.asset('assets/icons/apple.svg'),
          text: "Continue with Google",
          textColor: wayaTheme.colorScheme.onPrimary,
        ),
        Gap(25),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: wayaTheme.colorScheme.greyColor200,
                thickness: 1,
              ),
            ),
            Gap(10),
            Text(
              "OR",
              style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                color: wayaTheme.colorScheme.greyColor600,
              ),
            ),
            Gap(10),
            Expanded(
              child: Divider(
                color: wayaTheme.colorScheme.greyColor200,
                thickness: 1,
              ),
            ),
          ],
        ),
        Gap(25),
        Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormField<String>(validator: (value) {
                  if (viewModel.email.text.isEmpty) {
                    return 'Email is required';
                  }
                  final RegExp regexp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!regexp.hasMatch(viewModel.email.text)) {
                    return 'Invalid email address';
                  }
                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: viewModel.email,
                        hintText: 'example@gmail.com',
                        borderColor:
                            formState.hasError && viewModel.email.text.isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                        label: 'Email Address',
                      ),
                      if (formState.hasError && viewModel.email.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(
                                color: wayaTheme.colorScheme.error,
                                fontSize: 12),
                          ),
                        ),
                    ],
                  );
                }),
                const Gap(10),
                FormField<String>(validator: (value) {
                  return WayaValidators.passwordValidator(
                      viewModel.password.text);
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Focus(
                        onFocusChange: (hasFocus) {
                          viewModel.setPasswordFocus(hasFocus);
                        },
                        child: WayaTextFormField(
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
                            autofocus: false,
                            icon: Icon(viewModel.isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            color: wayaTheme.colorScheme.greyColor300,
                          ),
                        ),
                      ),
                      if (formState.hasError && !viewModel.isPasswordFocused)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(
                                color: wayaTheme.colorScheme.error,
                                fontSize: 12),
                          ),
                        ),
                    ],
                  );
                }),
                Gap(15),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => WayaNav.toNamed('/forgot-password'),
                    child: Text('Forgot Password?',
                        style: wayaTheme.textTheme.bodySemiBold.wayaCopyWith(
                            fontSize: 14,
                            color: wayaTheme.colorScheme.customPrimary)),
                  ),
                ),
                Gap(30),
                WayaButton(
                  color: wayaTheme.colorScheme.primary500,
                  callback: !viewModel.isLoading
                      ? () async {
                          if (_formKey.currentState!.validate()) {
                            viewModel.onSubmit();
                          }
                        }
                      : null,
                  centerWidget:
                      LoadingState(loading: viewModel.isLoading, text: "Login"),
                  textColor: wayaTheme.colorScheme.onPrimary,
                ),
              ],
            )),
        Gap(25),
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

class BusinessAccountView extends StatelessWidget {
  const BusinessAccountView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
        WayaButton(
          color: wayaTheme.colorScheme.secondaryColor,
          callback: () {},
          leadingIcon: SvgPicture.asset('assets/icons/google.svg'),
          text: "Continue with Google",
          textColor: wayaTheme.colorScheme.black,
        ),
        Gap(10),
        WayaButton(
          color: wayaTheme.colorScheme.black,
          callback: () {},
          leadingIcon: SvgPicture.asset('assets/icons/apple.svg'),
          text: "Continue with Google",
          textColor: wayaTheme.colorScheme.onPrimary,
        ),
        Gap(25),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: wayaTheme.colorScheme.greyColor200,
                thickness: 1,
              ),
            ),
            Gap(10),
            Text(
              "OR",
              style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                color: wayaTheme.colorScheme.greyColor600,
              ),
            ),
            Gap(15),
            Expanded(
              child: Divider(
                color: wayaTheme.colorScheme.greyColor200,
                thickness: 1,
              ),
            ),
          ],
        ),
        Gap(25),
        WayaTextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: TextEditingController(),
          hintText: 'Enter your business ID',
          label: 'Business ID',
        ),
        Gap(10),
        WayaTextFormField(
          keyboardType: TextInputType.name,
          controller: TextEditingController(),
          label: 'Password',
          isPassword: true,
          hintText: 'Enter your password',
        ),
        Gap(15),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => WayaNav.toNamed('/forgot-password'),
            child: Text('Forgot Password?',
                style: wayaTheme.textTheme.bodySemiBold.wayaCopyWith(
                    fontSize: 14, color: wayaTheme.colorScheme.customPrimary)),
          ),
        ),
        Gap(25),
        WayaButton(
          color: wayaTheme.colorScheme.primary500,
          callback: () {
            WayaNav.toNamed("/welcome-back");
          },
          text: "Login",
          textColor: wayaTheme.colorScheme.onPrimary,
        ),
        Gap(30),
        Chip(
            label: WayaRichText(
          title1: "Don't have an account? ",
          title2: "Create new account",
          onTap2: () {
            WayaNav.toNamed("/account-creation");
          },
          style1: wayaTheme.textTheme.hintStyle
              .wayaCopyWith(color: wayaTheme.colorScheme.black),
        )),
      ],
    );
  }
}

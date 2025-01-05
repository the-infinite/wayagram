import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/login/vm/login_vm.dart';
import 'package:wayagram/features/bottom_view/bottom_view.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';

class WelcomeBackPage extends ConsumerStatefulWidget {
  const WelcomeBackPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WelcomeBackPageState();
}

class _WelcomeBackPageState extends ConsumerState<WelcomeBackPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    UserAccountData user(WidgetRef ref) {
      final userData = ref.read(userDataProvider);
      return userData.getUser();
    }

    final viewModel = ref.watch(loginVmProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      removeAppBar: true,
      isLoading: viewModel.isLoading,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome Back ${user(ref).firstName}",
              style: wayaTheme.textTheme.headlineLarge,
            ),
            Gap(20),
            SizedBox(
              width: 303.w,
              child: Text(
                "Enter your login details to access your account",
                style: wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                    fontSize: 15, color: wayaTheme.colorScheme.greyColor600),
                textAlign: TextAlign.center,
              ),
            ),
            Gap(30),
            WayaDp(),
            Gap(10),
            Text("${user(ref).firstName} ${user(ref).lastName}",
                style: wayaTheme.textTheme.bodyMedium),
            Gap(10),
            // Text('Remove Account',
            //     style: wayaTheme.textTheme.hintStyleBold.wayaCopyWith(
            //         fontWeight: FontWeight.w500,
            //         color: wayaTheme.colorScheme.primary500)),
            Gap(10),
            Form(
              key: _formKey,
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormField<String>(validator: (value) {
                  return WayaValidators.passwordValidator(
                      viewModel.passwordController.text);
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
                          controller: viewModel.passwordController,
                          borderColor: formState.hasError &&
                                  viewModel.passwordController.text.isEmpty
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
                Gap(Get.height * 0.2),
                WayaButton(
                  text: 'Login',
                  callback: () {
                
                    if (_formKey.currentState!.validate()) {
                      ref
                          .read(loginVmProvider.notifier)
                          .onSubmit(user(ref).email);
                    }
                  },
                  color: wayaTheme.colorScheme.primary500,
                  textColor: wayaTheme.colorScheme.white,
                ),
              ],
            )),

            Gap(Get.height * 0.03),
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
        ),
      ),
    );
  }
}

final userDataProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

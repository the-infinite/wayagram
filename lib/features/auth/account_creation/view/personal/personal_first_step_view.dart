import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/components/waya_text_form_field.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/auth/account_creation/vm/personal_first_step_vm.dart';

class PersonalFirstStepView extends ConsumerStatefulWidget {
  final Function goToNextTab;
  const PersonalFirstStepView({super.key, required this.goToNextTab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PersonalFirstStepViewState();
}

class _PersonalFirstStepViewState extends ConsumerState<PersonalFirstStepView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(personalFirstStepProvider);
     final wayaTheme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tell us About You", style: WayaTextStyles.titleLarge),
          const Gap(5),
          Text(
              "Fill in your required information as in your official \n documents and BVN",
              style: WayaTextStyles.hintStyle),
          const Gap(20),
          Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FormField<String>(validator: (value) {
                          if (viewModel.firstName.text.isEmpty) {
                            return 'First Name is required';
                          }

                          return null;
                        }, builder: (formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WayaTextFormField(
                                keyboardType: TextInputType.name,
                                controller: viewModel.firstName,
                                hintText: 'Enter Your First Name',
                                borderColor: formState.hasError &&
                                        viewModel.firstName.text.isEmpty
                                    ? wayaTheme.colorScheme.error
                                    : null,
                                label: 'First Name',
                              ),
                              if (formState.hasError &&
                                  viewModel.firstName.text.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    formState.errorText!,
                                    style:  TextStyle(
                                        color: wayaTheme.colorScheme.error, fontSize: 12),
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
                      const Gap(8),
                      Expanded(
                        child: FormField<String>(validator: (value) {
                          if (viewModel.lastName.text.isEmpty) {
                            return 'Last Name is required';
                          }

                          return null;
                        }, builder: (formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WayaTextFormField(
                                keyboardType: TextInputType.name,
                                controller: viewModel.lastName,
                                hintText: 'Enter Your Last Name',
                                borderColor: formState.hasError &&
                                        viewModel.lastName.text.isEmpty
                                    ? wayaTheme.colorScheme.error
                                    : null,
                                label: 'Last Name',
                              ),
                              if (formState.hasError &&
                                  viewModel.lastName.text.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    formState.errorText!,
                                    style:  TextStyle(
                                        color: wayaTheme.colorScheme.error, fontSize: 12),
                                  ),
                                ),
                            ],
                          );
                        }),
                      )
                    ],
                  ),
                  const Gap(5),
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
                              style:  TextStyle(
                                  color: wayaTheme.colorScheme.error, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  }),
                  const Gap(5),
                  FormField<String>(validator: (value) {
                    if (viewModel.phone.text.isEmpty) {
                      return 'Phone is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phone Number",
                          style: WayaTextStyles.labelMedium,
                        ),
                        const Gap(3),
                        Row(
                          children: [
                            //   Expanded(
                            Container(
                              height: 55,
                              width: 90,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: formState.hasError &&
                                              viewModel.phone.text.isEmpty
                                          ? wayaTheme.colorScheme.error
                                          : wayaTheme.colorScheme.greyColor300,
                                      width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/onboarding/flag.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  const Gap(3),
                                  Text(
                                    "+234",
                                    style: WayaTextStyles.hintStyle,
                                  )
                                ],
                              ),
                            ),
                            const Gap(4),
                            Expanded(
                              child: WayaTextFormField(
                                keyboardType: TextInputType.phone,
                                controller: viewModel.phone,
                                hintText: '000-000-000',
                                borderColor: formState.hasError &&
                                        viewModel.phone.text.isEmpty
                                    ? wayaTheme.colorScheme.error
                                    : null,
                              ),
                            )
                          ],
                        ),
                        if (formState.hasError && viewModel.phone.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style:  TextStyle(
                                  color: wayaTheme.colorScheme.error, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  }),
                  const Gap(5),
                  FormField<String>(validator: (value) {
                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: viewModel.referralCode,
                          hintText: 'Enter Referral Code',
                          label: 'Referral Code (Optional)',
                        ),
                      ],
                    );
                  }),
                  const Gap(5),
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
                            autofocus: false,
                            icon: Icon(viewModel.isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            color: wayaTheme.colorScheme.greyColor300,
                          ),
                        ),
                        if (formState.hasError &&
                            viewModel.password.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style:  TextStyle(
                                  color: wayaTheme.colorScheme.error, fontSize: 12),
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
                            autofocus: false,
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
                              style:  TextStyle(
                                  color: wayaTheme.colorScheme.error, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  }),
                  const Gap(5),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                          value: viewModel.isAgreeToTerm,
                          onChanged: (value) {
                            viewModel.toggleTerm(value);
                          }),
                      // const Gap(3),
                      Expanded(
                          child: RichText(
                              textAlign: TextAlign.start,
                              text: const TextSpan(children: [
                                TextSpan(
                                    text: "I agree to the ",
                                    style: WayaTextStyles.bodySmall),
                                TextSpan(
                                    text: "Terms and conditions ",
                                    style: WayaTextStyles.smallactiveLinkStyle),
                                TextSpan(
                                    text: "and ",
                                    style: WayaTextStyles.bodySmall),
                                TextSpan(
                                    text: "Privacy policy",
                                    style: WayaTextStyles.smallactiveLinkStyle)
                              ])))
                    ],
                  ),
                  const Gap(20),
                  WayaButton(
                      callback: viewModel.isButtonEnabled
                          ? () {
                              // _formKey.currentState?.validate() == true
                              //  print("i am here");
                              widget.goToNextTab();
                            }
                          : null,
                      text: "Continue")
                ],
              ))
        ],
      ),
    );
  }
}

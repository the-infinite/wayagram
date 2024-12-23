import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/components/waya_text_form_field.dart';
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
    final viewModel = ref.watch(personalFirstStepProvider.notifier);
    final viewModelState = ref.watch(personalFirstStepProvider);
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
                          if (viewModelState.firstName.text.isEmpty) {
                            return 'First Name is required';
                          }

                          return null;
                        }, builder: (formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WayaTextFormField(
                                keyboardType: TextInputType.name,
                                controller: viewModelState.firstName,
                                hintText: 'Enter Your First Name',
                                borderColor: formState.hasError &&
                                        viewModelState.firstName.text.isEmpty
                                    ? WayaColors.error
                                    : null,
                                label: 'First Name',
                              ),
                              if (formState.hasError &&
                                  viewModelState.firstName.text.isEmpty)
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
                      ),
                      const Gap(8),
                      Expanded(
                        child: FormField<String>(validator: (value) {
                          if (viewModelState.lastName.text.isEmpty) {
                            return 'Last Name is required';
                          }

                          return null;
                        }, builder: (formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WayaTextFormField(
                                keyboardType: TextInputType.name,
                                controller: viewModelState.lastName,
                                hintText: 'Enter Your Last Name',
                                borderColor: formState.hasError &&
                                        viewModelState.lastName.text.isEmpty
                                    ? WayaColors.error
                                    : null,
                                label: 'Last Name',
                              ),
                              if (formState.hasError &&
                                  viewModelState.lastName.text.isEmpty)
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
                      )
                    ],
                  ),
                  const Gap(5),
                  FormField<String>(validator: (value) {
                    if (viewModelState.email.text.isEmpty) {
                      return 'Email is required';
                    }
                    final RegExp regexp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!regexp.hasMatch(viewModelState.email.text)) {
                      return 'Invalid email address';
                    }
                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: viewModelState.email,
                          hintText: 'example@gmail.com',
                          borderColor: formState.hasError &&
                                  viewModelState.email.text.isEmpty
                              ? WayaColors.error
                              : null,
                          label: 'Email Address',
                        ),
                        if (formState.hasError &&
                            viewModelState.email.text.isEmpty)
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
                    if (viewModelState.phone.text.isEmpty) {
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
                                      color:formState.hasError &&
                                        viewModelState.email.text.isEmpty
                                    ? WayaColors.error: WayaColors.greyColor300, width: 1),
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
                                controller: viewModelState.phone,
                                hintText: '000-000-000',
                                borderColor: formState.hasError &&
                                        viewModelState.email.text.isEmpty
                                    ? WayaColors.error
                                    : null,
                              ),
                            )
                          ],
                        ),
                        if (formState.hasError &&
                            viewModelState.email.text.isEmpty)
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
                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: viewModelState.referralCode,
                          hintText: 'Enter Referral Code',
                          label: 'Referral Code (Optional)',
                        ),
                      ],
                    );
                  }),
                  const Gap(5),
                  // FormField<String>(validator: (value) {
                  //   if (viewModelState.password.text.isEmpty) {
                  //     return 'Password is required';
                  //   }
                  //   if (viewModelState.password.text.length < 8) {
                  //     return 'Password must be at least 8';
                  //   }

                  //   return null;
                  // }, builder: (formState) {
                  //   return Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       WayaTextFormField(
                  //         keyboardType: TextInputType.visiblePassword,
                  //         controller: viewModelState.password,
                  //         borderColor: formState.hasError &&
                  //                 viewModelState.password.text.isEmpty
                  //             ? WayaColors.error
                  //             : null,
                  //         hintText: 'Enter Your Password',
                  //         label: 'Password',
                  //         obscureText: !viewModelState.isPasswordVisible,
                  //         suffixIcon: IconButton(
                  //           onPressed: () {
                  //             viewModel.togglePasswordVisibility();
                  //           },
                  //           autofocus: false,
                  //           icon: Icon(viewModelState.isPasswordVisible
                  //               ? Icons.visibility_outlined
                  //               : Icons.visibility_off_outlined),
                  //           color: WayaColors.greyColor300,
                  //         ),
                  //       ),
                  //       if (formState.hasError &&
                  //           viewModelState.password.text.isEmpty)
                  //         Padding(
                  //           padding: const EdgeInsets.only(top: 5),
                  //           child: Text(
                  //             formState.errorText!,
                  //             style: const TextStyle(
                  //                 color: WayaColors.error, fontSize: 12),
                  //           ),
                  //         ),
                  //     ],
                  //   );
                  // }),
                  // const Gap(5),
                  // FormField<String>(validator: (value) {
                  //   if (viewModelState.confirmPassword.text.isEmpty) {
                  //     return 'Password is required';
                  //   }
                  //   if (viewModelState.confirmPassword.text.length < 8) {
                  //     return 'Password must be at least 8';
                  //   }
                  //   if (viewModelState.password.text !=
                  //       viewModelState.confirmPassword.text) {
                  //     return 'Password does not match';
                  //   }

                  //   return null;
                  // }, builder: (formState) {
                  //   return Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       WayaTextFormField(
                  //         keyboardType: TextInputType.visiblePassword,
                  //         controller: viewModelState.confirmPassword,
                  //         borderColor: formState.hasError &&
                  //                 viewModelState.confirmPassword.text.isEmpty
                  //             ? WayaColors.error
                  //             : null,
                  //         hintText: 'Enter your Password',
                  //         label: 'Confirm Password',
                  //         obscureText: !viewModelState.isConfirmPasswordVisible,
                  //         suffixIcon: IconButton(
                  //           onPressed: () {
                  //             viewModel.toggleConfirmPasswordVisibility();
                  //           },
                  //           autofocus: false,
                  //           icon: Icon(viewModelState.isConfirmPasswordVisible
                  //               ? Icons.visibility_outlined
                  //               : Icons.visibility_off_outlined),
                  //           color: WayaColors.greyColor300,
                  //         ),
                  //       ),
                  //       if (formState.hasError &&
                  //           viewModelState.confirmPassword.text.isEmpty)
                  //         Padding(
                  //           padding: const EdgeInsets.only(top: 5),
                  //           child: Text(
                  //             formState.errorText!,
                  //             style: const TextStyle(
                  //                 color: WayaColors.error, fontSize: 12),
                  //           ),
                  //         ),
                  //     ],
                  //   );
                  // }),
                  const Gap(5),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                          value: true,
                          onChanged: (value) {
                            
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
                      callback: _formKey.currentState?.validate() == true  ?() {
                       
                        //  print("i am here");
                           widget.goToNextTab();
                        
                      }: null,
                      text:"Continue")
                ],
              ))
        ],
      ),
    );
  }
}

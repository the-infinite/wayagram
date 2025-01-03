import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/utils/waya_validators.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
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
    final businessTypes = ref.watch(businessTypesProvider);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (viewModel.localDataSource.getUserType().type == "BUSINESS")
            Text("Tell us About Your Business", style: WayaTextStyles.titleLarge)
          else
            Text("Tell us About You", style: WayaTextStyles.titleLarge),
          const Gap(10),
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
                                    style: TextStyle(
                                        color: wayaTheme.colorScheme.error,
                                        fontSize: 12),
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
                      const Gap(10),
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
                                    style: TextStyle(
                                        color: wayaTheme.colorScheme.error,
                                        fontSize: 12),
                                  ),
                                ),
                            ],
                          );
                        }),
                      )
                    ],
                  ),
                  const Gap(10),
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
                  //*    business section*/ */
                  Visibility(
                      visible:
                          viewModel.localDataSource.getUserType().type == "BUSINESS",
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormField<String>(validator: (value) {
                            if (viewModel.businessName.text.isEmpty) {
                              return 'Business Name is required';
                            }

                            return null;
                          }, builder: (formState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                WayaTextFormField(
                                  keyboardType: TextInputType.name,
                                  controller: viewModel.businessName,
                                  hintText: 'Enter Your Business Name',
                                  borderColor: formState.hasError &&
                                          viewModel.businessName.text.isEmpty
                                      ? wayaTheme.colorScheme.error
                                      : null,
                                  label: 'Business Name',
                                ),
                                if (formState.hasError &&
                                    viewModel.businessName.text.isEmpty)
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
                            if (viewModel.businessAddress.text.isEmpty) {
                              return 'Business Address is required';
                            }

                            return null;
                          }, builder: (formState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                WayaTextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: viewModel.businessAddress,
                                  hintText: 'Enter Your Business Address',
                                  borderColor: formState.hasError &&
                                          viewModel.businessAddress.text.isEmpty
                                      ? wayaTheme.colorScheme.error
                                      : null,
                                  label: 'Business Address',
                                ),
                                if (formState.hasError &&
                                    viewModel.businessAddress.text.isEmpty)
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
                          businessTypes.when(data: (businesses) =>             FormField<String>(validator: (value) {
                    if (viewModel.businessTypeId.isEmpty) {
                      return 'Business Type is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaSelectField(
                            height: 0.2,
                            uniqueKey: 'business-type',
                            label: "Business Type",
                            hintText: 'Select Business Type',
                            items: businesses,
                            onSelected: (value) =>
                                viewModel.selectBizType(value)),
                        if (formState.hasError && viewModel.businessTypeId.isEmpty)
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
                  }), error: (e, stack) => SizedBox.shrink(), loading: SizedBox.shrink)
                        ],
                      )),

                  /** business section ends */
                    const Gap(10),
                  FormField<String>(validator: (value) {
                    if (viewModel.phoneNumber.text.isEmpty) {
                      return 'Phone is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phone Number",
                          style:Theme.of(context).textTheme.bodyMedium?.wayaCopyWith(
                    fontSize: 14,
                    color: wayaTheme.colorScheme.greyColor900,
                  ),
                        ),
                        const Gap(3),
                        Row(
                          children: [
                            //   Expanded(
                            Container(
                              height: 48,
                              width: 90,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: wayaTheme.colorScheme.greyColor300,
                                      width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0))),
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
                                controller: viewModel.phoneNumber,
                                hintText: '000-000-000',
                                borderColor: formState.hasError &&
                                        viewModel.phoneNumber.text.isEmpty
                                    ? wayaTheme.colorScheme.error
                                    : null,
                              ),
                            )
                          ],
                        ),
                        if (formState.hasError &&
                            viewModel.phoneNumber.text.isEmpty)
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
                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: viewModel.referenceCode,
                          hintText: 'Enter Referral Code',
                          label: 'Referral Code (Optional)',
                        ),
                      ],
                    );
                  }),
                  const Gap(10),
                  FormField<String>(validator: (value) {
                    if (viewModel.address.text.isEmpty) {
                      return 'Address is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: viewModel.address,
                          hintText: 'Enter Your Address',
                          borderColor: formState.hasError &&
                                  viewModel.address.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Address',
                        ),
                        if (formState.hasError &&
                            viewModel.address.text.isEmpty)
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
                  Row(
                    children: [
                      Expanded(
                        child: FormField<String>(validator: (value) {
                          if (viewModel.city.text.isEmpty) {
                            return 'City is required';
                          }

                          return null;
                        }, builder: (formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WayaTextFormField(
                                keyboardType: TextInputType.name,
                                controller: viewModel.city,
                                hintText: 'Enter Your City',
                                borderColor: formState.hasError &&
                                        viewModel.city.text.isEmpty
                                    ? wayaTheme.colorScheme.error
                                    : null,
                                label: 'City',
                              ),
                              if (formState.hasError &&
                                  viewModel.city.text.isEmpty)
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
                      ),
                      const Gap(10),
                      Expanded(
                        child: FormField<String>(validator: (value) {
                          if (viewModel.state.text.isEmpty) {
                            return 'State is required';
                          }

                          return null;
                        }, builder: (formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WayaTextFormField(
                                keyboardType: TextInputType.name,
                                controller: viewModel.state,
                                hintText: 'Enter Your State',
                                borderColor: formState.hasError &&
                                        viewModel.state.text.isEmpty
                                    ? wayaTheme.colorScheme.error
                                    : null,
                                label: 'State',
                              ),
                              if (formState.hasError &&
                                  viewModel.state.text.isEmpty)
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
                      )
                    ],
                  ),
                  const Gap(10),
                  FormField<String>(validator: (value) {
                    if (viewModel.country.text.isEmpty) {
                      return 'Country is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: viewModel.country,
                          hintText: 'Enter Your Country',
                          borderColor: formState.hasError &&
                                  viewModel.country.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Country',
                        ),
                        if (formState.hasError &&
                            viewModel.country.text.isEmpty)
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
                  FormField<String>(
                    validator: (value) {
                      if (viewModel.dateOfBirth.isEmpty) {
                        return 'Date of Birth is required';
                      }
                      return null;
                    },
                    builder: (formState) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date of Birth",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.wayaCopyWith(
                                    fontSize: 14,
                                    color: wayaTheme.colorScheme.greyColor900,
                                  )),
                          const Gap(4),
                          WayaButton(
                            callback: () {
                              viewModel.showDatePickerDialog(context);
                            },
                            horizontalPadding: 0,
                            color: wayaTheme.colorScheme.transparent,
                            centerWidget: Focus(
                                onFocusChange: (hasFocus) {
                                  viewModel.focusChanged(hasFocus);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          viewModel.dateOfBirth.isEmpty
                                              ? 'Select Date'
                                              : viewModel.dateOfBirth,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.wayaCopyWith(
                                                fontSize: 14,
                                                color: viewModel
                                                        .dateOfBirth.isEmpty
                                                    ? wayaTheme.colorScheme
                                                        .greyColor300
                                                    : wayaTheme.colorScheme
                                                        .customBlack,
                                              )),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color:
                                            wayaTheme.colorScheme.greyColor300,
                                      )
                                    ],
                                  ),
                                )),
                            border: Border.all(
                                width: 1,
                                color: viewModel.isFocused
                                    ? wayaTheme.colorScheme.customPrimary
                                    : wayaTheme.colorScheme.greyColor300),
                          ),
                          if (formState.hasError &&
                              viewModel.dateOfBirth.isEmpty)
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
                    },
                  ),
                  const Gap(10),
                  FormField<String>(validator: (value) {
                    if (viewModel.gender.isEmpty) {
                      return 'Gender is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaSelectField(
                            height: 0.2,
                            label: "Gender",
                            uniqueKey: 'gender',
                            hintText: 'Select Gender',
                            items: viewModel.genders,
                            onSelected: (value) =>
                                viewModel.selectGender(value.value)),
                        if (formState.hasError && viewModel.gender.isEmpty)
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
                  const Gap(10),
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
                        Focus(
                          onFocusChange: (hasFocus) {
                            viewModel.setConfirmPasswordFocus(hasFocus);
                          },
                          child: WayaTextFormField(
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
                        ),
                        if (formState.hasError &&
                            !viewModel.isConfirmPasswordFocused)
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
                  Row(
                    children: [
                      Checkbox(
                          value: viewModel.isAgreeToTerm,
                          onChanged: (value) {
                            viewModel.toggleTerm(value);
                          }),
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
                  //

                  WayaButton(
                    callback: !viewModel.isLoading
                        ? () async {
                         
                               if (_formKey.currentState!.validate()) {
                         await viewModel.onSubmit(widget.goToNextTab);
                      }
                          

                          }
                        : null,
                    centerWidget: LoadingState(
                        loading: viewModel.isLoading, text: 'Continue'),
                  )
                ],
              ))
        ],
      ),
    );
  }
}

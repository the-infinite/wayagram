import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/auth/account_creation/vm/personal_first_step_vm.dart';
import 'package:wayagram/features/auth/upgrade_to_business/vm/upgrade_to_business_vm.dart';

class UpgradeToBusiness extends ConsumerStatefulWidget {
  static const route = '/upgrade-to-business';
  const UpgradeToBusiness({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpgradeToBusinessState();
}

class _UpgradeToBusinessState extends ConsumerState<UpgradeToBusiness> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(personalFirstStepProvider.notifier).fetchBusinessTypes();
      ref.read(personalFirstStepProvider.notifier).fetchLocation();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(upgradeToBusinessVmProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isLoading: viewModel.isLoading,
      isScrollable: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Upgrade to Business", style: wayaTheme.textTheme.titleLarge),
          const Gap(10),
          Text(
              "Fill in your required information to upgrade to a business account",
              style: wayaTheme.textTheme.hintStyle),
          const Gap(20),
          Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormField<String>(validator: (value) {
                    if (viewModel.name.text.isEmpty) {
                      return 'Business Name is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.name,
                          controller: viewModel.name,
                          hintText: 'Enter Your Business Name',
                          borderColor:
                              formState.hasError && viewModel.name.text.isEmpty
                                  ? wayaTheme.colorScheme.error
                                  : null,
                          label: 'Business Name',
                        ),
                        if (formState.hasError && viewModel.name.text.isEmpty)
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
                    if (viewModel.contactEmail.text.isEmpty) {
                      return 'Email is required';
                    }
                    final RegExp regexp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!regexp.hasMatch(viewModel.contactEmail.text)) {
                      return 'Invalid email address';
                    }
                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: viewModel.contactEmail,
                          hintText: 'example@gmail.com',
                          borderColor: formState.hasError &&
                                  viewModel.contactEmail.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Email Address',
                        ),
                        if (formState.hasError &&
                            viewModel.contactEmail.text.isEmpty)
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
                    if (viewModel.address.text.isEmpty) {
                      return 'Business Address is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: viewModel.address,
                          hintText: 'Enter Your Business Address',
                          borderColor: formState.hasError &&
                                  viewModel.address.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Business Address',
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
                  FormField<String>(validator: (value) {
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
                            value: viewModel.businessTypeId,
                            label: "Business Type",
                            hintText: 'Select Business Type',
                            items: viewModel.businessTypes,
                            onSelected: (value) => ref
                                .read(personalFirstStepProvider.notifier)
                                .selectBizType(value)),
                        if (formState.hasError &&
                            viewModel.businessTypeId.isEmpty)
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
                    if (viewModel.contactPhone.text.isEmpty) {
                      return 'Phone is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phone Number",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.wayaCopyWith(
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
                                controller: viewModel.contactPhone,
                                hintText: '000-000-000',
                                borderColor: formState.hasError &&
                                        viewModel.contactPhone.text.isEmpty
                                    ? wayaTheme.colorScheme.error
                                    : null,
                              ),
                            )
                          ],
                        ),
                        if (formState.hasError &&
                            viewModel.contactPhone.text.isEmpty)
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
                    if (viewModel.country.isEmpty) {
                      return 'Country is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaSelectField(
                            uniqueKey: 'country',
                            label: "Country",
                            value: viewModel.country,
                            hintText: 'Select Country',
                            items: viewModel.countries,
                            onSelected: (value) => ref
                                .read(personalFirstStepProvider.notifier)
                                .selectCountry(value)),
                        if (formState.hasError && viewModel.country.isEmpty)
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
                          if (viewModel.city.isEmpty) {
                            return 'City is required';
                          }

                          return null;
                        }, builder: (formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WayaSelectField(
                                  uniqueKey: 'city',
                                  label: "City",
                                  value: viewModel.city,
                                  hintText: 'Select City',
                                  items: viewModel.cities,
                                  onSelected: (value) => ref
                                      .read(personalFirstStepProvider.notifier)
                                      .selectCity(value)),
                              if (formState.hasError && viewModel.city.isEmpty)
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
                        if (viewModel.state.isEmpty) {
                          return 'State is required';
                        }

                        return null;
                      }, builder: (formState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WayaSelectField(
                                height: 0.2,
                                uniqueKey: 'state',
                                label: "State",
                                value: viewModel.state,
                                hintText: 'Select State',
                                items: viewModel.states,
                                onSelected: (value) => ref
                                    .read(personalFirstStepProvider.notifier)
                                    .selectState(value)),
                            if (formState.hasError && viewModel.state.isEmpty)
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
                      }))
                    ],
                  ),
                  const Gap(10),
                  FormField<String>(validator: (value) {
                    if (viewModel.lga.isEmpty) {
                      return 'LGA is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaSelectField(
                            height: 0.2,
                            uniqueKey: 'lga',
                            label: "LGA",
                            hintText: 'Select LGA',
                            value: viewModel.lga,
                            items: viewModel.lgas,
                            onSelected: (value) => ref
                                .read(personalFirstStepProvider.notifier)
                                .selectLGA(value)),
                        if (formState.hasError && viewModel.lga.isEmpty)
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

                  const Gap(20),
                  //

                  WayaButton(
                    callback: () async {
                      if (_formKey.currentState!.validate()) {}
                    },
                    text: 'Upgrade',
                  )
                ],
              ))
        ],
      ),
    );
  }
}

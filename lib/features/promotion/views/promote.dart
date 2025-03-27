import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/features/promotion/bottom_sheet/pay_for_promotion.dart';
import 'package:wayagram/features/promotion/vm/promotion_vm.dart';
import 'package:wayagram/features/shop/filter/widgets/filter_chip_item.dart';

import '../../../core/utils/task.dart';

class Promote extends ConsumerStatefulWidget {
  static const route = "/promote";
  const Promote({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PromoteState();
}

class _PromoteState extends ConsumerState<Promote> {
  final _formKey = GlobalKey<FormState>();
  var values = RangeValues(16, 80);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(promotionVmProvider.notifier).getAllStates();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(promotionVmProvider);
    final labels = RangeLabels(values.start.toString(), values.end.toString());
    final notifier = ref.read(promotionVmProvider.notifier);
    // TODO: implement build
    return WayaScaffold(
      isLoading: false,
      isScrollable: false,
      title: "Promote",
      body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: FormField<String>(validator: (value) {
                    if (state.state.isEmpty) {
                      return 'State is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaSelectField<String>(
                            height: 0.2,
                            uniqueKey: 'state',
                            label: "State",
                            value: state.state,
                            hintText: 'Select State',
                            items: state.states,
                            onSelected: (value) =>
                                notifier.selectState(value.first)),
                        if (formState.hasError && state.state.isEmpty)
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
                  })),
                  const Gap(10),
                  Expanded(
                    child: FormField<String>(validator: (value) {
                      if (state.lga.isEmpty) {
                        return 'LGA is required';
                      }

                      return null;
                    }, builder: (formState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaSelectField<String>(
                              height: 0.2,
                              uniqueKey: 'lga',
                              label: "LGA",
                              hintText: 'Select LGA',
                              value: state.lga,
                              items: state.lgas,
                              onSelected: (value) =>
                                  notifier.selectLGA(value.first)),
                          if (formState.hasError && state.lga.isEmpty)
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
                  ),
                ],
              ),
              const Gap(10),
              FormField<String>(validator: (value) {
                if (state.city.isEmpty) {
                  return null;
                }

                return null;
              }, builder: (formState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WayaSelectField<String>(
                        uniqueKey: 'city',
                        label: "City",
                        value: state.city,
                        hintText: 'Select City',
                        items: state.cities,
                        onSelected: (value) =>
                            notifier.selectCity(value.first)),
                    if (formState.hasError && state.city.isEmpty)
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  "Target Gender",
                  style: wayaTheme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: wayaTheme.colorScheme.greyColor900,
                  ),
                ),
              ),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: notifier.genderOptions.map((option) {
                  return FilterChipItem(
                    label: option.label,
                    isSelected: state.gender.contains(option.value),
                    onSelected: () {
                      notifier.selectGender(option.value);
                    },
                  );
                }).toList(),
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  "Age Range",
                  style: wayaTheme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: wayaTheme.colorScheme.greyColor900,
                  ),
                ),
              ),
              RangeSlider(
                values: values,
                min: state.rangeStart,
                max: state.rangeEnds,
                divisions: 10,
                labels: labels,
                onChanged: (newValues) {
                  setState(() {
                    values = newValues;
                  });
                },
              ),
              Row(
                spacing: 10,
                children: [
                  //? Minimum distance.
                  Expanded(
                    child: FormField<String>(
                      validator: (value) {
                        if (state.minAge.text.isEmpty) {
                          return 'Min Age is required';
                        }
                        return null;
                      },
                      builder: (formState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WayaTextFormField(
                              keyboardType: TextInputType.number,
                              controller: state.minAge,
                              hintText: 'Min Age',
                              borderColor: formState.hasError &&
                                      state.minAge.text.isEmpty
                                  ? wayaTheme.colorScheme.error
                                  : null,
                              label: '',
                              onChanged: (value) {
                                debounce(
                                  () {
                                    notifier.setRangeStart(double.tryParse(
                                            value.trim().replaceAll(',', '')) ??
                                        18);
                                  },
                                  key: 'age-range-start',
                                  delay: const Duration(milliseconds: 800),
                                );
                              },
                            ),

                            // Error.
                            if (formState.hasError && state.minAge.text.isEmpty)
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
                      },
                    ),
                  ),

                  //? Maximum distance.
                  Expanded(
                    child: FormField<String>(
                      validator: (value) {
                        if (state.maxAge.text.isEmpty) {
                          return 'Max Distance is required';
                        }
                        return null;
                      },
                      builder: (formState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WayaTextFormField(
                              keyboardType: TextInputType.number,
                              controller: state.maxAge,
                              hintText: 'Max Age',
                              borderColor: formState.hasError &&
                                      state.maxAge.text.isEmpty
                                  ? wayaTheme.colorScheme.error
                                  : null,
                              label: '',
                              onChanged: (value) {
                                debounce(
                                  () {
                                    notifier.setRangeEnd(double.tryParse(
                                            value.trim().replaceAll(',', '')) ??
                                        80);
                                  },
                                  key: 'age-range-ends',
                                  delay: const Duration(milliseconds: 800),
                                );
                              },
                            ),

                            // Error.
                            if (formState.hasError && state.maxAge.text.isEmpty)
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
                      },
                    ),
                  ),
                ],
              ),
              const Gap(10),
              FormField<String>(validator: (value) {
                if (state.budget!.text.isEmpty) {
                  return 'Price is required';
                }

                return null;
              }, builder: (formState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WayaTextFormField(
                        keyboardType: TextInputType.number,
                        controller: state.budget,
                        hintText: 'Enter Price',
                        borderColor:
                            formState.hasError && state.budget!.text.isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                        label: 'Budget',
                        suffixIcon: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text("Per day",
                              style: wayaTheme.textTheme.hintStyle),
                        )),
                    if (formState.hasError && state.budget!.text.isEmpty)
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
                return null;
              }, builder: (formState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WayaSelectField<String>(
                        height: 0.3,
                        uniqueKey: 'promotion-duration',
                        label: "Duration",
                        value: state.duration,
                        hintText: 'Select Duration',
                        items: notifier.durationOption,
                        onSelected: (value) {}),
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
            ],
          )),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: context.width * 0.35,
                height: 50,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Positioned(
                      top: 8,
                      child: Text(
                        "Total",
                        style: wayaTheme.textTheme.descriptionStyle.copyWith(
                            color: wayaTheme.colorScheme.greyColor500,
                            fontWeight: FontWeight.normal,
                            fontSize: 14.sp),
                      ),
                    ),
                    Positioned(
                        top: 25,
                        child: Row(
                          children: [
                            Text(
                              WayaHelpers.formatPrice(
                                  int.parse(state.budget?.text ?? '0')),
                              style: wayaTheme.textTheme.descriptionStyle
                                  .copyWith(
                                      color: wayaTheme.colorScheme.customBlack,
                                      fontSize: 18.sp),
                            ),
                            const Gap(3),
                            Text(
                              "per day",
                              style: wayaTheme.textTheme.hintStyle
                                  .copyWith(fontSize: 10.sp),
                            )
                          ],
                        ))
                  ],
                )),
            SizedBox(
              width: context.width * 0.45,
              child: WayaButton(
                callback: () {
                  WayaUtils.showModalSheet(context,
                      child: PayForPromotion(title: ""));
                },
                text: 'Pay',
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/event/widgets/event_date_widget.dart';
import 'package:wayagram/features/promotion/bottom_sheet/pay_for_promotion.dart';
import 'package:wayagram/features/promotion/vm/create_promotion_vm.dart';
import 'package:wayagram/features/shop/filter/widgets/filter_chip_item.dart';

class Promote extends ConsumerStatefulWidget {
  static const route = "/promote";
  const Promote({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PromoteState();
}

class _PromoteState extends ConsumerState<Promote> {
  final _formKey = GlobalKey<FormState>();
  var values = RangeValues(0.1, 0.5);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dynamic arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        String contentId = arg['contentId'];
        String contentType = arg['contentType'];

        ref.read(promotionVmProvider.notifier).fetchAndSetInitialState(
            contentType: contentType, contentId: contentId);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(promotionVmProvider);

    final notifier = ref.read(promotionVmProvider.notifier);
    // TODO: implement build
    return PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) return;
          notifier.reset();
        },
        child: WayaScaffold(
          isLoading: state.initialFetching,
          isScrollable: true,
          title: "Promote ${state.contentType}",
          body: Form(
              key: _formKey,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormField<String>(validator: (value) {
                    if (state.name.text.isEmpty) {
                      return 'Title is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: state.name,
                          hintText: 'Enter Title',
                          borderColor:
                              formState.hasError && state.name.text.isEmpty
                                  ? wayaTheme.colorScheme.error
                                  : null,
                          label: 'Title',
                        ),
                        if (formState.hasError && state.name.text.isEmpty)
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
                  FormField<String>(validator: (value) {
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
                            hintText: 'Select target location',
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
                  }),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                    ],
                  ),
                  FormField<String>(validator: (value) {
                    if (state.selectedInterest.isEmpty) {
                      return 'Interest is required';
                    }
                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaSelectField<String>(
                            height: 0.3,
                            uniqueKey: 'promotion-interest',
                            label: "Interest",
                            value: state.selectedInterest,
                            hintText: 'Select Interest',
                            items: state.interests,
                            onSelected: (value) {
                              notifier.update(value.first, 'interest');
                            }),
                        if (formState.hasError &&
                            state.selectedInterest.isEmpty)
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
                  FormField<String>(validator: (value) {
                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaSelectField<String>(
                            height: 0.3,
                            uniqueKey: 'promotion-age-range',
                            label: "Age Range",
                            value: state.selectedAgeRanges,
                            hintText: 'Select Age Range',
                            items: state.interests,
                            onSelected: (value) {
                              notifier.update(value.first, 'ageRanges');
                            }),
                        if (formState.hasError &&
                            state.selectedAgeRanges.isEmpty)
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
                  FormField<String>(validator: (value) {
                    if (state.planId.isEmpty) {
                      return 'Plan is required';
                    }
                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaSelectField<String>(
                            height: 0.3,
                            uniqueKey: 'promotion-plans',
                            label: "Plan",
                            value: state.planId,
                            hintText: 'Select Plan',
                            items: state.promotionPlans,
                            onSelected: (value) {
                              notifier.update(value.first, "plan");
                            }),
                        if (formState.hasError && state.planId.isEmpty)
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
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      spacing: 6,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: EventDateWidget(
                                uniqueKey: 'promotion-start-date',
                                date: state.startDate,
                                formErrorMessage: "Date is required",
                                hintText: 'Select Start Date',
                                label: 'Start Date',
                                selectDate: notifier.selectStartDate)),
                        Expanded(
                            child: EventDateWidget(
                                uniqueKey: 'promotion-end-date',
                                date: state.endDate,
                                formErrorMessage: "Date is required",
                                hintText: 'Select End Date',
                                label: 'End Date',
                                selectDate: notifier.selectEndDate)),
                      ],
                    ),
                  ),
                ],
              )),
          bottomNavigationBar: Container(
            padding: EdgeInsets.fromLTRB(15, 6, 15, 15),
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
                            style: wayaTheme.textTheme.descriptionStyle
                                .copyWith(
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
                                  state.selectedPlan != null
                                      ? WayaHelpers.formatPrice(
                                          state.selectedPlan!.price)
                                      : WayaHelpers.formatPrice(int.parse('0')),
                                  style: wayaTheme.textTheme.descriptionStyle
                                      .copyWith(
                                          color:
                                              wayaTheme.colorScheme.customBlack,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w500),
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
                      if (_formKey.currentState!.validate()) {
                        notifier.onSubmit(context: context);
                      }
                    },
                    text: 'Pay',
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

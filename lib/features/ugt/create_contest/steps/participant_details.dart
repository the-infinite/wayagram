import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import '../../../../core/components/waya_buttons.dart';
import '../../../../core/components/waya_select_field.dart';
import '../../../../core/components/waya_text_form_field.dart';
import '../../../../core/utils/waya_navigation.dart';
import '../../../auth/account_creation/vm/personal_first_step_vm.dart';
import '../../../shop/widgets/upload_image.dart';
import '../../vm/ugt_vm.dart';
import 'create_ultimate.dart';

class ParticipantDetails extends StatefulHookConsumerWidget {
  final Function goToNextTab;
  final Function(int) goToPrevTab;
  const ParticipantDetails(
      {super.key, required this.goToNextTab, required this.goToPrevTab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ParticipantDetailsState();
}

final _formKey = GlobalKey<FormState>();

class _ParticipantDetailsState extends ConsumerState<ParticipantDetails> {
  final _formKey = GlobalKey<FormState>();
  var paymentType = [
    {'paymentType': 'Free'},
    {'paymentType': 'Paid'},
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(personalFirstStepProvider);
    final viewModel2 = ref.watch(contestNotifierProvider);
    var contestViewModel = ref.watch(selectedContestProvider.notifier).state;
    final wayaTheme = Theme.of(context);
    var isEditing = ref.watch(stateIsEditingContestProvider);
    useEffect(() {
      if (isEditing) {
        Future.delayed(Duration(seconds: 1), () {
          viewModel2.howItWorks.text = contestViewModel?.howItWorks ?? "";

          if (contestViewModel?.entryType?.toLowerCase() == "free") {
            viewModel2.amount.text = "0";
          }
          ref.read(contestNotifierProvider.notifier).updateEntryType(
              contestViewModel?.entryType?.toLowerCase() == "free"
                  ? "Free"
                  : "Paid");
          // viewModel2.entrySelectType = contestViewModel.entryType??"";
          viewModel2.amount.text = contestViewModel?.amount?.toString() ?? "";
          ref.read(contestNotifierProvider.notifier).updateParticipationDate(
              contestViewModel?.participationStartDate?.split("T").first ?? "");

          viewModel2.descriptionOfAwards.text =
              contestViewModel?.descriptionOfAwards ?? "";
        });
      }
      return null;
    }, []);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Participation Details", style: wayaTheme.textTheme.titleLarge),
          const Gap(5),
          Text(
              "Bring your talent contest vision to life. Customize details, set stages, and make it unforgettable",
              style: wayaTheme.textTheme.hintStyle),
          const Gap(30),
          FormField<String>(validator: (value) {
            if (viewModel2.howItWorks.text.isEmpty) {
              return 'Please Enter Contest Description';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaTextFormField(
                  controller: viewModel2.howItWorks,
                  hintText: "Enter Contest Description",
                  label: "How to Participate",
                  maxLength: 500,
                  line: 6,
                  borderColor:
                      formState.hasError && viewModel2.howItWorks.text.isEmpty
                          ? wayaTheme.colorScheme.error
                          : null,
                ),
                if (formState.hasError && viewModel2.howItWorks.text.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      formState.errorText!,
                      style: TextStyle(
                          color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                    ),
                  ),
              ],
            );
          }),
          const Gap(15),
          FormField<String>(validator: (value) {
            if (viewModel2.entrySelectType.isEmpty) {
              return 'Entry type is required';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //   state.contestFreePaid
                WayaSelectField<String>(
                  height: 0.3,
                  value: viewModel2.entrySelectType,
                  label: "Entry Type",
                  hintText: 'Choose entry type',
                  items: ref
                      .read(contestNotifierProvider.notifier)
                      .ugtPaymentType(),
                  onSelected: (value) {
                    print(" i am poo ${value.first.label}");
                    if (value.first.label == "Free") {
                      viewModel2.amount.text = "0";
                    }
                    ref
                        .read(contestNotifierProvider.notifier)
                        .updateEntryType(value.first.label);
                  },
                  uniqueKey: 'contest-state',
                ),
                if (formState.hasError && viewModel2.entrySelectType.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      formState.errorText!,
                      style: TextStyle(
                          color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                    ),
                  ),
              ],
            );
          }),
          const Gap(15),
          if (viewModel2.entrySelectType != "Free")
            FormField<String>(validator: (value) {
              if (viewModel2.amount.text.isEmpty) {
                return 'Amount is required';
              }
              String value = viewModel2.amount.text.contains("NGN")
                  ? viewModel2.amount.text
                      .replaceAll("NGN", "")
                      .split(".")
                      .first
                      .toString()
                  : viewModel2.amount.text;
             
              if (int.parse(value) <= 0) {
               
                return 'Amount must be greater than zero';
              }
              return null;
            }, builder: (formState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WayaTextFormField(
                    controller: viewModel2.amount,
                    keyboardType: TextInputType.number,
                    hintText: "NGN0",
                    isReadOnly: viewModel2.entrySelectType == "Free",
                    label: "Amount",
                    inputFormatters: [
                      CurrencyTextInputFormatter.currency(
                          name: 'NGN', symbol: 'NGN', locale: 'en_NG')
                    ],
                    borderColor:
                        formState.hasError ? wayaTheme.colorScheme.error : null,
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
          const Gap(15),
          /*   Row(
            children: [
              Expanded(
                child: FormField<String>(validator: (value) {
                  if (viewModel2.durationSelectType.isEmpty) {
                    return 'Duration type is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaSelectField<String>(
                        height: 0.3,
                        value: viewModel2.durationSelectType,
                        label: "Duration Type",
                        hintText: 'Duration Type',
                        items: ref
                            .read(contestNotifierProvider.notifier)
                            .ugtDurationType(),
                        onSelected: (value) => ref
                            .read(contestNotifierProvider.notifier)
                            .updateDurationType(value.first.label),
                        uniqueKey: 'contest-state',
                      ),
                      if (formState.hasError &&
                          viewModel2.durationSelectType.isEmpty)
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
                  if (viewModel2.numberOfDuration.text.isEmpty) {
                    return 'Number of duration is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.number,
                        controller: viewModel2.numberOfDuration,
                        hintText: 'e.g., 3',
                        borderColor: formState.hasError &&
                                viewModel2.numberOfDuration.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: 'Number of Duration',
                      ),
                      if (formState.hasError &&
                          viewModel2.numberOfDuration.text.isEmpty)
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
          const Gap(15), */
          FormField<String>(validator: (value) {
            if (viewModel2.startDate.isEmpty) {
              return 'Date is required';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    ref
                        .read(contestNotifierProvider.notifier)
                        .showDatePickerDialog(context);
                  },
                  child: AbsorbPointer(
                    child: WayaSelectField<String>(
                      height: 0.3,
                      value: viewModel2.startDate.isEmpty
                          ? 'DD/MM/YYYY'
                          : viewModel2.startDate,
                      label: "Participation Start Date",
                      hintText: 'Select Start Date',
                      items: ref
                          .read(contestNotifierProvider.notifier)
                          .ugtDurationType(),
                      onSelected: (value) => ref
                          .read(contestNotifierProvider.notifier)
                          .updateParticipationDate(value.first.label),
                      uniqueKey: 'contest-state',
                    ),
                  ),
                ),
                if (formState.hasError && viewModel2.startDate.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      formState.errorText!,
                      style: TextStyle(
                          color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                    ),
                  ),
              ],
            );
          }),
          const Gap(15),
          FormField<String>(validator: (value) {
            if (viewModel2.descriptionOfAwards.text.isEmpty) {
              return 'Please enter Contest Description';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaTextFormField(
                  controller: viewModel2.descriptionOfAwards,
                  hintText: "Enter Contest Description",
                  label: "Contest Description",
                  maxLength: 500,
                  line: 6,
                  borderColor: formState.hasError &&
                          viewModel2.descriptionOfAwards.text.isEmpty
                      ? wayaTheme.colorScheme.error
                      : null,
                ),
                if (formState.hasError &&
                    viewModel2.descriptionOfAwards.text.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      formState.errorText!,
                      style: TextStyle(
                          color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                    ),
                  ),
              ],
            );
          }),
          /*   WayaTextFormField(
            controller: viewModel2.descriptionOfAwards,
            hintText: "Enter Contest Description",
            label: "Contest Description",
            line: 6,
          ), */
          const Gap(60),
          WayaButton(
            callback: () async {
              // widget.goToNextTab();
              if (viewModel2.entrySelectType == "Free") {
                viewModel2.amount.text = "0";
              }

              if (_formKey.currentState!.validate()) {
                widget.goToNextTab();
              }
            },
            text: "Continue",
          ),
          const Gap(8),
          WayaButton(
              text: 'Go Back',
              color: wayaTheme.colorScheme.greyColor300,
              textColor: wayaTheme.colorScheme.customBlack,
              border: Border.all(
                  width: 1, color: wayaTheme.colorScheme.greyColor300),
              callback: () {
                widget.goToPrevTab(0);
                //  WayaNav.goBack();
                // WayaNav.toNamed("/ugt-home");
              })
        ],
      ),
    );
  }
}

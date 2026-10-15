import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/data/model/stage_pref_model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import '../../../../core/utils/waya_navigation.dart';

import '../../data/controller/contest_controller.dart' as contest_ctrl;
import '../../vm/ugt_vm.dart';
import 'create_ultimate.dart';

class EditStagePreference extends StatefulHookConsumerWidget {
  static const route = '/edit-stage-preference';

  const EditStagePreference({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditStagePreferenceState();
}

class _EditStagePreferenceState extends ConsumerState<EditStagePreference> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final contestState = ref.watch(contest_ctrl.contestControllerProvider);
    final formControllers =
        ref.watch(contest_ctrl.contestFormControllersProvider);

    StagePrefModel model = ref.read(stateContactProvider.notifier).state[
        contestState
            .selectedIndex]; /* state.firstWhere((value) {
      return contestState.selectedIndex == value.id;
    }); */
    final entryType = useState(model.entryType ?? "Paid");
    final startDate = useState(model.startDate ?? "");
    final endDate = useState(model.endDate ?? "");
    //final maxVote = useState(model.maxVote ?? "");
    final priceForWinner = useState(
        formControllers.contestPrizeWinnerTextController.text.trim().isEmpty
            ? "No"
            : formControllers.contestPrizeWinnerTextController.text == "0"
                ? "No"
                : "Yes");
    final isSwitched = useState(model.reviewApprovePost ?? false);
    useEffect(() {
      formControllers.contestStageNameTextController.text =
          model.stageName == "Stage name" ? "" : model.stageName ?? "";
      formControllers.entryAmountController.text = model.entryAmount ?? "";
      formControllers.contestNumberPostsPerWeekTextController.text =
          model.numPostPerWeek ?? "";
      formControllers.contestPrizeWinnerTextController.text =
          model.priceWinner ?? "";

      formControllers.contestvoteCountToQualifyTextController.text =
          model.voteCountToQualify ?? "";

      formControllers.contestMaxVoteTextController.text = model.maxVote ?? "";

      return null;
    }, []);
    //  final priceWinner = useState(model.priceWinner ?? "");

    // final viewModel1 = ref.watch(personalFirstStepProvider);
    final viewModel = ref.watch(contestNotifierProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Edit Stage Preference",
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                FormField<String>(validator: (value) {
                  if (formControllers
                      .contestStageNameTextController.text.isEmpty) {
                    return 'Stage name is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        controller:
                            formControllers.contestStageNameTextController,
                        hintText: "Qualification Stage",
                        label: "Stage Name ",
                        borderColor: formState.hasError &&
                                viewModel.amountPerVote.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                      ),
                      if (formState.hasError && viewModel.title.text.isEmpty)
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

/*           WayaTextFormField(
            controller: TextEditingController(),
            hintText: "Qualification Stage",
            label: "Stage Name ",
          ), */
                const Gap(15),
                FormField<String>(validator: (value) {
                  if (entryType.value.isEmpty) {
                    return 'Entry type is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaSelectField<String>(
                        height: 0.3,
                        value: entryType.value,
                        label: "Entry Type ",
                        hintText: 'Choose entry type',
                        items: ref
                            .read(contestNotifierProvider.notifier)
                            .ugtPaymentType(),
                        onSelected: (value) {
                          if (value.first.label.toLowerCase() == "free") {
                            formControllers.entryAmountController.text = "0";
                          }
                          entryType.value = value.first.label;
                        },
                        uniqueKey: 'entry-type',
                      ),
                      const Gap(15),
                      if (formState.hasError && entryType.value.isEmpty)
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
                if (entryType.value.toLowerCase() != "free")
                  FormField<String>(validator: (value) {
                    if (formControllers.entryAmountController.text.isEmpty) {
                      return 'Entry Amount is required';
                    }

                    String value = formControllers.entryAmountController.text
                            .contains("NGN")
                        ? formControllers.entryAmountController.text
                            .replaceAll("NGN", "")
                            .replaceAll(",", "")
                            .split(".")
                            .first
                            .toString()
                        : formControllers.entryAmountController.text;

                    if (int.parse(value) <= 0) {
                      return 'Amount must be greater than zero';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          controller: formControllers.entryAmountController,
                          keyboardType: TextInputType.number,
                          hintText: "0 NGN",
                          isReadOnly: entryType.value.toLowerCase() == "free",
                          label: "Entry Amount",
                          inputFormatters: [
                            CurrencyTextInputFormatter.currency(
                                name: 'NGN', symbol: 'NGN', locale: 'en_NG')
                          ],
                          borderColor: formState.hasError
                              ? wayaTheme.colorScheme.error
                              : null,
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
                FormField<String>(validator: (value) {
                  if (startDate.value.isEmpty) {
                    return 'Duration type is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          DateTime? firstDate;
                          DateTime? lastDate;

                          //? if is the first stage, then the start date is the contest start date
                          if (contestState.selectedIndex == 0) {
                            firstDate = convertToUsableDate(
                                viewModel.contestTimelineStartDate);
                            lastDate = convertToUsableDate(
                                viewModel.contestTimelineEndDate);
                          } else {
                            //? if not the first stage, then the start date is the end date of the previous stage
                            int newIndex = contestState.selectedIndex - 1;
                            StagePrefModel model = ref
                                .read(stateContactProvider.notifier)
                                .state[newIndex];

                            firstDate = convertToUsableDate(
                                model.endDate ?? "2025-1-1");
                            lastDate = convertToUsableDate(
                                viewModel.contestTimelineEndDate);
                          }

                          startDate.value = await ref
                                  .read(contestNotifierProvider.notifier)
                                  .showDatePickerMain(context,
                                      firstDate: firstDate,
                                      lastDate: lastDate) ??
                              "";
                        },
                        child: AbsorbPointer(
                          child: WayaSelectField<String>(
                            height: 0.3,
                            value: startDate.value.isEmpty
                                ? 'DD/MM/YYYY'
                                : startDate.value,
                            label: "Start Date",
                            hintText: 'Select Start Date',
                            items: ref
                                .read(contestNotifierProvider.notifier)
                                .ugtDurationType(),
                            onSelected: (value) => ref
                                .read(contestNotifierProvider.notifier)
                                .updateDurationType(value.first.label),
                            uniqueKey: 'contest-state',
                          ),
                        ),
                      ),
                      if (formState.hasError && startDate.value.isEmpty)
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
                FormField<String>(validator: (value) {
                  if (endDate.value.isEmpty) {
                    return 'End Date is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (startDate.value.trim().isEmpty) {
                            WayaSnackBar.showToast("Please pick a start date");
                            return;
                          }
                          DateTime? firstDate;
                          DateTime? lastDate;
                          //? if is the first stage, then the start date is the contest start date
                          if (contestState.selectedIndex == 0) {
                            firstDate = convertToUsableDate(startDate.value);
                            lastDate = convertToUsableDate(
                                viewModel.contestTimelineEndDate);
                          } else {
                            //? if not the first stage, then the start date is the end date of the previous stage
                            int newIndex = contestState.selectedIndex - 1;
                            StagePrefModel model = ref
                                .read(stateContactProvider.notifier)
                                .state[newIndex];

                            firstDate = convertToUsableDate(
                                model.endDate ?? "2025-1-1");
                            lastDate = convertToUsableDate(
                                viewModel.contestTimelineEndDate);
                          }

                          endDate.value = await ref
                                  .read(contestNotifierProvider.notifier)
                                  .showDatePickerMain(context,
                                      firstDate: firstDate,
                                      lastDate: lastDate) ??
                              "";
                        },
                        child: AbsorbPointer(
                          child: WayaSelectField<String>(
                            height: 0.3,
                            value: endDate.value.isEmpty
                                ? 'DD/MM/YYYY'
                                : endDate.value,
                            label: "End Date",
                            hintText: 'Select End Date',
                            items: ref
                                .read(contestNotifierProvider.notifier)
                                .ugtDurationType(),
                            onSelected: (value) => ref
                                .read(contestNotifierProvider.notifier)
                                .updateDurationType(value.first.label),
                            uniqueKey: 'End Date',
                          ),
                        ),
                      ),
                      if (formState.hasError && endDate.value.isEmpty)
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
                FormField<String>(validator: (value) {
                  if (formControllers
                      .contestMaxVoteTextController.text.isEmpty) {
                    return 'Maximum vote per person is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        controller:
                            formControllers.contestMaxVoteTextController,
                        hintText: "Enter Maximum Vote per Person",
                        keyboardType: TextInputType.number,
                        label: "Maximum Vote per Person",
                        //label: contestViewModel?.title,
                        borderColor: formState.hasError &&
                                formControllers
                                    .contestMaxVoteTextController.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                      ),
                      if (formState.hasError &&
                          formControllers
                              .contestMaxVoteTextController.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText ?? "",
                            style: TextStyle(
                                color: wayaTheme.colorScheme.error,
                                fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                }),
                const Gap(15),
                FormField<String>(validator: (value) {
                  if (formControllers
                      .contestNumberPostsPerWeekTextController.text.isEmpty) {
                    return 'Number of Posts per week required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        controller: formControllers
                            .contestNumberPostsPerWeekTextController,
                        hintText: "E.g 4",
                        keyboardType: TextInputType.number,
                        label: "Number of Posts per week",
                        borderColor: formState.hasError &&
                                formControllers
                                    .contestNumberPostsPerWeekTextController
                                    .text
                                    .isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                      ),
                      if (formState.hasError &&
                          formControllers
                              .contestNumberPostsPerWeekTextController
                              .text
                              .isEmpty)
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
                FormField<String>(validator: (value) {
                  if (formControllers
                      .contestvoteCountToQualifyTextController.text.isEmpty) {
                    return 'Vote Counts to Qualify is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.number,
                        controller: formControllers
                            .contestvoteCountToQualifyTextController,
                        hintText: "Enter Vote Counts to Qualify",
                        label: "Vote Counts to Qualify",
                        borderColor: formState.hasError &&
                                formControllers
                                    .contestvoteCountToQualifyTextController
                                    .text
                                    .isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                      ),
                      if (formState.hasError &&
                          formControllers
                              .contestvoteCountToQualifyTextController
                              .text
                              .isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText ?? "",
                            style: TextStyle(
                                color: wayaTheme.colorScheme.error,
                                fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                }),
                const Gap(15),
                FormField<String>(validator: (value) {
                  if (priceForWinner.value.isEmpty) {
                    return 'Field is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaSelectField<String>(
                        height: 0.3,
                        value: priceForWinner.value,
                        label: "Is there a prize for the winner",
                        hintText: 'Choose',
                        items: [
                          Select(label: "Yes", value: "1"),
                          Select(label: "No", value: "0")
                        ],
                        onSelected: (value) {
                          if (value.first.label == "Free") {
                            formControllers
                                .contestPrizeWinnerTextController.text = "0";
                          }
                          priceForWinner.value = value.first.label;
                        },
                        uniqueKey: 'contest-state',
                      ),
                      if (formState.hasError && priceForWinner.value.isEmpty)
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
                if (priceForWinner.value == "Yes")
                  FormField<String>(validator: (value) {
                    if (formControllers
                        .contestPrizeWinnerTextController.text.isEmpty) {
                      return 'Winner Prize is required';
                    }
                    // String value = formControllers
                    //     .contestPrizeWinnerTextController.text;
                    /*   .contains("NGN")
                        ? formControllers
                            .contestPrizeWinnerTextController.text
                            .replaceAll("NGN", "")
                            .replaceAll(",", "")
                            .split(".")
                            .first
                            .toString()
                        : formControllers
                            .contestPrizeWinnerTextController.text;

                    if (int.parse(value) <= 0) {
                      return 'Amount must be greater than zero';
                    } */

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller:
                              formControllers.contestPrizeWinnerTextController,
                          line: 6,
                          /*    inputFormatters: [
                            CurrencyTextInputFormatter.currency(
                                name: 'NGN', symbol: 'NGN', locale: 'en_NG')
                          ], */
                          hintText: "Enter Winners price",
                          label: "Prize for the Winner? ",
                          borderColor: formState.hasError
                              ? wayaTheme.colorScheme.error
                              : null,
                        ),
                        if (formState.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText ?? "Error",
                              style: TextStyle(
                                  color: wayaTheme.colorScheme.error,
                                  fontSize: 12.sp),
                            ),
                          ),
                      ],
                    );
                  }),
                /*  FormField<String>(validator: (value) {
                  if (priceWinner.value.isEmpty) {
                    return 'Prize for the Winner is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaSelectField<String>(
                        height: 0.3,
                        value: priceWinner.value,
                        label: "Prize for the Winner?",
                        hintText: 'Select Yes or No',
                        items: ref
                            .read(contestNotifierProvider.notifier)
                            .ugtWinnerPrize(),
                        onSelected: (value) {
                          priceWinner.value = value.label;
                        },
                        uniqueKey: 'Price for winner',
                      ),
                      if (formState.hasError && priceWinner.value.isEmpty)
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
               */
                const Gap(15),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch(
                  value: isSwitched.value,
                  onChanged: (value) {
                    setState(() {
                      isSwitched.value = value;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: wayaTheme.colorScheme.customPrimary),
              const SizedBox(width: 10),
              Text(
                "Review and approve post before going live",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isSwitched.value ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
          const Gap(40),
          WayaButton(
            callback: () {
              if (priceForWinner.value == "No") {
                formControllers.contestPrizeWinnerTextController.text = "0";
              }
              if (entryType.value.toLowerCase() == "free") {
                formControllers.entryAmountController.text = "0";
              }
              if (_formKey.currentState!.validate()) {
                ref.read(stateContactProvider.notifier).state = ref
                    .read(stateContactProvider)
                    .where((i) => contestState.selectedIndex != i.id)
                    .toList();
                ref.read(stateContactProvider.notifier).state.insert(
                    contestState.selectedIndex,
                    StagePrefModel(
                        id: contestState.selectedIndex,
                        endDate: endDate.value,
                        stageName:
                            formControllers.contestStageNameTextController.text,
                        startDate: startDate.value,
                        priceWinner: formControllers
                            .contestPrizeWinnerTextController.text,
                        maxVote:
                            formControllers.contestMaxVoteTextController.text,
                        entryType: entryType.value,
                        reviewApprovePost: isSwitched.value,
                        voteCountToQualify: formControllers
                            .contestvoteCountToQualifyTextController.text,
                        entryAmount: formControllers.entryAmountController.text,
                        numPostPerWeek: formControllers
                            .contestNumberPostsPerWeekTextController.text));
                WayaNav.goBack();
              }
              /*  if (_formKey.currentState!.validate()) {
                ref.read(stateContactProvider.notifier).state = ref
                  .read(stateContactProvider)
                  .where((i) => contestState.selectedIndex != i.id)
                  .toList();
              ref.read(stateContactProvider.notifier).state.insert(
                  contestState.selectedIndex,
                  StagePrefModel(
                      id: contestState.selectedIndex,
                      endDate: endDate.value,
                      stageName: formControllers
                          .contestStageNameTextController.text,
                      startDate: startDate.value,
                      priceWinner: priceWinner.value,
                      entryType: entryType.value,
                      reviewApprovePost: isSwitched.value,
                      entryAmount:
                          formControllers.entryAmountController.text,
                      numPostPerWeek: formControllers
                          .contestNumberPostsPerWeekTextController.text));
              } */
            },
            text: "Save Stage Changes",
          ),
          const Gap(8),
          WayaButton(
              text: 'Go Back',
              color: wayaTheme.colorScheme.greyColor300,
              textColor: wayaTheme.colorScheme.customBlack,
              border: Border.all(
                  width: 1, color: wayaTheme.colorScheme.greyColor300),
              callback: () {
                WayaNav.goBack();
              })
        ],
      ),
    );
  }
}

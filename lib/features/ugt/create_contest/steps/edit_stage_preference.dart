import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/data/model/stage_pref_model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import '../../../../core/utils/waya_navigation.dart';

import '../../data/controller/contest_controller.dart';
import '../../vm/ugt_vm.dart';
import 'create_ultimate.dart';

class EditStagePreference extends StatefulHookConsumerWidget {
  static const route = '/edit-stage-preference';

  const EditStagePreference({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditStagePreferenceState();
}

class _EditStagePreferenceState extends ConsumerState<EditStagePreference> {
  final _formKey = GlobalKey<FormState>();
  final _contestController = Get.put(ContestController());

  @override
  Widget build(BuildContext context) {
    StagePrefModel model = ref.read(stateContactProvider.notifier).state[_contestController
        .selectedIndex]; /* state.firstWhere((value) {
        debugPrint("${value.toJson()}");
      return _contestController.selectedIndex == value.id;
    }); */
    final entryType = useState(model.entryType ?? "Paid");
    final startDate = useState(model.startDate ?? "");
    final endDate = useState(model.endDate ?? "");
    final priceForWinner = useState(_contestController.contestPrizeWinnerTextController.text.trim().isEmpty
        ? "No"
        : _contestController.contestPrizeWinnerTextController.text == "0"
            ? "No"
            : "Yes");
    final isSwitched = useState(model.reviewApprovePost ?? false);
    useEffect(() {
      _contestController.contestStageNameTextController.text =
          model.stageName == "Stage name" ? "" : model.stageName ?? "";
      _contestController.entryAmountController.text = model.entryAmount ?? "";
      _contestController.contestNumberPostsPerWeekTextController.text = model.numPostPerWeek ?? "";
      _contestController.contestPrizeWinnerTextController.text = model.priceWinner ?? "";


      _contestController.contestvoteCountToQualifyTextController.text =
          model.priceWinner ?? "";

      _contestController.contestMaxVoteTextController.text =
          model.maxVote ?? "";

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

                  if (_contestController
                      .contestStageNameTextController.text.isEmpty) {
                    return 'Stage name is required';

                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        controller: _contestController.contestStageNameTextController,
                        hintText: "Qualification Stage",
                        label: "Stage Name ",
                        borderColor: formState.hasError && viewModel.amountPerVote.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                      ),
                      if (formState.hasError && viewModel.title.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
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
                        items: ref.read(contestNotifierProvider.notifier).ugtPaymentType(),
                        onSelected: (value) {
                          if (value.first.label.toLowerCase() == "free") {
                            _contestController.entryAmountController.text = "0";
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
                            style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                }),
                if (entryType.value.toLowerCase() != "free")
                  FormField<String>(validator: (value) {
                    if (_contestController.entryAmountController.text.isEmpty) {
                      return 'Entry Amount is required';
                    }

                    String value = _contestController.entryAmountController.text.contains("NGN")
                        ? _contestController.entryAmountController.text
                            .replaceAll("NGN", "")
                            .replaceAll(",", "")
                            .split(".")
                            .first
                            .toString()
                        : _contestController.entryAmountController.text;

                    if (int.parse(value) <= 0) {
                      return 'Amount must be greater than zero';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          controller: _contestController.entryAmountController,
                          keyboardType: TextInputType.number,
                          hintText: "0 NGN",
                          isReadOnly: entryType.value.toLowerCase() == "free",
                          label: "Entry Amount",
                          inputFormatters: [
                            CurrencyTextInputFormatter.currency(name: 'NGN', symbol: 'NGN', locale: 'en_NG')
                          ],
                          borderColor: formState.hasError ? wayaTheme.colorScheme.error : null,
                        ),
                        if (formState.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
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
                          if (_contestController.selectedIndex == 0) {
                            firstDate = convertToUsableDate(viewModel.contestTimelineStartDate);
                            lastDate = convertToUsableDate(viewModel.contestTimelineEndDate);
                          } else {
                            //? if not the first stage, then the start date is the end date of the previous stage
                            int newIndex = _contestController.selectedIndex - 1;
                            StagePrefModel model = ref.read(stateContactProvider.notifier).state[newIndex];

                            firstDate = convertToUsableDate(model.endDate ?? "2025-1-1");
                            lastDate = convertToUsableDate(viewModel.contestTimelineEndDate);
                          }

                          startDate.value = await ref
                                  .read(contestNotifierProvider.notifier)
                                  .showDatePickerMain(context, firstDate: firstDate, lastDate: lastDate) ??
                              "";
                        },
                        child: AbsorbPointer(
                          child: WayaSelectField<String>(
                            height: 0.3,
                            value: startDate.value.isEmpty ? 'DD/MM/YYYY' : startDate.value,
                            label: "Start Date",
                            hintText: 'Select Start Date',
                            items: ref.read(contestNotifierProvider.notifier).ugtDurationType(),
                            onSelected: (value) =>
                                ref.read(contestNotifierProvider.notifier).updateDurationType(value.first.label),
                            uniqueKey: 'contest-state',
                          ),
                        ),
                      ),
                      if (formState.hasError && startDate.value.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
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
                          if (_contestController.selectedIndex == 0) {
                            firstDate = convertToUsableDate(startDate.value);
                            lastDate = convertToUsableDate(viewModel.contestTimelineEndDate);
                          } else {
                            //? if not the first stage, then the start date is the end date of the previous stage
                            int newIndex = _contestController.selectedIndex - 1;
                            StagePrefModel model = ref.read(stateContactProvider.notifier).state[newIndex];

                            firstDate = convertToUsableDate(model.endDate ?? "2025-1-1");
                            lastDate = convertToUsableDate(viewModel.contestTimelineEndDate);
                          }

                          endDate.value = await ref
                                  .read(contestNotifierProvider.notifier)
                                  .showDatePickerMain(context, firstDate: firstDate, lastDate: lastDate) ??
                              "";
                        },
                        child: AbsorbPointer(
                          child: WayaSelectField<String>(
                            height: 0.3,
                            value: endDate.value.isEmpty ? 'DD/MM/YYYY' : endDate.value,
                            label: "End Date",
                            hintText: 'Select End Date',
                            items: ref.read(contestNotifierProvider.notifier).ugtDurationType(),
                            onSelected: (value) =>
                                ref.read(contestNotifierProvider.notifier).updateDurationType(value.first.label),
                            uniqueKey: 'End Date',
                          ),
                        ),
                      ),
                      if (formState.hasError && endDate.value.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                }),
                const Gap(15),
                FormField<String>(validator: (value) {

                  if (_contestController
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
                            _contestController.contestMaxVoteTextController,
                        hintText: "Enter Maximum Vote per Person",
                        keyboardType: TextInputType.number,
                        label: "Maximum Vote per Person",
                        //label: contestViewModel?.title,
                        borderColor: formState.hasError &&
                                _contestController
                                    .contestMaxVoteTextController.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                      ),
                      if (formState.hasError &&
                          _contestController
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
                  if (_contestController
                      .contestNumberPostsPerWeekTextController.text.isEmpty) {

                    return 'Number of Posts per week required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        controller: _contestController.contestNumberPostsPerWeekTextController,
                        hintText: "E.g 4",
                        keyboardType: TextInputType.number,
                        label: "Number of Posts per week",
                        borderColor: formState.hasError &&
                                _contestController.contestNumberPostsPerWeekTextController.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                      ),
                      if (formState.hasError && _contestController.contestNumberPostsPerWeekTextController.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                }),
                const Gap(15),
                FormField<String>(validator: (value) {
                  if (_contestController.contestvoteCountToQualifyTextController.text.isEmpty) {
                    return 'Vote Counts to Qualify is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.number,
                        controller: _contestController.contestvoteCountToQualifyTextController,
                        hintText: "Enter Vote Counts to Qualify",
                        label: "Vote Counts to Qualify",
                        borderColor: formState.hasError &&
                                _contestController.contestvoteCountToQualifyTextController.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                      ),
                      if (formState.hasError && _contestController.contestvoteCountToQualifyTextController.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText ?? "",
                            style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
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
                        label: "Is there price for the winner",
                        hintText: 'Choose',
                        items: [Select(label: "Yes", value: "1"), Select(label: "No", value: "0")],
                        onSelected: (value) {
                          debugPrint(" i am poo ${value.first.label}");
                          if (value.first.label == "Free") {
                            _contestController.contestPrizeWinnerTextController.text = "0";
                          }
                          priceForWinner.value = value.first.label;
                          /*  ref
                              .read(contestNotifierProvider.notifier)
                              .updateEntryType(value.first.label); */
                        },
                        uniqueKey: 'contest-state',
                      ),
                      if (formState.hasError && priceForWinner.value.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                }),
                const Gap(15),
                if (priceForWinner.value == "Yes")
                  FormField<String>(validator: (value) {
                    if (_contestController.contestPrizeWinnerTextController.text.isEmpty) {
                      return 'Winner Price is required';
                    }
                    // String value = _contestController
                    //     .contestPrizeWinnerTextController.text;
                    /*   .contains("NGN")
                        ? _contestController
                            .contestPrizeWinnerTextController.text
                            .replaceAll("NGN", "")
                            .replaceAll(",", "")
                            .split(".")
                            .first
                            .toString()
                        : _contestController
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
                          keyboardType: TextInputType.emailAddress,
                          controller: _contestController.contestPrizeWinnerTextController,
                          line: 6,
                          /*    inputFormatters: [
                            CurrencyTextInputFormatter.currency(
                                name: 'NGN', symbol: 'NGN', locale: 'en_NG')
                          ], */
                          hintText: "Enter Winners price",
                          label: "Prize for the Winner? ",
                          borderColor: formState.hasError ? wayaTheme.colorScheme.error : null,
                        ),
                        if (formState.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText ?? "Error",
                              style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
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
          /* WayaTextFormField(
            controller: TextEditingController(),
            hintText: "0 NGN",
            label: "Prize Amount",
          ),
          const Gap(15),*/
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
                _contestController.contestPrizeWinnerTextController.text = "0";
              }
              if (entryType.value.toLowerCase() == "free") {
                _contestController.entryAmountController.text = "0";
              }
              if (_formKey.currentState!.validate()) {
                ref.read(stateContactProvider.notifier).state =
                    ref.read(stateContactProvider).where((i) => _contestController.selectedIndex != i.id).toList();
                ref.read(stateContactProvider.notifier).state.insert(
                    _contestController.selectedIndex,
                    StagePrefModel(
                        id: _contestController.selectedIndex,
                        endDate: endDate.value,
                        stageName: _contestController.contestStageNameTextController.text,
                        startDate: startDate.value,

                        priceWinner: _contestController
                            .contestPrizeWinnerTextController.text,
                        maxVote: _contestController
                            .contestMaxVoteTextController.text,

                        entryType: entryType.value,
                        reviewApprovePost: isSwitched.value,
                        voteCountToQualify: _contestController.contestvoteCountToQualifyTextController.text,
                        entryAmount: _contestController.entryAmountController.text,
                        numPostPerWeek: _contestController.contestNumberPostsPerWeekTextController.text));
                WayaNav.goBack();
              }
              /*  if (_formKey.currentState!.validate()) {
                ref.read(stateContactProvider.notifier).state = ref
                  .read(stateContactProvider)
                  .where((i) => _contestController.selectedIndex != i.id)
                  .toList();
              ref.read(stateContactProvider.notifier).state.insert(
                  _contestController.selectedIndex,
                  StagePrefModel(
                      id: _contestController.selectedIndex,
                      endDate: endDate.value,
                      stageName: _contestController
                          .contestStageNameTextController.text,
                      startDate: startDate.value,
                      priceWinner: priceWinner.value,
                      entryType: entryType.value,
                      reviewApprovePost: isSwitched.value,
                      entryAmount:
                          _contestController.entryAmountController.text,
                      numPostPerWeek: _contestController
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
              border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
              callback: () {
                WayaNav.goBack();
              })
        ],
      ),
    );
  }
}

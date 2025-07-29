import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';

import '../../../../core/components/waya_buttons.dart';
import '../../../../core/components/waya_select_field.dart';
import '../../../../core/utils/waya_utils.dart';
//import '../../../auth/account_creation/vm/personal_first_step_vm.dart';
import '../../ugt_buttomsheet_modal/ugt_modal.dart';
import '../../vm/ugt_vm.dart';

class ContestTimeline extends StatefulHookConsumerWidget {
  final Function(int) goToPrevTab;
  const ContestTimeline({super.key, required this.goToPrevTab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ContestTimelineState();
}

class _ContestTimelineState extends ConsumerState<ContestTimeline> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    //final viewModel = ref.watch(personalFirstStepProvider);
    final viewModel2 = ref.watch(contestNotifierProvider);
    var contestViewModel = ref.watch(selectedContestProvider.notifier).state;
    final wayaTheme = Theme.of(context);

    var isEditing = ref.watch(stateIsEditingContestProvider);
    useEffect(() {
      if (isEditing) {
        Future.delayed(Duration(seconds: 1), () {
          ref.read(contestNotifierProvider.notifier).updateContestTimeStartDate(
              contestViewModel?.startDate?.split("T").first ?? "");
          ref.read(contestNotifierProvider.notifier).updateContestTimeEndDate(
              contestViewModel?.endDate?.split("T").first ?? "");
          ref
              .read(contestNotifierProvider.notifier)
              .updateContestTimeMultipleStage(
                  contestViewModel?.multipleStages ?? '');

          ref
              .read(contestNotifierProvider.notifier)
              .updateContestTimeCurrentStage(
                  contestViewModel?.currentStage ?? '');
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
          Text("Contest Timeline & Stages",
              style: wayaTheme.textTheme.titleLarge),
          const Gap(5),
          Text(
              "Bring your talent contest vision to life. Customize details,\nset stages, and make it unforgettable",
              style: wayaTheme.textTheme.hintStyle),
          const Gap(15),
          FormField<String>(validator: (value) {
            if (viewModel2.contestTimelineStartDate.isEmpty) {
              return 'Start Date is required';
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
                        .showDateContestStart(context);
                  },
                  child: AbsorbPointer(
                    child: WayaSelectField<String>(
                      height: 0.3,
                      value: viewModel2.contestTimelineStartDate.isEmpty
                          ? 'DD/MM/YYYY'
                          : viewModel2.contestTimelineStartDate,
                      label: "When do you want your contest to start?",
                      hintText: 'Select Start Date',
                      items: ref
                          .read(contestNotifierProvider.notifier)
                          .ugtDurationType(),
                      onSelected: (value) => ref
                          .read(contestNotifierProvider.notifier)
                          .updateContestTimeStartDate(value.first.label),
                      uniqueKey: 'contest-state',
                    ),
                  ),
                ),
                if (formState.hasError &&
                    viewModel2.contestTimelineStartDate.isEmpty)
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
            if (viewModel2.contestTimelineEndDate.isEmpty) {
              return 'End Date is required';
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
                        .showDateContestEnd(context);
                  },
                  child: AbsorbPointer(
                    child: WayaSelectField<String>(
                      height: 0.3,
                      value: viewModel2.contestTimelineEndDate.isEmpty
                          ? 'DD/MM/YYYY'
                          : viewModel2.contestTimelineEndDate,
                      label: "When do you want your contest to end?",
                      hintText: 'Select End Date',
                      items: ref
                          .read(contestNotifierProvider.notifier)
                          .ugtDurationType(),
                      onSelected: (value) => ref
                          .read(contestNotifierProvider.notifier)
                          .updateContestTimeEndDate(value.first.label),
                      uniqueKey: 'contest-state',
                    ),
                  ),
                ),
                if (formState.hasError &&
                    viewModel2.contestTimelineEndDate.isEmpty)
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
            if (viewModel2.contestTimelineMultipleStage.isEmpty) {
              return 'Contest State is required';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaSelectField<String>(
                  height: 0.3,
                  value: viewModel2.contestTimelineMultipleStage,
                  label: "Will your contest have multiple stages?",
                  hintText: 'Select Yes or No',
                  items: ref
                      .read(contestNotifierProvider.notifier)
                      .ugtMultipleStages(),
                  onSelected: (value) {
                    ref
                        .read(contestNotifierProvider.notifier)
                        .updateContestTimeMultipleStage(value.first.label);
                  },
                  uniqueKey: 'contest-state',
                ),
                if (formState.hasError &&
                    viewModel2.contestTimelineMultipleStage.isEmpty)
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
          if (viewModel2.contestTimelineMultipleStage.toLowerCase() != "no")
            FormField<String>(validator: (value) {
              if (viewModel2.contestTimelineCurrentStage.isEmpty) {
                return 'Current Stage is required';
              }

              return null;
            }, builder: (formState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WayaSelectField<String>(
                    height: 0.3,
                    value: viewModel2.contestTimelineCurrentStage,
                    label: "What is the current stage",
                    hintText: 'Select Current Stage',
                    items: ref
                        .read(contestNotifierProvider.notifier)
                        .ugtCurrentStage(),
                    onSelected: (value) {
                      ref
                          .read(contestNotifierProvider.notifier)
                          .updateContestTimeCurrentStage(value.first.label);
                    },
                    uniqueKey: 'contest-state',
                  ),
                  if (formState.hasError &&
                      viewModel2.contestTimelineCurrentStage.isEmpty)
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
          const Gap(60),
          WayaButton(
            callback: () {
              /*  WayaUtils.showModalSheetUgt(
                context,
                child: UgtModal(),
              ); */
              if (viewModel2.contestTimelineMultipleStage.toLowerCase() !=
                  "no") {
                ref
                    .read(contestNotifierProvider.notifier)
                    .updateContestTimeCurrentStage("Nil");
              }
              if (_formKey.currentState!.validate()) {
                WayaUtils.showModalSheetUgt(
                  context,
                  child: UgtModal(),
                );
              }
            },
            text: "Save Contest",
          ),
          const Gap(8),
          WayaButton(
              text: 'Go Back',
              color: wayaTheme.colorScheme.greyColor300,
              textColor: wayaTheme.colorScheme.customBlack,
              border: Border.all(
                  width: 1, color: wayaTheme.colorScheme.greyColor300),
              callback: () {
                widget.goToPrevTab(1);
                // WayaNav.goBack();
                //WayaNav.toNamed("/ugt-home");
              })
        ],
      ),
    );
  }
}

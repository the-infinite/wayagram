import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

import '../../../../core/components/waya_buttons.dart';
import '../../../../core/components/waya_select_field.dart';
import '../../../../core/components/waya_text_form_field.dart';
import '../../../../core/utils/waya_navigation.dart';
import '../../../../core/utils/waya_utils.dart';
import '../../../auth/account_creation/vm/personal_first_step_vm.dart';
import '../../../wallet/view/components/modal_content.dart';
import '../../ugt_buttomsheet_modal/ugt_modal.dart';
import '../../vm/ugt_vm.dart';

class ContestTimeline extends ConsumerStatefulWidget {
  const ContestTimeline({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ContestTimelineState();
}

class _ContestTimelineState extends ConsumerState<ContestTimeline> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(personalFirstStepProvider);
    final viewModel2 = ref.watch(contestNotifierProvider);
    final wayaTheme = Theme.of(context);
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
              "Bring your talent contest vision to life. Customize details,\n set stages, and make it unforgettable",
              style: wayaTheme.textTheme.hintStyle),
          const Gap(30),
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
                    child: WayaSelectField(
                      height: 0.3,
                      value: viewModel2.contestTimelineStartDate.isEmpty
                          ? 'DD/MM/YYYY'
                          : viewModel2.contestTimelineStartDate,
                      label: "Start Date",
                      hintText: 'Select Start Date',
                      items: ref
                          .read(contestNotifierProvider.notifier)
                          .ugtDurationType(),
                      onSelected: (value) => ref
                          .read(contestNotifierProvider.notifier)
                          .updateContestTimeStartDate(value.label),
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
                          color: wayaTheme.colorScheme.error, fontSize: 12),
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
                    child: WayaSelectField(
                      height: 0.3,
                      value: viewModel2.contestTimelineEndDate.isEmpty
                          ? 'DD/MM/YYYY'
                          : viewModel2.contestTimelineEndDate,
                      label: "End Date",
                      hintText: 'Select End Date',
                      items: ref
                          .read(contestNotifierProvider.notifier)
                          .ugtDurationType(),
                      onSelected: (value) => ref
                          .read(contestNotifierProvider.notifier)
                          .updateContestTimeEndDate(value.label),
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
                          color: wayaTheme.colorScheme.error, fontSize: 12),
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
                WayaSelectField(
                  height: 0.3,
                  value: viewModel2.contestTimelineMultipleStage,
                  label: "Multiple Stages?",
                  hintText: 'Select Yes or No',
                  items: ref
                      .read(contestNotifierProvider.notifier)
                      .ugtMultipleStages(),
                  onSelected: (value) {
                    ref
                        .read(contestNotifierProvider.notifier)
                        .updateContestTimeMultipleStage(value.label);
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
                          color: wayaTheme.colorScheme.error, fontSize: 12),
                    ),
                  ),
              ],
            );
          }),
          const Gap(15),
          const Gap(15),
          FormField<String>(validator: (value) {
            if (viewModel2.contestTimelineCurrentStage.isEmpty) {
              return 'Current Stage is required';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaSelectField(
                  height: 0.3,
                  value: viewModel2.contestTimelineCurrentStage,
                  label: "Current Stage",
                  hintText: 'Select Current Stage',
                  items: ref
                      .read(contestNotifierProvider.notifier)
                      .ugtCurrentStage(),
                  onSelected: (value) {
                    ref
                        .read(contestNotifierProvider.notifier)
                        .updateContestTimeCurrentStage(value.label);
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
                          color: wayaTheme.colorScheme.error, fontSize: 12),
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
                Navigator.pop(context);
                //WayaNav.toNamed("/ugt-home");
              })
        ],
      ),
    );
  }
}

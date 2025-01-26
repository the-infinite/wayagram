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

class ContestTimeline extends ConsumerStatefulWidget  {
  const ContestTimeline({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget > createState() => _ContestTimelineState();
}

class _ContestTimelineState extends ConsumerState<ContestTimeline> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(personalFirstStepProvider);
    final viewModel2 = ref.watch(contestNotifierProvider);
    final wayaTheme = Theme.of(context);
    return Column(
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
        FormField<String>(
          validator: (value) {

            return null;
          },
          builder: (formState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select Start Date",
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
                    ref.read(contestNotifierProvider.notifier).showDatePickerDialog(context);
                  },
                  horizontalPadding: 0,
                  color: wayaTheme.colorScheme.transparent,
                  centerWidget: Focus(
                      onFocusChange: (hasFocus) {
                        ref.read(personalFirstStepProvider.notifier).focusChanged(hasFocus);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                viewModel2.startDate.isEmpty
                                    ? 'DD/MM/YYYY'
                                    : viewModel.dateOfBirth,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.wayaCopyWith(
                                  fontSize: 14,
                                  color: viewModel2
                                      .startDate.isEmpty
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
                    viewModel2.startDate.isEmpty)
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
        const Gap(15),
        FormField<String>(
          validator: (value) {

            return null;
          },
          builder: (formState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select End Date",
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
                    ref.read(contestNotifierProvider.notifier).showDatePickerDialogEndDate(context);
                  },
                  horizontalPadding: 0,
                  color: wayaTheme.colorScheme.transparent,
                  centerWidget: Focus(
                      onFocusChange: (hasFocus) {
                        ref.read(contestNotifierProvider.notifier).focusChanged2(hasFocus);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                viewModel2.endDate.isEmpty
                                    ? 'DD/MM/YYYY'
                                    : viewModel.dateOfBirth,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.wayaCopyWith(
                                  fontSize: 14,
                                  color: viewModel2
                                      .endDate.isEmpty
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
                    viewModel2.endDate.isEmpty)
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
        const Gap(15),
        WayaSelectField(
          height: 0.3,
          value: "Yes",
          label: "Multiple Stages?",
          hintText: 'Select Yes or No',
          items: ref
        .read(contestNotifierProvider.notifier)
        .ugtMultipleStages(),
          onSelected: (value) {},
          uniqueKey: 'contest-state',
        ),
        const Gap(15),
        const Gap(15),
        WayaSelectField(
          height: 0.3,
          value: "Stage 1",
          label: "Current Stage",
          hintText: 'Select Current Stage',
          items: ref
              .read(contestNotifierProvider.notifier)
              .ugtCurrentStage(),
          onSelected: (value) {},
          uniqueKey: 'contest-state',
        ),
        const Gap(60),
        WayaButton(
          callback: () {
            WayaUtils.showModalSheetUgt(
              context,
              child: UgtModal(),
            );

          },
          text: "Save Contest",
        ),
        const Gap(8),
        WayaButton(
            text: 'Go Back',
            color: wayaTheme.colorScheme.greyColor300,
            textColor: wayaTheme.colorScheme.customBlack,
            border:
            Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
            callback: () {
              Navigator.pop(context);
              //WayaNav.toNamed("/ugt-home");
            })
      ],
    );
  }
}

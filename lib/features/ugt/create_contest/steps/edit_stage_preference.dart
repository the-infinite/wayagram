import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

import '../../../../core/components/waya_buttons.dart';
import '../../../../core/components/waya_scaffold.dart';
import '../../../../core/components/waya_select_field.dart';
import '../../../../core/components/waya_text_form_field.dart';
import '../../../../core/utils/waya_navigation.dart';
import '../../../auth/account_creation/vm/personal_first_step_vm.dart';
import '../../../shop/widgets/upload_image.dart';
import '../../data/controller/contest_controller.dart';
import 'create_ultimate.dart';

class EditStagePreference extends ConsumerStatefulWidget {
  static const route = '/edit-stage-preference';
  const EditStagePreference({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditStagePreferenceState();
}
bool isSwitched = false;

class _EditStagePreferenceState extends ConsumerState<EditStagePreference> {
  final _contestController = Get.put(ContestController());

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(personalFirstStepProvider);
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
          WayaTextFormField(
            controller: TextEditingController(),
            hintText: "Qualification Stage",
            label: "Stage Name ",
          ),
          const Gap(15),
          WayaSelectField(
            height: 0.3,
            label: "Entry Type ",
            hintText: 'Choose entry type',
            items: [],
            onSelected: (value) {},
            uniqueKey: 'contest-category',
          ),
          const Gap(15),
          WayaTextFormField(
            controller: TextEditingController(),
            hintText: "0 NGN",
            label: "Entry Amount",
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
                      ref.read(personalFirstStepProvider.notifier).showDatePickerDialog(context);
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
                                  viewModel.dateOfBirth.isEmpty
                                      ? 'DD/MM/YYYY'
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
                      ref.read(personalFirstStepProvider.notifier).showDatePickerDialog(context);
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
                                  viewModel.dateOfBirth.isEmpty
                                      ? 'DD/MM/YYYY'
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
          const Gap(15),
          WayaTextFormField(
            controller: TextEditingController(),
            hintText: "E.g 4",
            label: "Number of Posts per week",
          ),
          const Gap(15),
          WayaSelectField(
            height: 0.3,
            label: "Prize for the Winner?",
            hintText: 'Select Yes or No',
            items: [],
            onSelected: (value) {},
            uniqueKey: 'contest-state',
          ),
          const Gap(15),
          WayaTextFormField(
            controller: TextEditingController(),
            hintText: "0 NGN",
            label: "Prize Amount",
          ),
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: wayaTheme.colorScheme.customPrimary
              ),
              const SizedBox(width: 10),
              Text(
                "Review and approve post before going live",
                style: TextStyle(
                  fontSize: 12,
                  color: isSwitched ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
          const Gap(40),
          WayaButton(
            callback: () {

              _contestController.addStage();
              Navigator.pop(context);

            },
            text: "Save Stage Changes",
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
              })
        ],
      ),
    );


  }
}

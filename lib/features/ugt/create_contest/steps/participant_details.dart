import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

import '../../../../core/components/waya_buttons.dart';
import '../../../../core/components/waya_select_field.dart';
import '../../../../core/components/waya_text_form_field.dart';
import '../../../../core/utils/waya_navigation.dart';
import '../../../auth/account_creation/vm/personal_first_step_vm.dart';
import '../../../shop/widgets/upload_image.dart';
import 'create_ultimate.dart';

class ParticipantDetails extends ConsumerStatefulWidget {
  final Function goToNextTab;
  const ParticipantDetails( {super.key, required this.goToNextTab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ParticipantDetailsState();
}

final _formKey = GlobalKey<FormState>();

class _ParticipantDetailsState extends ConsumerState<ParticipantDetails> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(personalFirstStepProvider);
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Participation Details",
            style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text(
            "Bring your talent contest vision to life. Customize details,\n set stages, and make it unforgettable",
            style: wayaTheme.textTheme.hintStyle),
        const Gap(30),
        WayaTextFormField(
          controller: TextEditingController(),
          hintText: "Enter Contest Description",
          label: "How It Works",
          line: 6,
        ),
        const Gap(15),
        WayaSelectField(
          height: 0.3,
          label: "Entry Type",
          hintText: 'Choose entry type',
          items: [],
          onSelected: (value) {},
          uniqueKey: 'contest-state',
        ),
        const Gap(15),
        WayaTextFormField(
          controller: TextEditingController(),
          hintText: "0 NGN",
          label: "Amount",
        ),
        const Gap(15),
        Row(
          children: [
            Expanded(
              child: FormField<String>(validator: (value) {
                if (viewModel.firstName.text.isEmpty) {
                  return 'Duration type is required';
                }

                return null;
              }, builder: (formState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  WayaSelectField(
                  height: 0.3,
                  label: "Duration Type",
                  hintText: 'Select Duration Type',
                  items: [],
                  onSelected: (value) {},
                  uniqueKey: 'contest-state',
                ),
                    if (formState.hasError &&
                        viewModel.firstName.text.isEmpty)
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
                if (viewModel.lastName.text.isEmpty) {
                  return 'Number of duration is required';
                }

                return null;
              }, builder: (formState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WayaTextFormField(
                      keyboardType: TextInputType.name,
                      controller: viewModel.lastName,
                      hintText: 'e.g., 3',
                      borderColor: formState.hasError &&
                          viewModel.lastName.text.isEmpty
                          ? wayaTheme.colorScheme.error
                          : null,
                      label: 'Number of Duration',
                    ),
                    if (formState.hasError &&
                        viewModel.lastName.text.isEmpty)
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
        WayaTextFormField(
          controller: TextEditingController(),
          hintText: "Enter Contest Description",
          label: "Contest Description",
          line: 6,
        ),


        const Gap(60),
        WayaButton(
          callback: () {

          },
          text: "Continue",
        ),
        const Gap(8),
        WayaButton(
            text: 'Go Back',
            color: wayaTheme.colorScheme.greyColor300,
            textColor: wayaTheme.colorScheme.customBlack,
            border:
            Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
            callback: () {
              WayaNav.toNamed("/ugt-home");
            })
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import '../../../../core/components/waya_buttons.dart';
import '../../../../core/components/waya_select_field.dart';
import '../../../../core/components/waya_text_form_field.dart';
import '../../../auth/account_creation/vm/personal_first_step_vm.dart';
import '../../vm/ugt_vm.dart';

class AddNewRequirementModal extends ConsumerStatefulWidget {
  const AddNewRequirementModal({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddNewRequirementModalState();
}
bool isSwitched = false;
class _AddNewRequirementModalState extends ConsumerState<AddNewRequirementModal> {



  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(personalFirstStepProvider);
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Add New Requirements",
                style: wayaTheme.textTheme.bodyMedium),
            SizedBox(height: 3.h),
            const Gap(20),
            WayaSelectField(
              height: 0.3,
              value: "TEXT",
              label: "Requirement Type ",
              hintText: 'Requirement type',
              items: ref
                  .read(contestNotifierProvider.notifier)
                  .ugtRequirementType(),
              onSelected: (value) => ref
                  .read(contestNotifierProvider.notifier).selectState(value),
              uniqueKey: 'contest-category',
            ),
            const Gap(15),
            WayaTextFormField(
              controller: TextEditingController(),
              hintText: "Enter Requirement Name",
              label: "Enter requirement name ",
            ),
            const Gap(15),
            WayaTextFormField(
              controller: TextEditingController(),
              hintText: "Enter text field label",
              label: " Text Field (optional) ",
            ),
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
                  "Mark as Required",
                  style: TextStyle(
                    fontSize: 12,
                    color: isSwitched ? wayaTheme.colorScheme.primaryContainer :  wayaTheme.colorScheme.greyColor900,
                  ),
                ),
              ],
            ),
            const Gap(15),
            SizedBox(height: 17.h),
            WayaButton(
              callback: () async{
                //WayaNav.toNamed("/contest-setting-content");
              },
              text: "Add Requirement",
            ),
            const Gap(10),
            WayaButton(
                text: 'Go Back',
                color: wayaTheme.colorScheme.greyColor300,
                textColor: wayaTheme.colorScheme.customBlack,
                border:
                Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
                callback: () {

                })
          ],
        ),
      ),
    );
  }
}

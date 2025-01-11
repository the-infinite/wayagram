import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import '../../../../core/components/waya_buttons.dart';
import '../../../../core/components/waya_select_field.dart';
import '../../../../core/components/waya_text_form_field.dart';

class AddNewRequirementModal extends StatefulWidget {
  const AddNewRequirementModal({super.key});

  @override
  State<AddNewRequirementModal> createState() => _AddNewRequirementModalState();
}
bool isSwitched = false;
class _AddNewRequirementModalState extends State<AddNewRequirementModal> {
  @override
  Widget build(BuildContext context) {
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
              label: "Requirement Type ",
              hintText: 'Requirement type',
              items: [],
              onSelected: (value) {},
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
                    color: isSwitched ? Colors.black : Colors.grey,
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

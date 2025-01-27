import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/shared/radio_select.dart';
import 'package:wayagram/features/ugt/contest_setting/steps/Add_new_requirement_modal.dart';
import 'package:wayagram/features/ugt/data/controller/contest_controller.dart';
import 'package:wayagram/features/ugt/ugt_buttomsheet_modal/successful_modal.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import '../../../../core/components/waya_buttons.dart';
import '../../../../core/components/waya_select_field.dart';
import '../../../../core/components/waya_text_form_field.dart';
import '../../../../core/utils/waya_navigation.dart';
import '../../../../core/utils/waya_utils.dart';
import '../../../auth/account_creation/view/loading_state.dart';
import '../../../auth/account_creation/vm/personal_first_step_vm.dart';
import '../../create_contest/steps/create_ultimate.dart';
import '../../create_contest/steps/edit_stage_preference.dart';

class ContestSignupRequirement extends ConsumerStatefulWidget {
  final VoidCallback goToNextTab;
  const ContestSignupRequirement({super.key, required this.goToNextTab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContestSignupRequirementState();
}
bool isSwitched = false;



class _ContestSignupRequirementState extends ConsumerState<ContestSignupRequirement> {
  List<dynamic> stages = [];
  final _contestController = Get.put(ContestController());

  void _addStage() {
    setState(() {
      stages.add('Document ${stages.length}');
    });
  }

  void _removeStage(int index) {
    setState(() {
      _contestController.removeContestSignUpRequirement(index);
      stages.removeAt(index);
    });
  }

  String selectedValue = '';



  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(personalFirstStepProvider);
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Contest sign up requirement",
            style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text(
            "configure what are the requirements of the applicants during application and decide if each requirement is mandatory or optional",
            style: wayaTheme.textTheme.hintStyle),
        const Gap(30),

        WayaTextFormField(
          controller: TextEditingController(),
          hintText: "Enter Full Name",
          label: null,
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
        WayaTextFormField(
          controller: TextEditingController(),
          hintText: "Email Address",
          label: null,
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
        WayaTextFormField(
          controller: TextEditingController(),
          hintText: "Phone number",
          label: null,
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
        WayaTextFormField(
          controller: TextEditingController(),
          hintText: "Address",
          label: null,
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
        const Gap(5),
        Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 0),
              itemCount: stages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.rectangle,
                        ),
                        child: IconButton(

                          icon: Image.asset('assets/images/destructive.png',width: 30, height: 30, ),
                          //Icon(Icons.remove_circle, color: Colors.red),
                          //SvgPicture.asset('assets/images/destructive.png'),
                          //,
                          onPressed: () => _removeStage(index),
                        ),
                      ),


                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text((index >= 0 &&
                          index <
                              _contestController
                              .contestSignUpRequirement.length)
                              ? _contestController
                              .contestSignUpRequirement [index]
                              ["requirementType"]
                              : stages[index], style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                              IconButton(
                                icon: Image.asset('assets/images/icon-right.png',width: 20, height: 20, ),
                                //Icon(Icons.edit, color: Colors.grey),
                                onPressed: ( ) => {
                                WayaUtils.showModalSheetUgt(
                                context,
                                child: AddNewRequirementModal(),
                                ),
                                 // WayaNav.toNamed("/edit-stage-preference"),
                                },
                              ),


                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                );

                /*Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeStage(index),
                    ),
                    title: Text(stages[index]),
                    trailing: Icon(Icons.edit),
                  ),
                );*/
              },
            ),
            RadioSelect(
                title: Container(
                    padding: EdgeInsets.fromLTRB(0, 1, 0, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Mark as Required", style: wayaTheme.textTheme.hintStyle),
                        const Gap(0),

                      ],
                    )),
                value: "Mark", groupValue: selectedValue, onChanged: (String? value) {
              setState(() {
                selectedValue = ((selectedValue == value) ? "" : value)!;
                // Update selected value
              });
            },),
            TextButton(
              onPressed: _addStage,
              child: Text('+ Add Another Stage', style: TextStyle(color: Colors.red)),
            ),
            SizedBox(height: 20),
          ],
        ),
        const Gap(15),

        WayaButton(
            centerWidget: LoadingState(
                loading: viewModel.isLoading, text: 'Continue'),
            callback: !viewModel.isLoading
                ? () {
              ref.read(contestNotifierProvider.notifier).onSubmit();
              //   provider.submit(context, widget.isWayagramDeal);
            }
                : null),

       /* WayaButton(
          callback: () {




            WayaUtils.showModalSheetUgt(
              context,
              child: SuccessfulModal(),
            );
          },
          text: "Continue",
        ),*/
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
    );
  }
  }

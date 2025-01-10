import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/ugt/create_contest/steps/edit_stage_preference.dart';

import '../../../../core/components/waya_buttons.dart';
import '../../../../core/components/waya_select_field.dart';
import '../../../../core/utils/waya_navigation.dart';
import '../../../auth/account_creation/vm/personal_first_step_vm.dart';

class StageContestSettings extends ConsumerStatefulWidget {
  const StageContestSettings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StageContestSettingsState();
}



class _StageContestSettingsState extends ConsumerState<StageContestSettings> {

  List<String> stages = ['Qualification Stage', 'Contest 1', 'Contest 2', 'Contest 3', 'Contest 4'];

  void _addStage() {
    setState(() {
      stages.add('Contest ${stages.length}');
    });
  }

  void _removeStage(int index) {
    setState(() {
      stages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(personalFirstStepProvider);
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Stage Settings",
            style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text(
            "Configure each stage settings and modify it \n as you see fit",
            style: wayaTheme.textTheme.hintStyle),
        const Gap(30),
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

                          icon: Icon(Icons.remove_circle, color: Colors.red),
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
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(stages[index], style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.grey),
                                onPressed: ( ) => Navigator.push(context, MaterialPageRoute(builder: (c) => EditStagePreference())),
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
            TextButton(
              onPressed: _addStage,
              child: Text('+ Add Another Stage', style: TextStyle(color: Colors.red)),
            ),
            SizedBox(height: 20),
          ],
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

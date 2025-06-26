import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/model/stage_pref_model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import '../../../../core/utils/waya_navigation.dart';
import '../../data/controller/contest_controller.dart';

class StageContestSettings extends StatefulHookConsumerWidget {
  final VoidCallback goToNextTab;
  const StageContestSettings({super.key, required this.goToNextTab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StageContestSettingsState();
}

class _StageContestSettingsState extends ConsumerState<StageContestSettings> {
  final _contestController = Get.put(ContestController());
  List<Map<String, dynamic>> stages = [];

  @override
  void initState() {
    super.initState();
  }

//   void _addStage() {
//     debugPrint(
//         'i dey ghhhhhhhh ${ref.read(contestNotifierProvider.notifier).getEditStageList()}');
//     ref
//         .read(contestNotifierProvider.notifier)
//         .updateEditStagePrefListValue(StagePrefModel(id: 1));
//     /* setState(() {
//       stages.add({"id": stages.length + 1, "stageName": "Stage Name"});
//     }); */
//   }

  void _removeStage(int index) {
    ref.read(stateContactProvider.notifier).state.removeAt(index);
    ref.read(stateContactProvider.notifier).state = [...ref.read(stateContactProvider.notifier).state];
    /*  setState(() {
      _contestController.removeStage(index);
      stages.removeAt(index);
    }); */
  }

  @override
  Widget build(BuildContext context) {
    // final viewModel = ref.watch(personalFirstStepProvider);
    // final viewModel2 = ref.watch(contestNotifierProvider);
    final viewModel3 = ref.watch(stateContactProvider);
    final wayaTheme = Theme.of(context);
    var contestViewModel = ref.watch(selectedContestProvider.notifier).state;

    var isEditing = ref.watch(stateIsEditingContestProvider);
    useEffect(() {
      if (isEditing) {
        Future.delayed(Duration(seconds: 1), () {
          int index = 0;
          ref.read(stateContactProvider.notifier).state = [
            ...contestViewModel?.contestSettings?.stages
                    ?.map((e) => StagePrefModel(
                          id: index++,
                          stageName: e.stageName,
                          entryType: e.entryType,
                          maxVote: e.maxVote,
                          entryAmount: e.entryAmount.toString(),
                          numPostPerWeek: e.numberOfPostPerWeek.toString(),
                          startDate: e.startDate?.split("T").first ?? "",
                          endDate: e.endDate?.split("T").first ?? "",
                          priceWinner: e.priceOfTheWinner.toString(),
                          voteCountToQualify: e.voteCountToQualify.toString(),
                          reviewApprovePost: e.approveBeforeLive ?? false,
                        ))
                    .toList() ??
                []
          ];
        });
      }
      return null;
    }, []);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Stage Settings", style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text("Configure each stage settings and modify it \n as you see fit", style: wayaTheme.textTheme.hintStyle),
        const Gap(30),
        Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              padding: EdgeInsets.symmetric(vertical: 0),
              itemCount: viewModel3.length,
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
                          icon: Image.asset(
                            'assets/images/destructive.png',
                            width: 30,
                            height: 30,
                          ),
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
                              Text(
                                  ref.read(stateContactProvider.notifier).state[index].stageName.toString()
                                  /*  index >= 0 &&
                                          index <
                                              _contestController
                                                  .contestStages.length)
                                      ? _contestController.contestStages[index]
                                          ["stageName"]
                                      : stages[index] */
                                  ,
                                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[700])),
                              IconButton(
                                icon: Image.asset(
                                  'assets/images/icon-right.png',
                                  width: 20,
                                  height: 20,
                                ),
                                //Icon(Icons.edit, color: Colors.grey),
                                onPressed: () {
                                  _contestController.selectedIndex = index;
                                  WayaNav.toNamed("/edit-stage-preference");
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
            TextButton(
              onPressed: () {
                //int id = ref.read(stateContactProvider.notifier).state.length;
                ref.read(stateContactProvider.notifier).state = [
                  ...ref.read(stateContactProvider),
                  StagePrefModel(
                    stageName: "Contest",
                    id: ref.read(stateContactProvider.notifier).state.length,
                  )
                ];

                /*  ref
                    .read(contestNotifierProvider.notifier)
                    .updateEditStagePrefListValue(StagePrefModel(id: 1)); */
              },
              child: Text('+ Add Another Stage', style: TextStyle(color: Colors.red)),
            ),
            SizedBox(height: 20),
          ],
        ),
        const Gap(60),
        WayaButton(
          callback: () async {
            //  widget.goToNextTab();
            if (ref.read(stateContactProvider.notifier).state.isEmpty) {
              WayaSnackBar.showToast('Minimum of a stage required');
              return;
            }
            StagePrefModel? model1;
            for (var model in ref.read(stateContactProvider.notifier).state) {
              if (model.stageName!.trim().isEmpty ||
                  model.entryAmount!.trim().isEmpty ||
                  model.numPostPerWeek!.trim().isEmpty) {
                model1 = model;
              }
            }

            if (model1 == null) {
              widget.goToNextTab();
            } else {
              WayaSnackBar.showToast('Please make sure all stages are filled');
            }
          },
          text: "Continue",
        ),
        const Gap(8),
        WayaButton(
            text: 'Go Back',
            color: wayaTheme.colorScheme.greyColor300,
            textColor: wayaTheme.colorScheme.customBlack,
            border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
            callback: () {
              debugPrint("stages  ${_contestController.contestStages.toString()}");
              WayaNav.goBack();
            })
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/vm/activity_logs_vm.dart';
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

import '../data/model/user_interaction_model.dart';
import '../widget/activity_image_widget.dart';

class UserInteraction extends ConsumerStatefulWidget {
  static const route = '/userInteraction';
  const UserInteraction ({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserInteractionState();
}

class _UserInteractionState extends ConsumerState<UserInteraction > {

  List<String> dates = [];
  late ValueNotifier<String> status = ValueNotifier('All Status');

  bool s1 = true, s2 = false, s3 = false, s4 = false, s5 = false;
  @override
  Widget build(BuildContext context) {

    final viewModel = ref.watch(activityLogsVmProvider);
    return WayaScaffold(
      backgroundColor: WayaColors.greyColor50,
      title: "User Interactions    ",
      isLoading: false,
      isScrollable: false,
      body: Column(
        spacing:10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(10),
          InkWell(
            //onTap: ()=> showStatus(),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: WayaColors.greyColor300),
                borderRadius: BorderRadius.circular(6),
              ),
              width: 102.w,
              height: 36.h ,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'All Time',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: WayaConstants.fontFamily,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                  Gap(10),
                  SvgPicture.asset('assets/icons/down_arrow.svg')
                ],
              ),
            ),
          ),
          Gap(10),
          Expanded(
            child: PaginatedDataView<UserInteractionDocs>(
                uniqueKey: 'user-interactions',
                loadingState: SizedBox(
                    height: context.height * 0.4,
                    child: Center(
                      child: CircularProgressIndicator(),
                    )),
                emptyState:ActivityLogsEmptyState(text: 'You don\'t have user interactions yet',),
                fetchData: ref.read(activityLogsVmProvider.notifier).getUserInteraction,
                result: (data, s) {
                  for(int i = 0; i < viewModel.userInteractionDocs.length; i++){
                    if(!dates.contains(viewModel.userInteractionDocs[i].createdAt.toString().split('T')[0])){
                      dates.add(viewModel.userInteractionDocs[i].createdAt.toString().split('T')[0]);
                      viewModel.userInteractionDocs.add(viewModel.userInteractionDocs[i]);
                    }
                  }
                  return SingleChildScrollView(
                    child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 80.h, top: 0),
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: dates.length,
                        itemBuilder: (context, i){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${ref.read(createPollVotingProvider.notifier).formatDt(viewModel.userInteractionDocs[i].createdAt.toString().split('T')[0])}',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontFamily: WayaConstants.fontFamily,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  )),
                              Gap(10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                padding: EdgeInsets.only(bottom: 20.h, top: 0),
                                itemCount: viewModel.userInteractionDocs.length,
                                itemBuilder: (context, index){
                                  final userInteraction = viewModel.userInteractionDocs[index];
                                  String dateTimeString = "${userInteraction.createdAt}";
                                  DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                                  if(viewModel.userInteractionDocs[index].createdAt.toString().split('T')[0] == dates[i]){
                                    return ActivityImageWidget(
                                      title: '${userInteraction.description}',
                                      subTitle: '${ref.read(createPollVotingProvider.notifier).formatDt2(userInteraction.createdAt)}, '
                                          '${DateFormat.jm().format(dateTime)}', image: userInteraction.description!.contains('liked')?
                                    'assets/icons/like.svg':userInteraction.description!.contains('message')?'assets/icons/comment.svg':
                                    userInteraction.description!.contains('shared')?'assets/icons/share.svg':'assets/icons/followed.svg'
                                    );
                                  }else{
                                    return Container();
                                  }
                                },
                              )
                            ],
                          );
                        }),
                  );
                }),
          ),

        ],
      ),
    );
  }
  showStatus() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )
                    ),
                    child: Wrap(
                      runSpacing: 16,
                      children: [
                        //MainClass.sheetHead('Select Status', '', context),
                        Gap(12),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        s1 = true;
                                        s2 = false;
                                        s3 = false;
                                        s4 = false;
                                        s5 = false;
                                      });
                                    },
                                    child: saveCard1('All Status', s1),
                                  ),
                                  Gap(12),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        s1 = false;
                                        s2 = true;
                                        s3 = false;
                                        s4 = false;
                                        s5 = false;
                                      });
                                    },
                                    child: saveCard1('Successful', s2),
                                  ),
                                  Gap(12),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        s1 = false;
                                        s2 = false;
                                        s3 = true;
                                        s4 = false;
                                        s5 = false;
                                      });
                                    },
                                    child: saveCard1('Pending', s3),
                                  ),
                                ],
                              ),
                            ),
                            Gap(12),
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        s1 = false;
                                        s2 = false;
                                        s3 = false;
                                        s4 = true;
                                        s5 = false;
                                      });
                                    },
                                    child:saveCard1('Failed', s4),
                                  ),
                                  Gap(12),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        s1 = false;
                                        s2 = false;
                                        s3 = false;
                                        s4 = false;
                                        s5 = true;
                                      });
                                    },
                                    child: saveCard1('Reversed', s5),
                                  ),
                                ],
                              ),
                            ),
                            Gap(24),
                            WayaButton(
                              callback:(){
                                Navigator.pop(context);
                                setState((){
                                  if(s1){
                                    status.value = 'All Status';
                                  } else if(s2){
                                    status.value = 'Successful';
                                  } else if(s3){
                                    status.value = 'Pending';
                                  } else if(s4){
                                    status.value = 'Failed';
                                  } else if(s5){
                                    status.value = 'Reversed';
                                  }
                                });
                              }, height: 30,
                              text: 'Continue',
                              //isLoading: viewModel.isLoading,
                              horizontalPadding: 12,
                              textStyle: WayaTextStyles.bodySmall.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.white ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          );
        });
  }

  static saveCard1(s, chk) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: chk ? WayaColors.primary : WayaColors.greyColor300,
      ),
      child: chk ?  Text(
          s,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          )) :  Text(
    s,
    style: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: WayaColors.greyColor300,
    )),
    );
  }

}

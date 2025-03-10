
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
import 'package:wayagram/features/activity_logs/data/model/payment_activity_model.dart';
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

  List<PaymentActivityDocs> activityLogs = [];
  List<PaymentActivityDocs> activityLogs1 = [];

  int transLength = 0;

  String selTransact = 'All Time';
  var lsTransact = ['All Time', 'This week', 'This month', 'This Year'];

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
          Container(
            alignment: Alignment.center,
            width: 102.w,
            height: 36.h ,
            padding: const EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                border: Border.all(color: WayaColors.greyColor300)),
            child: DropdownButton(
                underline: Container(),
                borderRadius: BorderRadius.circular(8),
                elevation: 4,
                padding: EdgeInsets.zero,
                iconSize: 12,
                icon: SvgPicture.asset('assets/icons/down_arrow.svg'),
                isDense: true,
                isExpanded: false,
                value: selTransact,
                items: lsTransact.map((String ls){
                  return DropdownMenuItem(
                    value: ls,
                    child: Text(ls,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: WayaConstants.fontFamily,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                  );
                }).toList(),
                onChanged: (String? value){
                  setState(() {
                    selTransact = value!;
                    sortList(selTransact.toLowerCase());
                  });
                }
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
                                  )
                              ),
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
  sortList(s) {
    activityLogs = [];
    setState(() {
      if(s == 'All Time'){
        activityLogs = activityLogs1;
      } else {
        for (int i = 0; i < transLength; i++) {
          if (s.toString().trim() == activityLogs1[i].createdAt.toString()) {
            activityLogs.add(activityLogs1[i]);
          }
        }
      }
    });
  }

}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/data/model/payment_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/activity_logs.dart';
import 'package:wayagram/features/activity_logs/vm/activity_logs_vm.dart';
import 'package:wayagram/features/activity_logs/widget/activity_image_widget.dart';
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

import '../widget/activity_card_widget.dart';

class PaymentActivity extends ConsumerStatefulWidget {
  static const route = '/paymentActivity';
  const PaymentActivity({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaymentActivityState();
}

class _PaymentActivityState extends ConsumerState<PaymentActivity> {

  List<String> dates = [];

  // List<ActivityLogs> activityLogs = [];
  // List<ActivityLogs> activityLogs1 = [];
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
      title: "Payment Activity    ",
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
            child: PaginatedDataView<PaymentActivityDocs>(
                uniqueKey: 'payment-activity',
                loadingState: SizedBox(
                    height: context.height * 0.4,
                    child: Center(
                      child: CircularProgressIndicator(),
                    )),
                emptyState:ActivityLogsEmptyState(text: 'You don\'t have payment activity yet',),
                fetchData: ref.read(activityLogsVmProvider.notifier).getPaymentActivity,
                result: (data, s) {

                  for(int i = 0; i < viewModel.paymentActivityDocs.length; i++){
                    if(!dates.contains(viewModel.paymentActivityDocs[i].createdAt.toString().split('T')[0])){
                      dates.add(viewModel.paymentActivityDocs[i].createdAt.toString().split('T')[0]);
                      viewModel.paymentActivityDocs.add(viewModel.paymentActivityDocs[i]);
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
                                  '${ref.read(createPollVotingProvider.notifier).formatDt(viewModel.paymentActivityDocs[i].createdAt.toString().split('T')[0])}',
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
                                itemCount: viewModel.paymentActivityDocs.length,
                                itemBuilder: (context, index){
                                  final paymentActivity = viewModel.paymentActivityDocs[index];
                                  String dateTimeString = "${paymentActivity.createdAt}";
                                  DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                                  if(viewModel.paymentActivityDocs[index].createdAt.toString().split('T')[0] == dates[i]){
                                    return ActivityCardWidget(
                                      title: '${paymentActivity.description}',
                                      subTitle: '${ref.read(createPollVotingProvider.notifier).formatDt2(paymentActivity.createdAt)}, '
                                          '${DateFormat.jm().format(dateTime)}',
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

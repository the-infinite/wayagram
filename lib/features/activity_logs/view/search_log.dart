
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/data/model/payment_activity_model.dart';
import 'package:wayagram/features/activity_logs/vm/activity_logs_vm.dart';
import 'package:wayagram/features/activity_logs/widget/activity_card_widget.dart';
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

import '../data/model/search_log_model.dart';
import '../widget/activity_image_widget.dart';

class SearchLog extends ConsumerStatefulWidget {
  static const route = '/searchLog';
  const SearchLog({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchLogState();
}

class _SearchLogState extends ConsumerState<SearchLog> {

  List<String> dates = [];

  String selTransact = 'All Time';
  var lsTransact = ['All Time', 'This week', 'This month', 'This Year'];

  @override
  Widget build(BuildContext context) {

    final viewModel = ref.watch(activityLogsVmProvider);
    return WayaScaffold(
      backgroundColor: WayaColors.greyColor50,
      title: "Search Logs    ",
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
                icon: SvgPicture.asset(WayaAssets.icons.downArrow.path,),
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
            child: PaginatedDataView<SearchLogDocs>(
                uniqueKey: 'search-logs',
                loadingState: SizedBox(
                    height: context.height * 0.4,
                    child: Center(
                      child: CircularProgressIndicator(),
                    )),
                emptyState:ActivityLogsEmptyState(text: 'You don\'t have search logs yet',),
                fetchData: ref.read(activityLogsVmProvider.notifier).getSearchLog,
                result: (data, s) {

                  for(int i = 0; i < viewModel.searchLogDocs.length; i++){
                    if(!dates.contains(viewModel.searchLogDocs[i].createdAt.toString().split('T')[0])){
                      dates.add(viewModel.searchLogDocs[i].createdAt.toString().split('T')[0]);
                      viewModel.searchLogDocs.add(viewModel.searchLogDocs[i]);
                    }
                  }
                  return SingleChildScrollView(
                    child: viewModel.searchLogDocs.isEmpty ?
                    ActivityLogsEmptyState(text: 'You don\'t have Search Logs for this week yet',):
                    ListView.builder(
                        padding: EdgeInsets.only(bottom: 80.h, top: 0),
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: dates.length,
                        itemBuilder: (context, i){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${ref.read(createPollVotingProvider.notifier).formatDt(viewModel.searchLogDocs[i].createdAt.toString().split('T')[0])}',
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
                                itemCount: viewModel.searchLogDocs.length,
                                itemBuilder: (context, index){
                                  final searchLog = viewModel.searchLogDocs[index];
                                  String dateTimeString = "${searchLog.createdAt}";
                                  DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                                  if(viewModel.searchLogDocs[index].createdAt.toString().split('T')[0] == dates[i]){
                                    return ActivityImageWidget(
                                      title: '${searchLog.description}',
                                      subTitle: '${ref.read(createPollVotingProvider.notifier).formatDt2(searchLog.createdAt)}, '
                                          '${DateFormat.jm().format(dateTime)}', image: 'assets/icons/search.svg'
                                      ,);
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
    final viewModel = ref.watch(activityLogsVmProvider);
    viewModel.searchLogDocs = [];
    print('ACTIVITY End ====> $s');
    setState(() {
      if(s == 'all time'){
        viewModel.searchLogDocs = viewModel.searchLogDocs1;
      }else if(s =='this week'){
        int w = 7 - DateTime.now().weekday; // counting forward

        int y = 7 - w; // counting backward

        List<String> allWeekDays = [];

        for (int i = 0; i < w; i++) {
          String a = DateTime.now().add(Duration(days: i)).toString().split(' ')[0];
          String b = a.split('-')[2];
          allWeekDays.add(b.padLeft(2,'0'));
          print('AAAA $b');
        }

        for (int i = 0; i < y; i++) {
          String a = DateTime.now().subtract(Duration(days: i +1)).toString().split(' ')[0];
          String b = a.split('-')[2];
          allWeekDays.add(b.padLeft(2,'0'));
          print('AAAABBBBB $b');
        }

        print('WeekDAY $w');
        for (int i = 0; i < viewModel.searchLogDocs1.length; i++) {
          String week = viewModel.searchLogDocs1[i].createdAt.toString().split('T')[0];
          if (allWeekDays.contains(week.split('-')[2]) ) {
            viewModel.searchLogDocs.add(viewModel.searchLogDocs1[i]);
          }
        }
        print('ACTIVIVBVB ${viewModel.searchLogDocs.length}');
      } else if(s =='this month'){
        String m =  DateTime.now().month.toString().padLeft(2,'0');
        for (int i = 0; i < viewModel.searchLogDocs1.length; i++) {
          String month = viewModel.searchLogDocs1[i].createdAt.toString().split('T')[0];
          if (m == month.split('-')[1]) {
            viewModel.searchLogDocs.add(viewModel.searchLogDocs1[i]);
          }
        }
      } else if(s =='this year'){
        String y =  DateTime.now().year.toString();
        for (int i = 0; i < viewModel.searchLogDocs1.length; i++) {
          String month = viewModel.searchLogDocs1[i].createdAt.toString().split('T')[0];
          if (y == month.split('-')[0]) {
            viewModel.searchLogDocs.add(viewModel.searchLogDocs1[i]);
          }
        }
      } else {
        for (int i = 0; i < viewModel.searchLogDocs1.length; i++) {
          if (s.toString().trim() == viewModel.searchLogDocs1[i].createdAt.toString()) {
            viewModel.searchLogDocs.add(viewModel.searchLogDocs1[i]);
          }
        }
      }
    });
  }
}

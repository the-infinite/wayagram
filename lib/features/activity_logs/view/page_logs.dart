import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/data/model/page_activity_model.dart';
import 'package:wayagram/features/activity_logs/vm/activity_logs_vm.dart';
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';


import '../widget/activity_card_widget.dart';

class PageLogs extends ConsumerStatefulWidget {
  static const route = '/pageLogs';
  const PageLogs ({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PageLogsState();
}

class _PageLogsState extends ConsumerState<PageLogs > {
  List<String> dates = [];

  String selTransact = 'All Time';
  var lsTransact = ['All Time', 'This week', 'This month', 'This Year'];

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(activityLogsVmProvider);
    return WayaScaffold(
      backgroundColor: WayaColors.greyColor50,
      title: "Pages    ",
      isLoading: false,
      isScrollable: false,
      body: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(10),
          Container(
            alignment: Alignment.center,
            width: 102.w,
            height: 36.h,
            padding: const EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), border: Border.all(color: WayaColors.greyColor300)),
            child: DropdownButton(
                underline: Container(),
                borderRadius: BorderRadius.circular(8),
                elevation: 4,
                padding: EdgeInsets.zero,
                iconSize: 12,
                icon: SvgPicture.asset(
                  WayaAssets.icons.downArrow.path,
                ),
                isDense: true,
                isExpanded: false,
                value: selTransact,
                items: lsTransact.map((String ls) {
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
                onChanged: (String? value) {
                  setState(() {
                    selTransact = value!;
                    sortList(selTransact.toLowerCase());
                  });
                }),
          ),
          Gap(10),
          Expanded(
            child: PaginatedDataView<PageDocs>(
                uniqueKey: 'page',
                loadingState: SizedBox(
                    height: context.height * 0.4,
                    child: Center(
                      child: CircularProgressIndicator(),
                    )),
                emptyState: ActivityLogsEmptyState(
                  text: 'You don\'t have Pages yet',
                ),
                fetchData: ref.read(activityLogsVmProvider.notifier).getPageLogs,
                result: (data, s) {
                  for (int i = 0; i < viewModel.pageDocs.length; i++) {
                    if (!dates.contains(viewModel.pageDocs[i].createdAt.toString().split('T')[0])) {
                      dates.add(viewModel.pageDocs[i].createdAt.toString().split('T')[0]);
                      viewModel.pageDocs.add(viewModel.pageDocs[i]);
                    }
                  }
                  return SingleChildScrollView(
                    child: viewModel.pageDocs.isEmpty
                        ? ActivityLogsEmptyState(
                      text: 'You don\'t have Page for this week yet',
                    )
                        : ListView.builder(
                        padding: EdgeInsets.only(bottom: 80.h, top: 0),
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: dates.length,
                        itemBuilder: (context, i) {

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${ref.read(createPollVotingProvider.notifier).formatDt(dates[i])}',
                                  //'${ref.read(createPollVotingProvider.notifier).formatDt(viewModel.pageDocs[i].createdAt.toString().split('T')[0])}',
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
                                itemCount: viewModel.pageDocs.length,
                                itemBuilder: (context, index) {
                                  final page = viewModel.pageDocs[index];
                                  String dateTimeString = "${page.createdAt}";
                                  DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                                  if (viewModel.pageDocs[index].createdAt.toString().split('T')[0] == dates[i]) {
                                    return ActivityCardWidget(
                                      title: '${page.description}',
                                      subTitle:
                                      '${ref.read(createPollVotingProvider.notifier).formatDt2(page.createdAt)}, '
                                          '${DateFormat.jm().format(dateTime)}',
                                    );
                                  } else {
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
    viewModel.pageDocs = [];
    debugPrint('ACTIVITY End ====> $s');
    setState(() {
      if (s == 'all time') {
        viewModel.pageDocs = viewModel.pageDocs1;
      } else if (s == 'this week') {
        int w = 7 - DateTime.now().weekday; // counting forward

        int y = 7 - w; // counting backward

        List<String> allWeekDays = [];

        for (int i = 0; i < w; i++) {
          String a = DateTime.now().add(Duration(days: i)).toString().split(' ')[0];
          String b = a.split('-')[2];
          allWeekDays.add(b.padLeft(2, '0'));
          debugPrint('AAAA $b');
        }

        for (int i = 0; i < y; i++) {
          String a = DateTime.now().subtract(Duration(days: i + 1)).toString().split(' ')[0];
          String b = a.split('-')[2];
          allWeekDays.add(b.padLeft(2, '0'));
          debugPrint('?? $b');
        }

        debugPrint('WeekDAY $w');
        for (int i = 0; i < viewModel.pageDocs1.length; i++) {
          String week = viewModel.pageDocs1[i].createdAt.toString().split('T')[0];
          if (allWeekDays.contains(week.split('-')[2])) {
            viewModel.pageDocs.add(viewModel.pageDocs1[i]);
          }
        }
        debugPrint('??? ${viewModel.pageDocs.length}');
      } else if (s == 'this month') {
        String m = DateTime.now().month.toString().padLeft(2, '0');
        for (int i = 0; i < viewModel.pageDocs1.length; i++) {
          String month = viewModel.pageDocs1[i].createdAt.toString().split('T')[0];
          if (m == month.split('-')[1]) {
            viewModel.pageDocs.add(viewModel.pageDocs1[i]);
          }
        }
      } else if (s == 'this year') {
        String y = DateTime.now().year.toString();
        for (int i = 0; i < viewModel.pageDocs1.length; i++) {
          String month = viewModel.pageDocs1[i].createdAt.toString().split('T')[0];
          if (y == month.split('-')[0]) {
            viewModel.pageDocs.add(viewModel.pageDocs1[i]);
          }
        }
      } else {
        for (int i = 0; i < viewModel.pageDocs1.length; i++) {
          if (s.toString().trim() == viewModel.pageDocs1[i].createdAt.toString()) {
            viewModel.pageDocs.add(viewModel.pageDocs1[i]);
          }
        }
      }
    });
  }
}

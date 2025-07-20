

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/data/model/account_activity_model.dart';
import 'package:wayagram/features/activity_logs/vm/activity_logs_vm.dart';
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

import '../widget/activity_card_widget.dart';
class AccountActivity extends ConsumerStatefulWidget {
  static const route = '/AccountActivity';
  const AccountActivity({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginActivityState();
}

class _LoginActivityState extends ConsumerState<AccountActivity> {

  List<String> dates = [];

  String selTransact = 'All Time';
  var lsTransact = ['All Time', 'This week', 'This month', 'This Year'];


  @override
  Widget build(BuildContext context) {

    final viewModel = ref.watch(activityLogsVmProvider);
    return WayaScaffold(
      backgroundColor: WayaColors.greyColor50,
      title: "Account    ",
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
            child: PaginatedDataView<AccountActivityDocs>(
                uniqueKey: 'account-activity',
                loadingState: SizedBox(
                    height: context.height * 0.4,
                    child: Center(
                      child: CircularProgressIndicator(),
                    )),
                emptyState:ActivityLogsEmptyState(text: 'You don\'t have account activity yet',),
                fetchData: ref.read(activityLogsVmProvider.notifier).getAccountLogs,
                result: (data, s) {
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: viewModel.accountActivityDocs.length,
                      itemBuilder: (context, index) {
                        final accountActivity = viewModel.accountActivityDocs[index];
                        String dateTimeString = "${accountActivity.createdAt}";
                        DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                        return ActivityCardWidget(
                          title: '${accountActivity.actionType} ',
                          subTitle: '${ref.read(createPollVotingProvider.notifier).formatDt2(accountActivity.createdAt)}, '
                              '${DateFormat.jm().format(dateTime)}'
                          ,);
                      });
                }),
          ),

        ],
      ),
    );
  }

  sortList(s) {
    final viewModel = ref.watch(activityLogsVmProvider);
    viewModel.accountActivityDocs = [];
    setState(() {
      if (s == 'all time') {
        viewModel.accountActivityDocs = viewModel.accountActivityDocs1;
      } else if (s == 'this week') {
        int w = 7 - DateTime.now().weekday; // counting forward

        int y = 7 - w; // counting backward

        List<String> allWeekDays = [];

        for (int i = 0; i < w; i++) {
          String a = DateTime.now().add(Duration(days: i)).toString().split(' ')[0];
          String b = a.split('-')[2];
          allWeekDays.add(b.padLeft(2, '0'));
        }

        for (int i = 0; i < y; i++) {
          String a = DateTime.now().subtract(Duration(days: i + 1)).toString().split(' ')[0];
          String b = a.split('-')[2];
          allWeekDays.add(b.padLeft(2, '0'));
        }
        for (int i = 0; i < viewModel.accountActivityDocs1.length; i++) {
          String week = viewModel.accountActivityDocs1[i].createdAt.toString().split('T')[0];
          if (allWeekDays.contains(week.split('-')[2])) {
            viewModel.accountActivityDocs.add(viewModel.accountActivityDocs1[i]);
          }
        }
      } else if (s == 'this month') {
        String m = DateTime.now().month.toString().padLeft(2, '0');
        for (int i = 0; i < viewModel.accountActivityDocs1.length; i++) {
          String month = viewModel.accountActivityDocs1[i].createdAt.toString().split('T')[0];
          if (m == month.split('-')[1]) {
            viewModel.accountActivityDocs.add(viewModel.accountActivityDocs1[i]);
          }
        }
      } else if (s == 'this year') {
        String y = DateTime.now().year.toString();
        for (int i = 0; i < viewModel.accountActivityDocs1.length; i++) {
          String month = viewModel.accountActivityDocs1[i].createdAt.toString().split('T')[0];
          if (y == month.split('-')[0]) {
            viewModel.accountActivityDocs.add(viewModel.accountActivityDocs1[i]);
          }
        }
      } else {
        for (int i = 0; i < viewModel.accountActivityDocs1.length; i++) {
          if (s.toString().trim() == viewModel.accountActivityDocs1[i].createdAt.toString()) {
            viewModel.accountActivityDocs.add(viewModel.accountActivityDocs1[i]);
          }
        }
      }
    });
  }

}

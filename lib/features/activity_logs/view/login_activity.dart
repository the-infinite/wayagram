
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/data/model/login_history_model.dart';
import 'package:wayagram/features/activity_logs/vm/activity_logs_vm.dart';
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';
import 'package:wayagram/features/polls_and_voting/views/my_polls.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

import '../widget/activity_card_widget.dart';
class LoginActivity extends ConsumerStatefulWidget {
  static const route = '/loginActivity';
  const LoginActivity({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginActivityState();
}

class _LoginActivityState extends ConsumerState<LoginActivity> {


  @override
  Widget build(BuildContext context) {

    final viewModel = ref.watch(activityLogsVmProvider);
    return WayaScaffold(
      backgroundColor: WayaColors.greyColor50,
      title: "Login Activity    ",
      isLoading: false,
      isScrollable: false,
      body: Column(
        spacing:10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(10),
          Expanded(
            child: PaginatedDataView<LoginHistoryDocs>(
                uniqueKey: 'login-activity',
                loadingState: SizedBox(
                    height: context.height * 0.4,
                    child: Center(
                      child: CircularProgressIndicator(),
                    )),
                emptyState:ActivityLogsEmptyState(text: 'You don\'t have login activity yet',),
                fetchData: ref.read(activityLogsVmProvider.notifier).getLoginActivity,
                result: (data, s) {
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: viewModel.loginHistoryDocs.length,
                      itemBuilder: (context, index) {
                        final loginActivity = viewModel.loginHistoryDocs[index];
                        String dateTimeString = "${loginActivity.metadata?.timestamp}";
                        DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                        return ActivityCardWidget(
                          title: '${loginActivity.metadata?.location} (${loginActivity.metadata?.device?.capitalizeFirst})',
                          subTitle: '${ref.read(createPollVotingProvider.notifier).formatDt2(loginActivity.metadata?.timestamp)}, '
                              '${DateFormat.jm().format(dateTime)}'
                          ,);
                      });
                }),
          ),

        ],
      ),
    );
  }
  

}

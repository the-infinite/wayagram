

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
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

          Expanded(
            child: PaginatedDataView<AccountActivityDocs>(
                uniqueKey: 'account-activity',
                loadingState: SizedBox(
                    height: context.height * 0.4,
                    child: Center(
                      child: CircularProgressIndicator(),
                    )),
                emptyState:ActivityLogsEmptyState(text: 'You don\'t have account activity yet',),
                fetchData: ref.read(activityLogsVmProvider.notifier).getAccountActivity,
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
  

}

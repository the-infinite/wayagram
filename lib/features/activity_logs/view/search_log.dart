
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
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
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),
                Gap(10),
                SvgPicture.asset('assets/icons/down_arrow.svg')
              ],
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
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: viewModel.searchLogDocs.length,
                      itemBuilder: (context, index) {
                        final searchLogDocs = viewModel.searchLogDocs[index];
                        String dateTimeString = "${searchLogDocs.createdAt}";
                        DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                        return ActivityImageWidget(
                          title: '${searchLogDocs.description}',
                          subTitle: '${ref.read(createPollVotingProvider.notifier).formatDt2(searchLogDocs.createdAt)}, '
                              '${DateFormat.jm().format(dateTime)}', image: 'assets/icons/search.svg'
                          ,);
                      });
                }),
          ),




        ],
      ),
    );
  }


}

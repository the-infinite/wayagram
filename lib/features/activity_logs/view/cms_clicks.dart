
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/data/model/cms_model.dart';
import 'package:wayagram/features/activity_logs/vm/activity_logs_vm.dart';
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

import '../widget/activity_card_widget.dart';
class CmsClicks extends ConsumerStatefulWidget {
  static const route = '/cmsClicks';
  const CmsClicks({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CmsClicksState();
}

class _CmsClicksState extends ConsumerState<CmsClicks> {

List<String> dates = [];
  @override
  Widget build(BuildContext context) {

    final viewModel = ref.watch(activityLogsVmProvider);
    return WayaScaffold(
      backgroundColor: WayaColors.greyColor50,
      title: "CMS Clicks    ",
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
                      fontFamily: WayaConstants.fontFamily,
                      color: Colors.black,
                    )),
                Gap(10),
                SvgPicture.asset('assets/icons/down_arrow.svg')
              ],
            ),
          ),
          Gap(10),
          Expanded(
            child: PaginatedDataView<CmsDocs>(
                uniqueKey: 'cms',
                loadingState: SizedBox(
                    height: context.height * 0.4,
                    child: Center(
                      child: CircularProgressIndicator(),
                    )),
                emptyState:ActivityLogsEmptyState(text: 'You don\'t have Cms clicks yet',),
                fetchData: ref.read(activityLogsVmProvider.notifier).getCmsClicks,
                result: (data, s) {
                  for(int i = 0; i < viewModel.cmsDocs.length; i++){
                    if(!dates.contains(viewModel.cmsDocs[i].createdAt.toString().split('T')[0])){
                      dates.add(viewModel.cmsDocs[i].createdAt.toString().split('T')[0]);
                      viewModel.cmsDocs.add(viewModel.cmsDocs[i]);
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
                                  '${ref.read(createPollVotingProvider.notifier).formatDt(viewModel.cmsDocs[i].createdAt.toString().split('T')[0])}',
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
                                itemCount: viewModel.cmsDocs.length,
                                itemBuilder: (context, index){
                                  final cmsClicks = viewModel.cmsDocs[index];
                                  String dateTimeString = "${cmsClicks.createdAt}";
                                  DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                                  if(viewModel.cmsDocs[index].createdAt.toString().split('T')[0] == dates[i]){
                                    return ActivityCardWidget(
                                      title: '${cmsClicks.description}',
                                      subTitle: '${ref.read(createPollVotingProvider.notifier).formatDt2(cmsClicks.createdAt)}, '
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


}

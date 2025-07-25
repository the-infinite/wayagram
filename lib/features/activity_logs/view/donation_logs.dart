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
import 'package:wayagram/features/activity_logs/data/model/donation_activity_model.dart';
import 'package:wayagram/features/activity_logs/state/activity_logs_state.dart';
import 'package:wayagram/features/activity_logs/vm/activity_logs_vm.dart';
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

import '../widget/activity_card_widget.dart';

class DonationLogs extends ConsumerStatefulWidget {
  static const route = '/donationLogs';
  const DonationLogs({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DonationLogsState();
}

class _DonationLogsState extends ConsumerState<DonationLogs> {
  FilterType _filterBy = FilterType.allTime;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(activityLogsVmProvider);
    final month = WayaDateHelper.getCurrentMonthBounds();
    final year = WayaDateHelper.getCurrentYearBounds();
    final week = WayaDateHelper.getCurrentWeekBounds();

    //? First, get the boundaries we use to filter
    final startingBound = switch (_filterBy) {
      FilterType.thisMonth => month.$1,
      FilterType.thisWeek => week.$1,
      FilterType.thisYear => year.$1,
      _ => null,
    };
    final endingBound = switch (_filterBy) {
      FilterType.thisMonth => month.$2,
      FilterType.thisWeek => week.$2,
      FilterType.thisYear => year.$2,
      _ => null,
    };

    //? Second, get the filtered donations.
    final filteredDonations = startingBound == null || endingBound == null
        ? viewModel.donationDocs
        : viewModel.filterDonationDocs(startingBound, endingBound);

    //? Build the entire screen.
    return WayaScaffold(
      backgroundColor: WayaColors.greyColor50,
      title: "Donation    ",
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
            padding:
                const EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: WayaColors.greyColor300)),
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
              value: _filterBy,
              items: FilterType.values.map(
                (ls) {
                  return DropdownMenuItem(
                    value: ls,
                    child: Text(
                      ls.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: WayaConstants.fontFamily,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ).toList(),
              onChanged: (value) {
                setState(() {
                  _filterBy = value!;
                });
              },
            ),
          ),
          Gap(10),
          Expanded(
            child: PaginatedDataView<DonationDocs>(
              uniqueKey: 'Donation',
              loadingState: SizedBox(
                  height: context.height * 0.4,
                  child: Center(
                    child: CircularProgressIndicator(),
                  )),
              emptyState: ActivityLogsEmptyState(
                text: 'You don\'t have Donation yet',
              ),
              fetchData:
                  ref.read(activityLogsVmProvider.notifier).getDonationLogs,
              result: (data, s) {
                return SingleChildScrollView(
                  child: filteredDonations.isEmpty
                      ? ActivityLogsEmptyState(
                          text:
                              'You don\'t have donation logs for ${_filterBy.name.toLowerCase()} yet',
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 30.h),
                              child: Text(
                                  WayaDateHelper.getDailyTimestamp(DateTime.parse(
                                      '${filteredDonations.first.createdAt}')),
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontFamily: WayaConstants.fontFamily,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  )),
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              padding: EdgeInsets.only(bottom: 20.h, top: 0),
                              itemCount: filteredDonations.length,
                              separatorBuilder: (context, first) {
                                final previous = filteredDonations[first];
                                final next = filteredDonations[first + 1];
                                final firstDate =
                                    DateTime.parse('${previous.createdAt}');
                                final secondDate =
                                    DateTime.parse('${next.createdAt}');

                                //? If this happened on the same day as the other one.
                                if (WayaDateHelper.isSameDay(
                                    firstDate, secondDate)) {
                                  return SizedBox();
                                }

                                //? Return this.
                                return Padding(
                                  padding: EdgeInsets.only(top: 30.h),
                                  child: Text(
                                    WayaDateHelper.getDailyTimestamp(
                                        secondDate),
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontFamily: WayaConstants.fontFamily,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              },
                              itemBuilder: (context, index) {
                                final donation = filteredDonations[index];
                                final dateTimeString = "${donation.createdAt}";
                                final dateTime =
                                    DateTime.parse(dateTimeString).toLocal();

                                return ActivityCardWidget(
                                  title: '${donation.description}',
                                  subTitle:
                                      '${ref.read(createPollVotingProvider.notifier).formatDt2(donation.createdAt)}, '
                                      '${DateFormat.jm().format(dateTime)}',
                                );
                              },
                            ),
                          ],
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

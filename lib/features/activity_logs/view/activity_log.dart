import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/data/model/account_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/donation_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/event_log_model.dart';
import 'package:wayagram/features/activity_logs/data/model/group_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/page_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/polls_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/ugt_log_model.dart';
import 'package:wayagram/features/activity_logs/data/model/wallet_activity_model.dart';
import 'package:wayagram/features/activity_logs/vm/activity_logs_vm.dart';
import 'package:wayagram/features/activity_logs/widget/activity_card_widget.dart';
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

import '../state/activity_logs_state.dart';
import '../widget/activity_image_widget.dart';

class ActivityLog extends ConsumerStatefulWidget {
  static const route = '/activityLog';
  const ActivityLog({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ActivityLogState();
}

class _ActivityLogState extends ConsumerState<ActivityLog> {
  List<String> dates = [];

  String selTransact = 'All Time';
  var lsTransact = ['All Time', 'This week', 'This month', 'This Year'];
  String title = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final dynamic args = ModalRoute.of(context)?.settings.arguments;
      setState(() {
        if (args['name'] == 'shop') {
          title = 'Shop';
        } else if (args['name'] == 'wallet') {
          title = 'Wallet';
        } else if (args['name'] == 'account') {
          title = 'Account';
        } else if (args['name'] == 'events') {
          title = 'Events';
        } else if (args['name'] == 'chat') {
          title = 'Chats & Socials';
        } else if (args['name'] == 'polls') {
          title = 'Polls and Voting';
        } else if (args['name'] == 'pages') {
          title = 'Pages';
        } else if (args['name'] == 'groups') {
          title = 'Groups';
        } else if (args['name'] == 'donation') {
          title = 'Donation';
        } else if (args['name'] == 'ugt') {
          title = 'UGT';
        } else {
          title = 'Get Quotation';
        }
      });
    });
  }

  FilterType _filterBy = FilterType.allTime;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(activityLogsVmProvider);
    final month = WayaDateHelper.getCurrentMonthBounds();
    final year = WayaDateHelper.getCurrentYearBounds();
    final week = WayaDateHelper.getCurrentWeekBounds();
    final height = MediaQuery.of(context).size.height;

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

    //? Second, get the filtered wallet.
    final filteredWallet = startingBound == null || endingBound == null
        ? viewModel.walletActivityDocs
        : viewModel.filterWalletDocs(startingBound, endingBound);

    //? Second, get the filtered groups.
    final filteredGroup = startingBound == null || endingBound == null
        ? viewModel.groupDocs
        : viewModel.filterGroupDocs(startingBound, endingBound);

    //? Second, get the filtered pages.
    final filteredPage = startingBound == null || endingBound == null
        ? viewModel.pageDocs
        : viewModel.filterPageDocs(startingBound, endingBound);

    //? Second, get the filtered polls.
    final filteredPolls = startingBound == null || endingBound == null
        ? viewModel.pollDocs
        : viewModel.filterPollDocs(startingBound, endingBound);

    //? Second, get the filtered account.
    final filteredAccount = startingBound == null || endingBound == null
        ? viewModel.accountActivityDocs
        : viewModel.filterAccountDocs(startingBound, endingBound);

    //? Second, get the filtered event.
    final filteredEvent = startingBound == null || endingBound == null
        ? viewModel.eventDocs
        : viewModel.filterEventDocs(startingBound, endingBound);

    //? Second, get the filtered event.
    final filteredUgt = startingBound == null || endingBound == null
        ? viewModel.ugtLogDocs
        : viewModel.filterUgtDocs(startingBound, endingBound);

    //? Second, get the filtered donations.
    final filteredDonations = startingBound == null || endingBound == null
        ? viewModel.donationDocs
        : viewModel.filterDonationDocs(startingBound, endingBound);

    //? Second, get the filtered shop.
    final filteredShop = startingBound == null || endingBound == null
        ? viewModel.shopDocs
        : viewModel.filterShopDocs(startingBound, endingBound);

    //? Second, get the filtered event.
    final filteredGetQuotation = startingBound == null || endingBound == null
        ? viewModel.quotationDocs
        : viewModel.filterQuotationDocs(startingBound, endingBound);

    //? Log the starting and ending time.
    if (startingBound != null && endingBound != null) {
      debugPrint(
        "Time Bounds: (${WayaDateHelper.getDailyTimestamp(startingBound)}, ${WayaDateHelper.getDailyTimestamp(endingBound)})",
      );
    }

    final dynamic args = ModalRoute.of(context)?.settings.arguments;
    //final viewModel = ref.watch(activityLogsVmProvider);
    return WayaScaffold(
        backgroundColor: WayaColors.greyColor50,
        title: "$title    ",
        isLoading: false,
        isScrollable: false,
        body: Builder(builder: (context) {
          if (args['name'] == 'shop') {
            return Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Container(
                  alignment: Alignment.center,
                  width: 102.w,
                  height: 36.h,
                  padding: const EdgeInsets.only(
                      left: 8, right: 5, top: 5, bottom: 0),
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
                const Gap(10),
                Expanded(
                  child: PaginatedDataView<EventLogDocs>(
                    uniqueKey: 'Shop',
                    loadingState: SizedBox(
                        height: height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState: ActivityLogsEmptyState(
                      text: 'You don\'t have Shop logs yet',
                    ),
                    fetchData:
                        ref.read(activityLogsVmProvider.notifier).getShopLogs,
                    result: (data, s) {
                      return SingleChildScrollView(
                        child: filteredShop.isEmpty
                            ? ActivityLogsEmptyState(
                                text:
                                    'You don\'t have shop logs for ${_filterBy.name.toLowerCase()} yet',
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 30.h),
                                    child: Text(
                                        WayaDateHelper.getDailyTimestamp(
                                            DateTime.parse(
                                                '${filteredShop.first.createdAt}')),
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
                                    padding:
                                        EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: filteredShop.length,
                                    separatorBuilder: (context, first) {
                                      final previous = filteredShop[first];
                                      final next = filteredShop[first + 1];
                                      final firstDate = DateTime.parse(
                                          '${previous.createdAt}');
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
                                            fontFamily:
                                                WayaConstants.fontFamily,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      final shop = filteredShop[index];
                                      final dateTimeString =
                                          "${shop.createdAt}";
                                      final dateTime =
                                          DateTime.parse(dateTimeString)
                                              .toLocal();

                                      return ActivityCardWidget(
                                        title: '${shop.description}',
                                        subTitle:
                                            '${ref.read(createPollVotingProvider.notifier).formatDt2(shop.createdAt)}, '
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
            );
          } else if (args['name'] == 'wallet') {
            return Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Container(
                  alignment: Alignment.center,
                  width: 102.w,
                  height: 36.h,
                  padding: const EdgeInsets.only(
                      left: 8, right: 5, top: 5, bottom: 0),
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
                const Gap(10),
                Expanded(
                  child: PaginatedDataView<WalletActivityDocs>(
                    uniqueKey: 'Wallet',
                    loadingState: SizedBox(
                        height: height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState: ActivityLogsEmptyState(
                      text: 'You don\'t have wallet yet',
                    ),
                    fetchData:
                        ref.read(activityLogsVmProvider.notifier).getWalletLogs,
                    result: (data, s) {
                      return SingleChildScrollView(
                        child: filteredWallet.isEmpty
                            ? ActivityLogsEmptyState(
                                text:
                                    'You don\'t have wallet logs for ${_filterBy.name.toLowerCase()} yet',
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 30.h),
                                    child: Text(
                                        WayaDateHelper.getDailyTimestamp(
                                            DateTime.parse(
                                                '${filteredWallet.first.createdAt}')),
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
                                    padding:
                                        EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: filteredWallet.length,
                                    separatorBuilder: (context, first) {
                                      final previous = filteredWallet[first];
                                      final next = filteredWallet[first + 1];
                                      final firstDate = DateTime.parse(
                                          '${previous.createdAt}');
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
                                            fontFamily:
                                                WayaConstants.fontFamily,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      final wallet = filteredWallet[index];
                                      final dateTimeString =
                                          "${wallet.createdAt}";
                                      final dateTime =
                                          DateTime.parse(dateTimeString)
                                              .toLocal();
                                      return ActivityCardWidget(
                                        title:
                                            '${wallet.metadata?.description ?? wallet.description}',
                                        subTitle:
                                            '${ref.read(createPollVotingProvider.notifier).formatDt2(wallet.createdAt)}, '
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
            );
          } else if (args['name'] == 'events') {
            return Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Container(
                  alignment: Alignment.center,
                  width: 102.w,
                  height: 36.h,
                  padding: const EdgeInsets.only(
                      left: 8, right: 5, top: 5, bottom: 0),
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
                const Gap(10),
                Expanded(
                  child: PaginatedDataView<EventLogDocs>(
                    uniqueKey: 'Event',
                    loadingState: SizedBox(
                        height: height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState: ActivityLogsEmptyState(
                      text: 'You don\'t have Event logs yet',
                    ),
                    fetchData:
                        ref.read(activityLogsVmProvider.notifier).getEventLogs,
                    result: (data, s) {
                      return SingleChildScrollView(
                        child: filteredEvent.isEmpty
                            ? ActivityLogsEmptyState(
                                text:
                                    'You don\'t have account logs for ${_filterBy.name.toLowerCase()} yet',
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 30.h),
                                    child: Text(
                                        WayaDateHelper.getDailyTimestamp(
                                            DateTime.parse(
                                                '${filteredEvent.first.createdAt}')),
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
                                    padding:
                                        EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: filteredEvent.length,
                                    separatorBuilder: (context, first) {
                                      final previous = filteredEvent[first];
                                      final next = filteredEvent[first + 1];
                                      final firstDate = DateTime.parse(
                                          '${previous.createdAt}');
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
                                            fontFamily:
                                                WayaConstants.fontFamily,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      final event = filteredEvent[index];
                                      final dateTimeString =
                                          "${event.createdAt}";
                                      final dateTime =
                                          DateTime.parse(dateTimeString)
                                              .toLocal();

                                      return ActivityCardWidget(
                                        title: '${event.description}',
                                        subTitle:
                                            '${ref.read(createPollVotingProvider.notifier).formatDt2(event.createdAt)}, '
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
            );
          } else if (args['name'] == 'chat') {
            return Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Container(
                  alignment: Alignment.center,
                  width: 102.w,
                  height: 36.h,
                  padding: const EdgeInsets.only(
                      left: 8, right: 5, top: 5, bottom: 0),
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
                          sortList(selTransact.toLowerCase(),
                              viewModel.socialDocs, viewModel.socialDocs1);
                        });
                      }),
                ),
                const Gap(10),
                Expanded(
                  child: PaginatedDataView<PageDocs>(
                      uniqueKey: 'chat-logs',
                      loadingState: SizedBox(
                          height: height * 0.4,
                          child: Center(
                            child: CircularProgressIndicator(),
                          )),
                      emptyState: ActivityLogsEmptyState(
                        text: 'You don\'t have chat logs yet',
                      ),
                      fetchData: ref
                          .read(activityLogsVmProvider.notifier)
                          .getSocialLogs,
                      result: (data, s) {
                        for (int i = 0; i < viewModel.socialDocs.length; i++) {
                          if (!dates.contains(viewModel.socialDocs[i].createdAt
                              .toString()
                              .split('T')[0])) {
                            dates.add(viewModel.socialDocs[i].createdAt
                                .toString()
                                .split('T')[0]);
                            viewModel.socialDocs.add(viewModel.socialDocs[i]);
                          }
                        }
                        return SingleChildScrollView(
                          child: viewModel.socialDocs.isEmpty
                              ? ActivityLogsEmptyState(
                                  text:
                                      'You don\'t have Chat Logs for this week yet',
                                )
                              : ListView.builder(
                                  padding:
                                      EdgeInsets.only(bottom: 80.h, top: 0),
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: dates.length,
                                  itemBuilder: (context, i) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            ref
                                                .read(createPollVotingProvider
                                                    .notifier)
                                                .formatDt(dates[i]),
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontFamily:
                                                  WayaConstants.fontFamily,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            )),
                                        const Gap(10),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          padding: EdgeInsets.only(
                                              bottom: 20.h, top: 0),
                                          itemCount:
                                              viewModel.socialDocs.length,
                                          itemBuilder: (context, index) {
                                            final searchLog =
                                                viewModel.socialDocs[index];
                                            String dateTimeString =
                                                "${searchLog.createdAt}";
                                            DateTime dateTime =
                                                DateTime.parse(dateTimeString)
                                                    .toLocal();
                                            if (viewModel
                                                    .socialDocs[index].createdAt
                                                    .toString()
                                                    .split('T')[0] ==
                                                dates[i]) {
                                              return ActivityImageWidget(
                                                title:
                                                    '${searchLog.description}',
                                                subTitle:
                                                    '${ref.read(createPollVotingProvider.notifier).formatDt2(searchLog.createdAt)}, '
                                                    '${DateFormat.jm().format(dateTime)}',
                                                image:
                                                    'assets/icons/search.svg',
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
            );
          } else if (args['name'] == 'polls') {
            return Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Container(
                  alignment: Alignment.center,
                  width: 102.w,
                  height: 36.h,
                  padding: const EdgeInsets.only(
                      left: 8, right: 5, top: 5, bottom: 0),
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
                const Gap(10),
                Expanded(
                  child: PaginatedDataView<PollsActivityDocs>(
                    uniqueKey: 'Polls',
                    loadingState: SizedBox(
                        height: height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState: ActivityLogsEmptyState(
                      text: 'You don\'t have Polls logs yet',
                    ),
                    fetchData:
                        ref.read(activityLogsVmProvider.notifier).getPollsLogs,
                    result: (data, s) {
                      return SingleChildScrollView(
                        child: filteredPolls.isEmpty
                            ? ActivityLogsEmptyState(
                                text:
                                    'You don\'t have poll logs for ${_filterBy.name.toLowerCase()} yet',
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 30.h),
                                    child: Text(
                                        WayaDateHelper.getDailyTimestamp(
                                            DateTime.parse(
                                                '${filteredPolls.first.createdAt}')),
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
                                    padding:
                                        EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: filteredPolls.length,
                                    separatorBuilder: (context, first) {
                                      final previous = filteredPolls[first];
                                      final next = filteredPolls[first + 1];
                                      final firstDate = DateTime.parse(
                                          '${previous.createdAt}');
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
                                            fontFamily:
                                                WayaConstants.fontFamily,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      final polls = filteredPolls[index];
                                      final dateTimeString =
                                          "${polls.createdAt}";
                                      final dateTime =
                                          DateTime.parse(dateTimeString)
                                              .toLocal();

                                      return ActivityCardWidget(
                                        title: '${polls.description}',
                                        subTitle:
                                            '${ref.read(createPollVotingProvider.notifier).formatDt2(polls.createdAt)}, '
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
            );
          } else if (args['name'] == 'account') {
            return Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Container(
                  alignment: Alignment.center,
                  width: 102.w,
                  height: 36.h,
                  padding: const EdgeInsets.only(
                      left: 8, right: 5, top: 5, bottom: 0),
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
                const Gap(10),
                Expanded(
                  child: PaginatedDataView<AccountActivityDocs>(
                    uniqueKey: 'Account',
                    loadingState: SizedBox(
                        height: height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState: ActivityLogsEmptyState(
                      text: 'You don\'t have Account logs yet',
                    ),
                    fetchData: ref
                        .read(activityLogsVmProvider.notifier)
                        .getAccountLogs,
                    result: (data, s) {
                      return SingleChildScrollView(
                        child: filteredAccount.isEmpty
                            ? ActivityLogsEmptyState(
                                text:
                                    'You don\'t have account logs for ${_filterBy.name.toLowerCase()} yet',
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 30.h),
                                    child: Text(
                                        WayaDateHelper.getDailyTimestamp(
                                            DateTime.parse(
                                                '${filteredAccount.first.createdAt}')),
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
                                    padding:
                                        EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: filteredAccount.length,
                                    separatorBuilder: (context, first) {
                                      final previous = filteredAccount[first];
                                      final next = filteredAccount[first + 1];
                                      final firstDate = DateTime.parse(
                                          '${previous.createdAt}');
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
                                            fontFamily:
                                                WayaConstants.fontFamily,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      final account = filteredAccount[index];
                                      final dateTimeString =
                                          "${account.createdAt}";
                                      final dateTime =
                                          DateTime.parse(dateTimeString)
                                              .toLocal();

                                      return ActivityCardWidget(
                                        title: '${account.description}',
                                        subTitle:
                                            '${ref.read(createPollVotingProvider.notifier).formatDt2(account.createdAt)}, '
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
            );
          } else if (args['name'] == 'pages') {
            return Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Container(
                  alignment: Alignment.center,
                  width: 102.w,
                  height: 36.h,
                  padding: const EdgeInsets.only(
                      left: 8, right: 5, top: 5, bottom: 0),
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
                const Gap(10),
                Expanded(
                  child: PaginatedDataView<PageDocs>(
                    uniqueKey: 'Page',
                    loadingState: SizedBox(
                        height: height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState: ActivityLogsEmptyState(
                      text: 'You don\'t have Page logs yet',
                    ),
                    fetchData:
                        ref.read(activityLogsVmProvider.notifier).getPageLogs,
                    result: (data, s) {
                      return SingleChildScrollView(
                        child: filteredPage.isEmpty
                            ? ActivityLogsEmptyState(
                                text:
                                    'You don\'t have page logs for ${_filterBy.name.toLowerCase()} yet',
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 30.h),
                                    child: Text(
                                        WayaDateHelper.getDailyTimestamp(
                                            DateTime.parse(
                                                '${filteredPage.first.createdAt}')),
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
                                    padding:
                                        EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: filteredPage.length,
                                    separatorBuilder: (context, first) {
                                      final previous = filteredPage[first];
                                      final next = filteredPage[first + 1];
                                      final firstDate = DateTime.parse(
                                          '${previous.createdAt}');
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
                                            fontFamily:
                                                WayaConstants.fontFamily,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      final page = filteredPage[index];
                                      final dateTimeString =
                                          "${page.createdAt}";
                                      final dateTime =
                                          DateTime.parse(dateTimeString)
                                              .toLocal();

                                      return ActivityCardWidget(
                                        title: '${page.description}',
                                        subTitle:
                                            '${ref.read(createPollVotingProvider.notifier).formatDt2(page.createdAt)}, '
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
            );
          } else if (args['name'] == 'groups') {
            return Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Container(
                  alignment: Alignment.center,
                  width: 102.w,
                  height: 36.h,
                  padding: const EdgeInsets.only(
                      left: 8, right: 5, top: 5, bottom: 0),
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
                const Gap(10),
                Expanded(
                  child: PaginatedDataView<GroupDocs>(
                    uniqueKey: 'Group',
                    loadingState: SizedBox(
                        height: height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState: ActivityLogsEmptyState(
                      text: 'You don\'t have Group logs yet',
                    ),
                    fetchData:
                        ref.read(activityLogsVmProvider.notifier).getGroupLogs,
                    result: (data, s) {
                      return SingleChildScrollView(
                        child: filteredGroup.isEmpty
                            ? ActivityLogsEmptyState(
                                text:
                                    'You don\'t have group logs for ${_filterBy.name.toLowerCase()} yet',
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 30.h),
                                    child: Text(
                                        WayaDateHelper.getDailyTimestamp(
                                            DateTime.parse(
                                                '${filteredGroup.first.createdAt}')),
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
                                    padding:
                                        EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: filteredGroup.length,
                                    separatorBuilder: (context, first) {
                                      final previous = filteredGroup[first];
                                      final next = filteredGroup[first + 1];
                                      final firstDate = DateTime.parse(
                                          '${previous.createdAt}');
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
                                            fontFamily:
                                                WayaConstants.fontFamily,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      final group = filteredGroup[index];
                                      final dateTimeString =
                                          "${group.createdAt}";
                                      final dateTime =
                                          DateTime.parse(dateTimeString)
                                              .toLocal();

                                      return ActivityCardWidget(
                                        title: '${group.description}',
                                        subTitle:
                                            '${ref.read(createPollVotingProvider.notifier).formatDt2(group.createdAt)}, '
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
            );
          } else if (args['name'] == 'donation') {
            return Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Container(
                  alignment: Alignment.center,
                  width: 102.w,
                  height: 36.h,
                  padding: const EdgeInsets.only(
                      left: 8, right: 5, top: 5, bottom: 0),
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
                const Gap(10),
                Expanded(
                  child: PaginatedDataView<DonationDocs>(
                    uniqueKey: 'Donation',
                    loadingState: SizedBox(
                        height: height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState: ActivityLogsEmptyState(
                      text: 'You don\'t have Donation yet',
                    ),
                    fetchData: ref
                        .read(activityLogsVmProvider.notifier)
                        .getDonationLogs,
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
                                        WayaDateHelper.getDailyTimestamp(
                                            DateTime.parse(
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
                                    padding:
                                        EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: filteredDonations.length,
                                    separatorBuilder: (context, first) {
                                      final previous = filteredDonations[first];
                                      final next = filteredDonations[first + 1];
                                      final firstDate = DateTime.parse(
                                          '${previous.createdAt}');
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
                                            fontFamily:
                                                WayaConstants.fontFamily,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      final donation = filteredDonations[index];
                                      final dateTimeString =
                                          "${donation.createdAt}";
                                      final dateTime =
                                          DateTime.parse(dateTimeString)
                                              .toLocal();
                                      //debugPrint('DATE CHECK ==> $dateCheck, ${dates[i]}');

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
            );
          } else if (args['name'] == 'ugt') {
            return Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Container(
                  alignment: Alignment.center,
                  width: 102.w,
                  height: 36.h,
                  padding: const EdgeInsets.only(
                      left: 8, right: 5, top: 5, bottom: 0),
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
                const Gap(10),
                Expanded(
                  child: PaginatedDataView<UgtLogDocs>(
                    uniqueKey: 'Ugt',
                    loadingState: SizedBox(
                        height: height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState: ActivityLogsEmptyState(
                      text: 'You don\'t have Ugt logs yet',
                    ),
                    fetchData:
                        ref.read(activityLogsVmProvider.notifier).getUgtLogs,
                    result: (data, s) {
                      return SingleChildScrollView(
                        child: filteredEvent.isEmpty
                            ? ActivityLogsEmptyState(
                                text:
                                    'You don\'t have ugt logs for ${_filterBy.name.toLowerCase()} yet',
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 30.h),
                                    child: Text(
                                        WayaDateHelper.getDailyTimestamp(
                                            DateTime.parse(
                                                '${filteredEvent.first.createdAt}')),
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
                                    padding:
                                        EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: filteredUgt.length,
                                    separatorBuilder: (context, first) {
                                      final previous = filteredUgt[first];
                                      final next = filteredUgt[first + 1];
                                      final firstDate = DateTime.parse(
                                          '${previous.createdAt}');
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
                                            fontFamily:
                                                WayaConstants.fontFamily,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      final ugt = filteredUgt[index];
                                      final dateTimeString = "${ugt.createdAt}";
                                      final dateTime =
                                          DateTime.parse(dateTimeString)
                                              .toLocal();

                                      return ActivityCardWidget(
                                        title: '${ugt.description}',
                                        subTitle:
                                            '${ref.read(createPollVotingProvider.notifier).formatDt2(ugt.createdAt)}, '
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
            );
          } else {
            return Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Container(
                  alignment: Alignment.center,
                  width: 102.w,
                  height: 36.h,
                  padding: const EdgeInsets.only(
                      left: 8, right: 5, top: 5, bottom: 0),
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
                const Gap(10),
                Expanded(
                  child: PaginatedDataView<EventLogDocs>(
                    uniqueKey: 'Quotation-logs',
                    loadingState: SizedBox(
                        height: height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState: ActivityLogsEmptyState(
                      text: 'You don\'t have Quotation logs yet',
                    ),
                    fetchData: ref
                        .read(activityLogsVmProvider.notifier)
                        .getQuotationLogs,
                    result: (data, s) {
                      return SingleChildScrollView(
                        child: filteredGetQuotation.isEmpty
                            ? ActivityLogsEmptyState(
                                text:
                                    'You don\'t have Quotation logs for ${_filterBy.name.toLowerCase()} yet',
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 30.h),
                                    child: Text(
                                        WayaDateHelper.getDailyTimestamp(
                                            DateTime.parse(
                                                '${filteredGetQuotation.first.createdAt}')),
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
                                    padding:
                                        EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: filteredGetQuotation.length,
                                    separatorBuilder: (context, first) {
                                      final previous =
                                          filteredGetQuotation[first];
                                      final next =
                                          filteredGetQuotation[first + 1];
                                      final firstDate = DateTime.parse(
                                          '${previous.createdAt}');
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
                                            fontFamily:
                                                WayaConstants.fontFamily,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      final quotation =
                                          filteredGetQuotation[index];
                                      final dateTimeString =
                                          "${quotation.createdAt}";
                                      final dateTime =
                                          DateTime.parse(dateTimeString)
                                              .toLocal();

                                      return ActivityCardWidget(
                                        title: '${quotation.description}',
                                        subTitle:
                                            '${ref.read(createPollVotingProvider.notifier).formatDt2(quotation.createdAt)}, '
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
            );
          }
        }));
  }

  void sortList(String s, List log1, log2) {
    //final viewModel = ref.watch(activityLogsVmProvider);
    log1 = [];
    setState(() {
      if (s == 'all time') {
        log1 = log2;
      } else if (s == 'this week') {
        int w = 7 - DateTime.now().weekday; // counting forward

        int y = 7 - w; // counting backward

        List<String> allWeekDays = [];

        for (int i = 0; i < w; i++) {
          String a =
              DateTime.now().add(Duration(days: i)).toString().split(' ')[0];
          String b = a.split('-')[2];
          allWeekDays.add(b.padLeft(2, '0'));
        }

        for (int i = 0; i < y; i++) {
          String a = DateTime.now()
              .subtract(Duration(days: i + 1))
              .toString()
              .split(' ')[0];
          String b = a.split('-')[2];
          allWeekDays.add(b.padLeft(2, '0'));
        }

        for (int i = 0; i < log2.length; i++) {
          String week = log2[i].createdAt.toString().split('T')[0];
          if (allWeekDays.contains(week.split('-')[2])) {
            log1.add(log2[i]);
          }
        }
      } else if (s == 'this month') {
        String m = DateTime.now().month.toString().padLeft(2, '0');
        for (int i = 0; i < log2.length; i++) {
          String month = log2[i].createdAt.toString().split('T')[0];
          if (m == month.split('-')[1]) {
            log1.add(log2[i]);
          }
        }
      } else if (s == 'this year') {
        String y = DateTime.now().year.toString();
        for (int i = 0; i < log2.length; i++) {
          String month = log2[i].createdAt.toString().split('T')[0];
          if (y == month.split('-')[0]) {
            log1.add(log2[i]);
          }
        }
      } else {
        for (int i = 0; i < log2.length; i++) {
          if (s.toString().trim() == log2[i].createdAt.toString()) {
            log1.add(log2[i]);
          }
        }
      }
    });
  }
}

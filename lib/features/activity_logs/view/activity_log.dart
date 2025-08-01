import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/extensions/list_filter_extension.dart';
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
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';
import 'package:wayagram/features/activity_logs/widget/activity_log_filter.dart';
import 'package:wayagram/features/activity_logs/widget/activity_log_search.dart';
import 'package:wayagram/features/activity_logs/widget/activity_log_list.dart';
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
        final String name = args['name'];
        title = switch (name) {
          'shop' => 'Shop',
          'wallet' => 'Wallet',
          'account' => 'Account',
          'events' => 'Events',
          'chat' => 'Chats & Socials',
          'polls' => 'Polls and Voting',
          'pages' => 'Pages',
          'groups' => 'Groups',
          'donation' => 'Donation',
          'ugt' => 'UGT',
          _ => 'Get Quotation',
        };
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

    //? Second, get the filtered data for all activity types.
    final filteredWallet = startingBound == null || endingBound == null
        ? viewModel.walletActivityDocs
        : viewModel.filterWalletDocs(startingBound, endingBound);

    final filteredGroup = startingBound == null || endingBound == null
        ? viewModel.groupDocs
        : viewModel.filterGroupDocs(startingBound, endingBound);

    final filteredPage = startingBound == null || endingBound == null
        ? viewModel.pageDocs
        : viewModel.filterPageDocs(startingBound, endingBound);

    final filteredPolls = startingBound == null || endingBound == null
        ? viewModel.pollDocs
        : viewModel.filterPollDocs(startingBound, endingBound);

    final filteredAccount = startingBound == null || endingBound == null
        ? viewModel.accountActivityDocs
        : viewModel.filterAccountDocs(startingBound, endingBound);

    final filteredEvent = startingBound == null || endingBound == null
        ? viewModel.eventDocs
        : viewModel.filterEventDocs(startingBound, endingBound);

    final filteredUgt = startingBound == null || endingBound == null
        ? viewModel.ugtLogDocs
        : viewModel.filterUgtDocs(startingBound, endingBound);

    final filteredDonations = startingBound == null || endingBound == null
        ? viewModel.donationDocs
        : viewModel.filterDonationDocs(startingBound, endingBound);

    final filteredShop = startingBound == null || endingBound == null
        ? viewModel.shopDocs
        : viewModel.filterShopDocs(startingBound, endingBound);

    final filteredGetQuotation = startingBound == null || endingBound == null
        ? viewModel.quotationDocs
        : viewModel.filterQuotationDocs(startingBound, endingBound);

    final dynamic args = ModalRoute.of(context)?.settings.arguments;
    final name = args['name'];
    return WayaScaffold(
        backgroundColor: WayaColors.greyColor50,
        title: "$title    ",
        isLoading: false,
        isScrollable: false,
        body: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            name == "chat"
                ? ActivityLogSearch(
                    selectedTransaction: selTransact,
                    transactionOptions: lsTransact,
                    onChanged: (String? value) {
                      setState(() {
                        selTransact = value!;
                        sortList(selTransact.toLowerCase(),
                            viewModel.socialDocs, viewModel.socialDocs1);
                      });
                    },
                  )
                : ActivityLogFilter(
                    filterBy: _filterBy,
                    onChanged: (value) {
                      setState(() {
                        _filterBy = value!;
                      });
                    },
                  ),
            const Gap(10),
            Expanded(
              child: _buildActivityByType(
                  name,
                  height,
                  viewModel,
                  filteredShop,
                  filteredWallet,
                  filteredEvent,
                  filteredPolls,
                  filteredAccount,
                  filteredPage,
                  filteredGroup,
                  filteredDonations,
                  filteredUgt,
                  filteredGetQuotation),
            ),
          ],
        ));
  }

  Widget _buildActivityByType(
      String name,
      double height,
      dynamic viewModel,
      List<EventLogDocs> filteredShop,
      List<WalletActivityDocs> filteredWallet,
      List<EventLogDocs> filteredEvent,
      List<PollsActivityDocs> filteredPolls,
      List<AccountActivityDocs> filteredAccount,
      List<PageDocs> filteredPage,
      List<GroupDocs> filteredGroup,
      List<DonationDocs> filteredDonations,
      List<UgtLogDocs> filteredUgt,
      List<EventLogDocs> filteredGetQuotation) {
    return switch (name) {
      'shop' => _buildShopActivity(height, filteredShop, name),
      'wallet' => _buildWalletActivity(height, filteredWallet, name),
      'events' => _buildEventsActivity(height, filteredEvent, name),
      'chat' => _buildChatActivity(height, viewModel, name),
      'polls' => _buildPollsActivity(height, filteredPolls, name),
      'account' => _buildAccountActivity(height, filteredAccount, name),
      'pages' => _buildPagesActivity(height, filteredPage, name),
      'groups' => _buildGroupsActivity(height, filteredGroup, name),
      'donation' => _buildDonationActivity(height, filteredDonations, name),
      'ugt' => _buildUgtActivity(height, filteredUgt, name),
      _ => _buildQuotationActivity(height, filteredGetQuotation, name),
    };
  }

  Widget _buildShopActivity(
    double height,
    List<EventLogDocs> filteredShop,
    String key,
  ) {
    return PaginatedDataView<EventLogDocs>(
      uniqueKey: key,
      loadingState: SizedBox(
          height: height * 0.4,
          child: const Center(
            child: CircularProgressIndicator(),
          )),
      emptyState: const ActivityLogsEmptyState(
        text: 'You don\'t have Shop logs yet',
      ),
      fetchData: ref.read(activityLogsVmProvider.notifier).getShopLogs,
      result: (data, s) {
        return ActivityLogList<EventLogDocs>(
          items: filteredShop,
          getDescription: (shop) => '${shop.description}',
          getCreatedAt: (shop) => '${shop.createdAt}',
          formatDate: (createdAt) =>
              ref.read(createPollVotingProvider.notifier).formatDt2(createdAt),
          emptyStateText:
              'You don\'t have shop logs for ${_filterBy.name.toLowerCase()} yet',
        );
      },
    );
  }

  Widget _buildWalletActivity(
    double height,
    List<WalletActivityDocs> filteredWallet,
    String key,
  ) {
    return PaginatedDataView<WalletActivityDocs>(
      uniqueKey: key,
      loadingState: SizedBox(
          height: height * 0.4,
          child: const Center(
            child: CircularProgressIndicator(),
          )),
      emptyState: const ActivityLogsEmptyState(
        text: 'You don\'t have wallet yet',
      ),
      fetchData: ref.read(activityLogsVmProvider.notifier).getWalletLogs,
      result: (data, s) {
        return ActivityLogList<WalletActivityDocs>(
          items: filteredWallet,
          getDescription: (wallet) =>
              '${wallet.metadata?.description ?? wallet.description}',
          getCreatedAt: (wallet) => '${wallet.createdAt}',
          formatDate: (createdAt) =>
              ref.read(createPollVotingProvider.notifier).formatDt2(createdAt),
          emptyStateText:
              'You don\'t have wallet logs for ${_filterBy.name.toLowerCase()} yet',
        );
      },
    );
  }

  Widget _buildEventsActivity(
    double height,
    List<EventLogDocs> filteredEvent,
    String key,
  ) {
    return PaginatedDataView<EventLogDocs>(
      uniqueKey: key,
      loadingState: SizedBox(
          height: height * 0.4,
          child: const Center(
            child: CircularProgressIndicator(),
          )),
      emptyState: const ActivityLogsEmptyState(
        text: 'You don\'t have Event logs yet',
      ),
      fetchData: ref.read(activityLogsVmProvider.notifier).getEventLogs,
      result: (data, s) {
        return ActivityLogList<EventLogDocs>(
          items: filteredEvent,
          getDescription: (event) => '${event.description}',
          getCreatedAt: (event) => '${event.createdAt}',
          formatDate: (createdAt) =>
              ref.read(createPollVotingProvider.notifier).formatDt2(createdAt),
          emptyStateText:
              'You don\'t have event logs for ${_filterBy.name.toLowerCase()} yet',
        );
      },
    );
  }

  Widget _buildChatActivity(
    double height,
    dynamic viewModel,
    String key,
  ) {
    return PaginatedDataView<PageDocs>(
        uniqueKey: key,
        loadingState: SizedBox(
            height: height * 0.4,
            child: const Center(
              child: CircularProgressIndicator(),
            )),
        emptyState: const ActivityLogsEmptyState(
          text: 'You don\'t have chat logs yet',
        ),
        fetchData: ref.read(activityLogsVmProvider.notifier).getSocialLogs,
        result: (data, s) {
          for (int i = 0; i < viewModel.socialDocs.length; i++) {
            if (!dates.contains(
                viewModel.socialDocs[i].createdAt.toString().split('T')[0])) {
              dates.add(
                  viewModel.socialDocs[i].createdAt.toString().split('T')[0]);
              viewModel.socialDocs.add(viewModel.socialDocs[i]);
            }
          }
          return SingleChildScrollView(
            child: viewModel.socialDocs.isEmpty
                ? const ActivityLogsEmptyState(
                    text: 'You don\'t have Chat Logs for this week yet',
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
                              ref
                                  .read(createPollVotingProvider.notifier)
                                  .formatDt(dates[i]),
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontFamily: WayaConstants.fontFamily,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              )),
                          const Gap(10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 20.h, top: 0),
                            itemCount: viewModel.socialDocs.length,
                            itemBuilder: (context, index) {
                              final searchLog = viewModel.socialDocs[index];
                              String dateTimeString = "${searchLog.createdAt}";
                              DateTime dateTime =
                                  DateTime.parse(dateTimeString).toLocal();
                              if (viewModel.socialDocs[index].createdAt
                                      .toString()
                                      .split('T')[0] ==
                                  dates[i]) {
                                return ActivityImageWidget(
                                  title: '${searchLog.description}',
                                  subTitle:
                                      '${ref.read(createPollVotingProvider.notifier).formatDt2(searchLog.createdAt)}, '
                                      '${DateFormat.jm().format(dateTime)}',
                                  image: 'assets/icons/search.svg',
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
        });
  }

  Widget _buildPollsActivity(
    double height,
    List<PollsActivityDocs> filteredPolls,
    String key,
  ) {
    return PaginatedDataView<PollsActivityDocs>(
      uniqueKey: key,
      loadingState: SizedBox(
          height: height * 0.4,
          child: const Center(
            child: CircularProgressIndicator(),
          )),
      emptyState: const ActivityLogsEmptyState(
        text: 'You don\'t have Polls logs yet',
      ),
      fetchData: ref.read(activityLogsVmProvider.notifier).getPollsLogs,
      result: (data, s) {
        return ActivityLogList<PollsActivityDocs>(
          items: filteredPolls,
          getDescription: (polls) => '${polls.description}',
          getCreatedAt: (polls) => '${polls.createdAt}',
          formatDate: (createdAt) =>
              ref.read(createPollVotingProvider.notifier).formatDt2(createdAt),
          emptyStateText:
              'You don\'t have poll logs for ${_filterBy.name.toLowerCase()} yet',
        );
      },
    );
  }

  Widget _buildAccountActivity(
      double height, List<AccountActivityDocs> filteredAccount, String key) {
    return PaginatedDataView<AccountActivityDocs>(
      uniqueKey: key,
      loadingState: SizedBox(
          height: height * 0.4,
          child: const Center(
            child: CircularProgressIndicator(),
          )),
      emptyState: const ActivityLogsEmptyState(
        text: 'You don\'t have Account logs yet',
      ),
      fetchData: ref.read(activityLogsVmProvider.notifier).getAccountLogs,
      result: (data, s) {
        return ActivityLogList<AccountActivityDocs>(
          items: filteredAccount,
          getDescription: (account) => '${account.description}',
          getCreatedAt: (account) => '${account.createdAt}',
          formatDate: (createdAt) =>
              ref.read(createPollVotingProvider.notifier).formatDt2(createdAt),
          emptyStateText:
              'You don\'t have account logs for ${_filterBy.name.toLowerCase()} yet',
        );
      },
    );
  }

  Widget _buildPagesActivity(
    double height,
    List<PageDocs> filteredPage,
    String key,
  ) {
    return PaginatedDataView<PageDocs>(
      uniqueKey: key,
      loadingState: SizedBox(
          height: height * 0.4,
          child: const Center(
            child: CircularProgressIndicator(),
          )),
      emptyState: const ActivityLogsEmptyState(
        text: 'You don\'t have Page logs yet',
      ),
      fetchData: ref.read(activityLogsVmProvider.notifier).getPageLogs,
      result: (data, s) {
        return ActivityLogList<PageDocs>(
          items: filteredPage,
          getDescription: (page) => '${page.description}',
          getCreatedAt: (page) => '${page.createdAt}',
          formatDate: (createdAt) =>
              ref.read(createPollVotingProvider.notifier).formatDt2(createdAt),
          emptyStateText:
              'You don\'t have page logs for ${_filterBy.name.toLowerCase()} yet',
        );
      },
    );
  }

  Widget _buildGroupsActivity(
    double height,
    List<GroupDocs> filteredGroup,
    String key,
  ) {
    return PaginatedDataView<GroupDocs>(
      uniqueKey: key,
      loadingState: SizedBox(
          height: height * 0.4,
          child: const Center(
            child: CircularProgressIndicator(),
          )),
      emptyState: const ActivityLogsEmptyState(
        text: 'You don\'t have Group logs yet',
      ),
      fetchData: ref.read(activityLogsVmProvider.notifier).getGroupLogs,
      result: (data, s) {
        return ActivityLogList<GroupDocs>(
          items: filteredGroup,
          getDescription: (group) => '${group.description}',
          getCreatedAt: (group) => '${group.createdAt}',
          formatDate: (createdAt) =>
              ref.read(createPollVotingProvider.notifier).formatDt2(createdAt),
          emptyStateText:
              'You don\'t have group logs for ${_filterBy.name.toLowerCase()} yet',
        );
      },
    );
  }

  Widget _buildDonationActivity(
    double height,
    List<DonationDocs> filteredDonations,
    String key,
  ) {
    return PaginatedDataView<DonationDocs>(
      uniqueKey: key,
      loadingState: SizedBox(
          height: height * 0.4,
          child: const Center(
            child: CircularProgressIndicator(),
          )),
      emptyState: const ActivityLogsEmptyState(
        text: 'You don\'t have Donation yet',
      ),
      fetchData: ref.read(activityLogsVmProvider.notifier).getDonationLogs,
      result: (data, s) {
        return ActivityLogList<DonationDocs>(
          items: filteredDonations,
          getDescription: (donation) => '${donation.description}',
          getCreatedAt: (donation) => '${donation.createdAt}',
          formatDate: (createdAt) =>
              ref.read(createPollVotingProvider.notifier).formatDt2(createdAt),
          emptyStateText:
              'You don\'t have donation logs for ${_filterBy.name.toLowerCase()} yet',
        );
      },
    );
  }

  Widget _buildUgtActivity(
    double height,
    List<UgtLogDocs> filteredUgt,
    String key,
  ) {
    return PaginatedDataView<UgtLogDocs>(
      uniqueKey: key,
      loadingState: SizedBox(
          height: height * 0.4,
          child: const Center(
            child: CircularProgressIndicator(),
          )),
      emptyState: const ActivityLogsEmptyState(
        text: 'You don\'t have Ugt logs yet',
      ),
      fetchData: ref.read(activityLogsVmProvider.notifier).getUgtLogs,
      result: (data, s) {
        return ActivityLogList<UgtLogDocs>(
          items: filteredUgt,
          getDescription: (ugt) => '${ugt.description}',
          getCreatedAt: (ugt) => '${ugt.createdAt}',
          formatDate: (createdAt) =>
              ref.read(createPollVotingProvider.notifier).formatDt2(createdAt),
          emptyStateText:
              'You don\'t have ugt logs for ${_filterBy.name.toLowerCase()} yet',
        );
      },
    );
  }

  Widget _buildQuotationActivity(
    double height,
    List<EventLogDocs> filteredGetQuotation,
    String key,
  ) {
    return PaginatedDataView<EventLogDocs>(
      uniqueKey: key,
      loadingState: SizedBox(
          height: height * 0.4,
          child: const Center(
            child: CircularProgressIndicator(),
          )),
      emptyState: const ActivityLogsEmptyState(
        text: 'You don\'t have Quotation logs yet',
      ),
      fetchData: ref.read(activityLogsVmProvider.notifier).getQuotationLogs,
      result: (data, s) {
        return ActivityLogList<EventLogDocs>(
          items: filteredGetQuotation,
          getDescription: (quotation) => '${quotation.description}',
          getCreatedAt: (quotation) => '${quotation.createdAt}',
          formatDate: (createdAt) =>
              ref.read(createPollVotingProvider.notifier).formatDt2(createdAt),
          emptyStateText:
              'You don\'t have quotation logs for ${_filterBy.name.toLowerCase()} yet',
        );
      },
    );
  }

  void sortList(String filter, List log1, List log2) {
    setState(() {
      final filtered = log2.filterByTimeRange(
        filter, 
        (item) => DateTime.parse(item.createdAt.toString()),
      );
      log1.clear();
      log1.addAll(filtered);
    });
  }
}

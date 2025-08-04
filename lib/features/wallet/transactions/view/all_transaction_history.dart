import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/features/wallet/transactions/components/export_transaction.dart';
import 'package:wayagram/features/wallet/transactions/view/transaction_details.dart';
import 'package:wayagram/features/wallet/transactions/vm/transaction_vm.dart';
import 'package:wayagram/features/wallet/widget/transaction_widget.dart';

enum DateFilter {
  all,
  thisWeek,
  thisMonth,
  lastSixMonths,
  thisYear,
  customRange
}

class AllTransactionHistory extends ConsumerStatefulWidget {
  static const route = '/all-transactions';
  final currencyFormat = NumberFormat.currency(
    symbol: '₦',
    decimalDigits: 2,
  );

  AllTransactionHistory({super.key});

  @override
  ConsumerState<AllTransactionHistory> createState() =>
      _AllTransactionHistoryState();
}

class _AllTransactionHistoryState extends ConsumerState<AllTransactionHistory> {
  DateFilter selectedFilter = DateFilter.all;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;

  String _getFilterName(DateFilter filter) {
    switch (filter) {
      case DateFilter.all:
        return 'All';
      case DateFilter.thisWeek:
        return 'This Week';
      case DateFilter.thisMonth:
        return 'This Month';
      case DateFilter.lastSixMonths:
        return 'Last 6 Months';
      case DateFilter.thisYear:
        return 'This Year';
      case DateFilter.customRange:
        return 'Custom Date Range';
    }
  }

  Future<void> _applyFilter(DateFilter filter) async {
    String? appliedFilter;
    DateTime now = DateTime.now();
    if (filter == DateFilter.customRange) {
      final firstDate = DateTime.now().year;
      // Show date range picker
      final DateTimeRange? dateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(firstDate, 1, 1),
        lastDate: DateTime.now(),
        locale: const Locale('en', 'NG'),
        currentDate: DateTime.now(),
        saveText: 'Apply',
      );

      if (dateRange != null) {
        var startDate = dateRange.start.toLocal();
        var endDate = dateRange.end.toLocal();

        endDate = dateRange.end
            .add(const Duration(hours: 23, minutes: 59, seconds: 59));
        appliedFilter =
            "startDate=${DateFormat('yyyy-MM-dd').format(startDate)}&endDate=${DateFormat('yyyy-MM-dd hh:mm a').format(endDate)}";
      } else {
        return;
      }
    } else if (filter == DateFilter.all) {
      appliedFilter = null; // No filter applied, fetch all transactions
      ref.read(transactionVmProvider.notifier).loadInitialData();
    } else if (filter == DateFilter.thisWeek) {
      final weekday = DateTime.now().weekday;
      appliedFilter =
          "startDate=${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: weekday)))}&endDate=${DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now().add(Duration(days: 7 - weekday)).add(const Duration(hours: 23, minutes: 59, seconds: 59)))}";
    } else if (filter == DateFilter.thisMonth) {
      //first dat of the month
      DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);

// Last day of the month
      DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0)
          .add(const Duration(hours: 23, minutes: 59, seconds: 59));
      appliedFilter =
          "startDate=${DateFormat('yyyy-MM-dd').format(firstDayOfMonth)}&endDate=${DateFormat('yyyy-MM-dd hh:mm a').format(lastDayOfMonth)}";
    } else if (filter == DateFilter.lastSixMonths) {
// First day of the month, 6 months ago
      DateTime startDate = DateTime(now.year, now.month - 6, 1);

// Last day of the previous month
      DateTime endDate =
          now.add(const Duration(hours: 23, minutes: 59, seconds: 59));
      appliedFilter =
          "startDate=${DateFormat('yyyy-MM-dd').format(startDate)}&endDate=${DateFormat('yyyy-MM-dd hh:mm a').format(endDate)}";
    } else if (filter == DateFilter.thisYear) {
      DateTime now = DateTime.now();

// First day of the year
      DateTime startOfYear = DateTime(now.year, 1, 1);

// Last day of the year
      DateTime endOfYear = DateTime(now.year, 12, 31);
      appliedFilter =
          "startDate=${DateFormat('yyyy-MM-dd').format(startOfYear)}&endDate=${DateFormat('yyyy-MM-dd').format(endOfYear)}";
    }
    //if null, means no filter applied
    if (appliedFilter != null) {
      var list = await ref.read(transactionVmProvider.notifier).getTransaction2(
          filters: appliedFilter, isFirst: true, page: 1, limit: 10);

      ref.read(transactionVmProvider.notifier).setModelList(list);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionVmProvider.notifier).loadInitialData();
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(transactionVmProvider.notifier).loadMoreData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(transactionVmProvider);
    return WayaScaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'All Transactions',
          style: TextStyle(
              color: wayaTheme.colorScheme.customBlack, fontSize: 16.sp),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: wayaTheme.colorScheme.customBlack),
            onPressed: () {
              WayaNav.toNamed('/searchTransaction');
            },
          ),
          IconButton(
            icon: Icon(Icons.text_snippet_outlined,
                color: wayaTheme.colorScheme.customBlack),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => const ExportTransaction(),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(16),
          // Filter Dropdown
          PopupMenuButton<DateFilter>(
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_getFilterName(selectedFilter)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter by',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Choose filter',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              ...DateFilter.values.map(
                (filter) => PopupMenuItem<DateFilter>(
                  value: filter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_getFilterName(filter)),
                      if (selectedFilter == filter)
                        Icon(
                          Icons.check,
                          color: wayaTheme.primaryColor,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            ],
            onSelected: (DateFilter filter) {
              setState(() {
                selectedFilter = filter;
              });
              _applyFilter(filter);
            },
          ),
          const SizedBox(height: 16),

          // Quick Overview
          Text(
            'Quick Overview',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _OverviewCard(
                  title: 'Total Credit',
                  amount: state.totalCreditTransaction,
                  isCredit: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _OverviewCard(
                  title: 'Total Debit',
                  amount: state.totalDebitTransaction,
                  isCredit: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Transaction History Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transaction History',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Transactions List
          // Expanded(child: TransactionHistory()),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: state.transactionModel.length,
                    itemBuilder: (_, index) {
                      final trans = state.transactionModel[index];
                      String dateTimeString = "${trans.createdAt}";
                      DateTime dateTime =
                          DateTime.parse(dateTimeString).toLocal();
                      return TransactionWidget(
                        onTap: () => WayaNav.toNamed(
                            TransactionDetailsScreen.route,
                            arguments: trans.id),
                        purpose: '${trans.purpose?.capitalizeFirst}',
                        transactionType: '${trans.type}',
                        amount: trans.amount.toString(),
                        date:
                            '${ref.read(createPollVotingProvider.notifier).formatDt2(trans.updatedAt)},${DateFormat.jm().format(dateTime)}',
                      );
                    },
                  ),
                ),
                if (isLoadingMore)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: wayaTheme.colorScheme.primary600,
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final String title;
  final double amount;
  final bool isCredit;

  const _OverviewCard({
    required this.title,
    required this.amount,
    required this.isCredit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCredit ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.sp,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            NumberFormat.currency(symbol: '₦', decimalDigits: 2).format(amount),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/wallet/transactions/components/export_transaction.dart';
import 'package:wayagram/features/wallet/transactions/view/transaction_history.dart';
import 'package:wayagram/features/wallet/transactions/vm/transaction_vm.dart';

enum DateFilter { thisWeek, thisMonth, lastSixMonths, thisYear, customRange }

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
  DateFilter selectedFilter = DateFilter.thisWeek;

  String _getFilterName(DateFilter filter) {
    switch (filter) {
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

    if (filter == DateFilter.customRange) {
      final firstDate = DateTime.now().year;
      // Show date range picker
      final DateTimeRange? dateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(firstDate, 1, 1),
        lastDate: DateTime.now(),
        currentDate: DateTime.now(),
        saveText: 'Apply',
      );

      if (dateRange != null) {
        appliedFilter =
            "startDate=${DateFormat('yyyy-MM-dd').format(dateRange.start)}&endDate=${DateFormat('yyyy-MM-dd').format(dateRange.end)}";
      } else {
        return;
      }
    } else if (filter == DateFilter.thisWeek) {
      final weekday = DateTime.now().weekday;
      appliedFilter =
          "startDate=${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: weekday)))}&endDate=${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 7 - weekday)))}";
    } else if (filter == DateFilter.thisMonth) {
      final day = DateTime.now().day;
      appliedFilter =
          "startDate=${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: day)))}&endDate=${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 30 - day)))}";
    } else if (filter == DateFilter.lastSixMonths) {
      appliedFilter =
          "startDate=${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 30 * 6)))}&endDate=${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
    } else if (filter == DateFilter.thisYear) {
      appliedFilter =
          "startDate=${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 365)))}&endDate=${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
    }
    await ref
        .read(transactionVmProvider.notifier)
        .getUserTransactions(filters: appliedFilter);
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
          style:
              TextStyle(color: wayaTheme.colorScheme.customBlack, fontSize: 16.sp),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: wayaTheme.colorScheme.customBlack),
            onPressed: () {},
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
            children:  [
              Text(
                'Transaction History',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Transactions List
          Expanded(child: TransactionHistory()),
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
            style:  TextStyle(
              color: Colors.grey,
              fontSize: 12.sp,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            NumberFormat.currency(symbol: '₦', decimalDigits: 2).format(amount),
            style:  TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}


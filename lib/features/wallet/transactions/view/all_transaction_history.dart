import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/wallet/transactions/view/transaction_history.dart';

enum DateFilter { thisWeek, thisMonth, lastSixMonths, thisYear, customRange }

class AllTransactionHistory extends StatefulWidget {
  final currencyFormat = NumberFormat.currency(
    symbol: '₦',
    decimalDigits: 2,
  );

  AllTransactionHistory({super.key});

  @override
  State<AllTransactionHistory> createState() => _AllTransactionHistoryState();
}

class _AllTransactionHistoryState extends State<AllTransactionHistory> {
  DateFilter selectedFilter = DateFilter.thisMonth;

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

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'All Transactions',
          style:
              TextStyle(color: wayaTheme.colorScheme.customBlack, fontSize: 16),
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
              // showModalBottomSheet(
              //   context: context,
              //   shape: const RoundedRectangleBorder(
              //     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              //   ),
              //   builder: (context) => const PinEntryBottomSheet(),
              // );
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
              const PopupMenuItem(
                enabled: false,
                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sort by',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Choose filter',
                      style: TextStyle(
                        fontSize: 14,
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
                        const Icon(
                          Icons.check,
                          color: Colors.orange,
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
              if (filter == DateFilter.customRange) {
                // TODO: Show date range picker
              }
            },
          ),
          const SizedBox(height: 16),

          // Quick Overview
          const Text(
            'Quick Overview',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _OverviewCard(
                  title: 'Total Credit',
                  amount: 1259500.00,
                  isCredit: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _OverviewCard(
                  title: 'Total Debit',
                  amount: 250409.00,
                  isCredit: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Transaction History Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Transaction History',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            NumberFormat.currency(symbol: '₦', decimalDigits: 2).format(amount),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final String title;
  final bool isCredit;
  final double amount;
  final DateTime date;
  final IconData icon;

  const _TransactionCard({
    required this.title,
    required this.isCredit,
    required this.amount,
    required this.date,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCredit ? Colors.green[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isCredit ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  isCredit ? 'Credit' : 'Debit',
                  style: TextStyle(
                    color: isCredit ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : '-'}${NumberFormat.currency(symbol: '₦', decimalDigits: 2).format(amount)}',
                style: TextStyle(
                  color: isCredit ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                DateFormat('MMM dd, hh:mm a').format(date),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

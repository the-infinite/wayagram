import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/service/repos/transactions/transaction_history_model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/wallet/transactions/view/transaction_details.dart';
import 'package:wayagram/features/wallet/transactions/vm/transaction_vm.dart';

class TransactionHistory extends ConsumerStatefulWidget {
  const TransactionHistory({super.key});

  @override
  ConsumerState<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends ConsumerState<TransactionHistory> {
  int page = 1;
  int limit = 10;
  bool hasNextPage = true;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  List<TransactionDetail> transactions = [];
  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    try {
      await ref
          .read(transactionVmProvider.notifier)
          .getUserTransactions(limit: limit, page: page);

      if (mounted) {
        setState(() {
          isFirstLoad = false;
          // Update transactions with initial data
          final viewModel = ref.read(transactionVmProvider);
          if (viewModel.transactions != null) {
            transactions = viewModel.transactions!;
            hasNextPage = viewModel.hasNextPage ?? false;
          }
        });
      }
    } catch (e) {
      log('Error loading initial data: $e');
      if (mounted) {
        setState(() {
          isFirstLoad = false;
        });
      }
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (!hasNextPage || isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      page++;
      await ref
          .read(transactionVmProvider.notifier)
          .getUserTransactions(limit: limit, page: page);

      if (mounted) {
        final viewModel = ref.read(transactionVmProvider);
        final newTransactions = viewModel.transactions ?? [];

        if (newTransactions.isNotEmpty) {
          // Filter out duplicates
          final existingIds = transactions.map((t) => t.id).toSet();
          final uniqueNewTransactions = newTransactions
              .where((transaction) => !existingIds.contains(transaction.id))
              .toList();

          setState(() {
            transactions.addAll(uniqueNewTransactions);
            hasNextPage = uniqueNewTransactions.length >= limit;
          });
        } else {
          setState(() {
            hasNextPage = false;
          });
        }
      }
    } catch (e) {
      log('Error loading more transactions: $e');
      page--;
    } finally {
      if (mounted) {
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    if (isFirstLoad) {
      return const Center(child: CircularProgressIndicator());
    }

    if (transactions.isEmpty) {
      return const Center(child: EmptyTransaction());
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: transactions.length,
            itemBuilder: (_, index) => ListTile(
              onTap: () {
                WayaNav.toNamed(TransactionDetailsScreen.route,
                    arguments: transactions[index].id);
              },
              tileColor: wayaTheme.colorScheme.cardBackgroudColor,
              leading: Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: wayaTheme.colorScheme.primar50,
                  shape: BoxShape.circle,
                ),
                child: WayaAssets.icons.wallet.wallet.svg(fit: BoxFit.none),
              ),
              title: Row(
                children: [
                  Text(transactions[index].description,
                      style: wayaTheme.textTheme.bodyLarge),
                  const Spacer(),
                  Text(
                    "₦${transactions[index].amount.toString()}",
                    style: wayaTheme.textTheme.bodyMedium!
                        .copyWith(color: wayaTheme.colorScheme.success),
                  )
                ],
              ),
              subtitle: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.primar50,
                      borderRadius: BorderRadius.circular(120),
                    ),
                    child: Text(
                      transactions[index].type,
                      style: wayaTheme.textTheme.labelSmall!
                          .copyWith(color: wayaTheme.colorScheme.primary600),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('MMM dd, hh:mm a')
                        .format(transactions[index].updatedAt.toLocal()),
                    style: TextStyle(color: wayaTheme.colorScheme.greyColor500),
                  )
                ],
              ),
            ),
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
    );
  }
}

class EmptyTransaction extends StatelessWidget {
  const EmptyTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
        WayaAssets.images.wallet.searchDocu.image(scale: 1.5),
        Text('No transaction yet', style: wayaTheme.textTheme.headlineMedium),
        SizedBox(
          width: 310,
          child: Text(
            'Looks like you haven’t performed any transaction yet',
            textAlign: TextAlign.center,
            style: wayaTheme.textTheme.labelMedium
                ?.wayaCopyWith(color: wayaTheme.colorScheme.greyColor500),
          ),
        ),
      ],
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/extensions/string_extension.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/string_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/wallet/transactions/model/transaction_history_model.dart';
import 'package:wayagram/features/wallet/transactions/view/transaction_details.dart';
import 'package:wayagram/features/wallet/transactions/vm/transaction_vm.dart';
import 'package:wayagram/features/wallet/widget/transaction_widget.dart';

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
  bool isFirstLoad = true;
  List<TransactionHistoryModelDocs> docs = [];
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
          .getTransaction(limit: limit, page: page);

      if (mounted) {
        setState(() {
          isFirstLoad = false;
          // Update transactions with initial data
          final viewModel = ref.read(transactionVmProvider);
          if (viewModel.docs != null) {
            docs = viewModel.docs!;
            hasNextPage = viewModel.hasNextPage;
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
          .getTransaction(limit: limit, page: page);

      if (mounted) {
        final viewModel = ref.read(transactionVmProvider);
        final newTransactions = viewModel.docs ?? [];
        //final newTransactions = viewModel.transactions ?? [];
        if (newTransactions.isNotEmpty) {
          // Filter out duplicates
          final existingIds = docs.map((t) => t.id).toSet();
          final uniqueNewTransactions = newTransactions
              .where((transaction) => !existingIds.contains(transaction.id))
              .toList();
          setState(() {
            docs.addAll(uniqueNewTransactions);
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

    //final viewModel = ref.watch(transactionVmProvider);

    if (isFirstLoad) {
      return const Center(child: CircularProgressIndicator());
    }

    if (docs.isEmpty) {
      return const Center(child: EmptyTransaction());
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: docs.length,
            itemBuilder: (_, index) {
              final trans = docs[index];
              String dateTimeString = "${trans.createdAt}";
              DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
              return TransactionWidget(
                onTap: () => WayaNav.toNamed(TransactionDetailsScreen.route,
                    arguments: trans.id),
                purpose: '${trans.purpose?.capitalizeFirst}',
                transactionType: '${trans.type}',
                amount: trans.amount.toString(),
                date:
                    '${trans.updatedAt?.formatDt2()},${DateFormat.jm().format(dateTime)}',
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

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/service/repos/transactions/transaction_history_model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/features/wallet/transactions/model/transaction_model.dart';
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
  List<TransactionModelDocs> docs = [];

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
          //.getUserTransactions(limit: limit, page: page);

      if (mounted) {
        setState(() {
          isFirstLoad = false;
          // Update transactions with initial data
          final viewModel = ref.read(transactionVmProvider);
          if (viewModel.docs != null) {
            docs = viewModel.docs!;
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
          //.getUserTransactions(limit: limit, page: page);
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

    if (isFirstLoad) {
      return const Center(child: CircularProgressIndicator());
    }

    // if (transactions.isEmpty) {
    //   return const Center(child: EmptyTransaction());
    // }

    if (docs.isEmpty) {
      return const Center(child: EmptyTransaction());
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: docs.length,
            //itemCount: transactions.length,
            itemBuilder: (_, index) {
              String dateTimeString = "${docs[index].createdAt}";
              DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        decoration: BoxDecoration(
          color: wayaTheme.colorScheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.greyColor100),
        ),
        child: ListTile(

          onTap: () {
            WayaNav.toNamed(TransactionDetailsScreen.route,
                arguments: docs[index].id);
          },
          tileColor: wayaTheme.colorScheme.cardBackgroudColor,
          leading: Container(
            height: 40.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: wayaTheme.colorScheme.primary50,
              shape: BoxShape.circle,
            ),
            child: WayaAssets.icons.wallet.wallet.svg(fit: BoxFit.none),
          ),
          title: Row(
            children: [
              Text('${docs[index].purpose?.capitalizeFirst}',
                  //transactions[index].description,
                  style: wayaTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontFamily: WayaConstants.fontFamily,
                      fontSize: 14.sp,
                      color: wayaTheme.colorScheme.greyColor700
                  )),
              const Spacer(),
              docs[index].type == 'FUNDING' || docs[index].type == 'REFUND'?
              Text(
                "+₦${docs[index].amount.toString()}",
                style: wayaTheme.textTheme.bodyMedium!
                    .copyWith(color: wayaTheme.colorScheme.success,
                  fontWeight: FontWeight.w400,
                  fontFamily: WayaConstants.fontFamily,
                  fontSize: 12.sp,),
              ):
              Text(
                "-₦${docs[index].amount.toString()}",
                style: wayaTheme.textTheme.bodyMedium!
                    .copyWith(color: WayaColors.error,
                //wayaTheme.colorScheme.error,
                  fontWeight: FontWeight.w400,
                  fontFamily: WayaConstants.fontFamily,
                  fontSize: 12.sp,),
              )
            ],
          ),
          subtitle: Row(
            children: [
              docs[index].type == 'FUNDING' || docs[index].type == 'REFUND'?
              Container(
                //padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: wayaTheme.colorScheme.success50,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                 height: 17.h,
                 width: 48.w,
                child: Text('Credit',
                  //transactions[index].type,
                  style: wayaTheme.textTheme.labelSmall!
                      .copyWith(color: wayaTheme.colorScheme.success,
                    fontWeight: FontWeight.w500,
                    fontFamily: WayaConstants.fontFamily,
                    fontSize: 12.sp,
                  ),
                ),
              ):
              Container(
                //padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: wayaTheme.colorScheme.error50,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                height: 17.h,
                width: 48.w,
                child: Text('Debit',
                  //transactions[index].type,
                  style: wayaTheme.textTheme.labelSmall!
                      .copyWith(color: wayaTheme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                    fontFamily: WayaConstants.fontFamily,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              const Spacer(),
              Text('${ref.read(createPollVotingProvider.notifier).formatDt2(docs[index].updatedAt)},${DateFormat.jm().format(dateTime)}',
                //DateFormat('MMM dd, hh:mm a').format(docs[index].updatedAt.toLocal()),
                //DateFormat('MMM dd, hh:mm a').format(transactions[index].updatedAt.toLocal()),
                style: TextStyle(color: wayaTheme.colorScheme.greyColor500,
                  fontWeight: FontWeight.w400,
                  fontFamily: WayaConstants.fontFamily,
                  fontSize: 12.sp,),
              )
            ],
          ),
        ),
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

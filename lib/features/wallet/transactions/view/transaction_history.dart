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
import 'package:wayagram/features/wallet/widget/transaction_widget.dart';

class TransactionHistory extends ConsumerStatefulWidget {
  const TransactionHistory({super.key});

  @override
  ConsumerState<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends ConsumerState<TransactionHistory> {
/*   int page = 1;
  int limit = 10;
  bool hasNextPage = true; */
  final ScrollController _scrollController = ScrollController();
/*   bool isLoadingMore = false;
  List<TransactionDetail> transactions = [];
  bool isFirstLoad = true; */
  // List<TransactionModelDocs> docs = [];

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
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    final viewModel = ref.watch(transactionVmProvider);

    if (viewModel.isFirstLoad!) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.docs!.isEmpty) {
      return const Center(child: EmptyTransaction());
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: viewModel.docs!.length,
            itemBuilder: (_, index) {
              String dateTimeString = "${viewModel.docs![index].createdAt}";
              DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
              return TransactionWidget(
                onTap: () => WayaNav.toNamed(TransactionDetailsScreen.route,
                    arguments: viewModel.docs![index].id),
                purpose: '${viewModel.docs![index].purpose?.capitalizeFirst}',
                transactionType: '${viewModel.docs![index].type}',
                amount: viewModel.docs![index].amount.toString(),
                date:
                    '${ref.read(createPollVotingProvider.notifier).formatDt2(viewModel.docs![index].updatedAt)},${DateFormat.jm().format(dateTime)}',
              );
            },
          ),
        ),
        if (viewModel.isFirstLoad!)
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

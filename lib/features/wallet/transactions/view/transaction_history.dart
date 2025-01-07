import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/wallet/transactions/routes/transaction_routes.dart';
import 'package:wayagram/features/wallet/transactions/vm/transaction_vm.dart';

class TransactionHistory extends ConsumerStatefulWidget {
  const TransactionHistory({super.key});

  @override
  ConsumerState<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends ConsumerState<TransactionHistory> {
  int page = 1;
  int limit = 10;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(transactionVmProvider.notifier)
          .getUserTransactions(limit: limit, page: page);
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(transactionVmProvider);
    return viewModel.transactions == null || viewModel.transactions!.isEmpty
        ? const Center(child: EmptyTransaction())
        : ListView.builder(
            itemBuilder: (_, index) => ListTile(
                  onTap: () {
                    WayaNav.toNamed(TransactionRoutes.transactionDetails,
                        arguments: viewModel.transactions?[index].id);
                  },
                  leading: Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: wayaTheme.colorScheme.primar50,
                        shape: BoxShape.circle,
                      ),
                      child: WayaAssests.icons.wallet.wallet
                          .svg(fit: BoxFit.none)),
                  title: Row(
                    children: [
                      Text(viewModel.transactions?[index].description ?? '',
                          style: wayaTheme.textTheme.bodyLarge),
                      const Spacer(),
                      Text(
                        "₦${viewModel.transactions?[index].amount.toString() ?? ''}",
                        style: wayaTheme.textTheme.bodyMedium!
                            .copyWith(color: Colors.green),
                      )
                    ],
                  ),
                  subtitle: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: wayaTheme.colorScheme.primar50,
                        borderRadius: BorderRadius.circular(120),
                      ),
                      child: Text(
                        viewModel.transactions?[index].type ?? '',
                        style: wayaTheme.textTheme.labelSmall!
                            .copyWith(color: wayaTheme.colorScheme.primary600),
                      ),
                    ),
                    const Spacer(),
                    if (viewModel.transactions != null)
                      Text(
                        DateFormat('MMM dd, hh:mm a').format(
                            viewModel.transactions![index].updatedAt.toLocal()),
                        style: TextStyle(
                            color: wayaTheme.colorScheme.greyColor500),
                      )
                  ]),
                ),
            itemCount: viewModel.transactions?.length ?? 0);
  }
}

class EmptyTransaction extends StatelessWidget {
  const EmptyTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
        WayaAssests.images.wallet.searchDocu.image(scale: 1.5),
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

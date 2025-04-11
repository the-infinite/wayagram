import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/features/wallet/transactions/view/all_transaction_history.dart';
import 'package:wayagram/features/wallet/transactions/view/transaction_history.dart';
import 'package:wayagram/features/wallet/transactions/vm/transaction_vm.dart';
import 'package:wayagram/features/wallet/view/components/wallet_cards.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';

class WalletPage extends ConsumerStatefulWidget {
  static const route = '/wallet';
  const WalletPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(transactionVmProvider.notifier).getTransaction();
    });

  }
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(walletVmProvider);
    return WayaScaffold(
      color: wayaTheme.colorScheme.scaffoldColor2,
      title: 'Wallet',
      onTapBackButton: () => WayaNav.toNamed(BottomView.route),
      isLoading: state.isLoading!,
      body: Column(
        children: [
          WalletBalanceCard(),
          Gap(10),
          SizedBox(width: 10,),
          Image.asset('assets/images/wallet/marks.png', height: 24,),
          Gap(10),
          Row(
            children: [
              Text('Total Balance: ₦${ref.watch(createPollVotingProvider.notifier).formatAm('${state.data?.balance}')}',
                style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.greyColor600 ),
              ),
              Spacer(),
              Text('Payout-Eligible: ₦0.00',
                style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.greyColor600 ),
              ),
            ],
          ),
          Gap(10),
          AccountDetailsCard(
            externalAccounts: state.externalWallets,
          ),
          Gap(20),
          _buildHistoryHeader(wayaTheme),
          Gap(10),
          Expanded(child: TransactionHistory()),
        ],
      ),
    );
  }

  Row _buildHistoryHeader(ThemeData wayaTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Transaction History',
          style: wayaTheme.textTheme.titleMedium,
        ),
        GestureDetector(
          onTap: () => WayaNav.toNamed(AllTransactionHistory.route),
          child: Text(
            'See All',
            style: wayaTheme.textTheme.titleMedium
                ?.wayaCopyWith(color: wayaTheme.colorScheme.primary500),
          ),
        ),
      ],
    );
  }
}

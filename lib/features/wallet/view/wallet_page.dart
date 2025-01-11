import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/wallet/transactions/view/all_transaction_history.dart';
import 'package:wayagram/features/wallet/transactions/view/transaction_history.dart';
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
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(walletVmProvider);
    return WayaScaffold(
      color: wayaTheme.colorScheme.scaffoldColor2,
      title: 'Wallet',
      isLoading: state.isLoading!,
      body: Column(
        children: [
          WalletBalanceCard(),
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

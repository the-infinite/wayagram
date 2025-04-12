import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';
import 'package:wayagram/features/wallet/widget/payment_method_widget.dart';
import 'package:wayagram/features/wallet/widget/payout_empty_state.dart';

class PayoutMethodScreen extends ConsumerStatefulWidget {
  const PayoutMethodScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PayoutMethodScreenState();
}

class _PayoutMethodScreenState extends ConsumerState<PayoutMethodScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(walletVmProvider.notifier).getPayoutMethod();
    });

    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.read(walletVmProvider.notifier).getPayoutMethod();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(walletVmProvider);
    return viewModel.payoutMethod.isEmpty? PayoutEmptyState(
      onTap: (){
        WayaNav.toNamed('/addPayoutMethodScreen');
      },
      title: 'No Payout Method Added',
      image: 'payout',
      subTitle: 'Looks like you haven’t added any payout\nmethod yet',
      hasButton: true,

    ):SizedBox(
      height: 530,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: viewModel.payoutMethod.length,
          itemBuilder: (context, index) {
            return PaymentMethodWidget(
              initial: '${viewModel.payoutMethod[index].accountName?.substring(0, 1)}',
              accountName: '${viewModel.payoutMethod[index].accountName}',
              accountNumber: '${viewModel.payoutMethod[index].accountNumber}',
              bankName: '${viewModel.payoutMethod[index].bankName}',
              wayaTheme: wayaTheme,
              onTap: ()=> ref.watch(walletVmProvider.notifier).deletePayoutMethod(context, id: '${viewModel.payoutMethod[index].id}'),
              onClick: ()=> WayaNav.toNamed('/enterRequestAmountScreen',
              arguments: {
                'id':'${viewModel.payoutMethod[index].id}',
                'bankName':viewModel.payoutMethod[index].bankName,
                'acctNumber':viewModel.payoutAccountNumber
              }),

            );
          }),
    );
  }

}



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/polls_and_voting/data/model/fetch_all_polls.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/features/wallet/data/model/payout_method_model.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';
import 'package:wayagram/features/wallet/widget/payment_method_widget.dart';
import 'package:wayagram/features/wallet/widget/payout_empty_state.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

import '../../polls_and_voting/views/my_polls.dart';

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
      subTitle: 'Looks like you haven’t added any payout\nmethod yet',
      hasButton: true,

    ):SizedBox(
      height: 530,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: viewModel.payoutMethod?.length,
          itemBuilder: (context, index) {
            return PaymentMethodWidget(
              initial: '${viewModel.payoutMethod?[index].accountName?.substring(0, 1)}',
              accountName: '${viewModel.payoutMethod?[index].accountName}',
              accountNumber: '${viewModel.payoutMethod?[index].accountNumber}',
              bankName: '${viewModel.payoutMethod?[index].bankName}',
              wayaTheme: wayaTheme,

            );
          }),
    );
  }

}



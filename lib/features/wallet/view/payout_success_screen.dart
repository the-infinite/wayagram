import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/wallet/view/wallet_page.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';

class PayoutSuccessScreen extends ConsumerStatefulWidget {
  static const route = '/payoutSuccessScreen';
  const PayoutSuccessScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PayoutSuccessScreenState();
}

class _PayoutSuccessScreenState extends ConsumerState<PayoutSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(walletVmProvider);
    final wayaTheme = Theme.of(context);

    final dynamic args = ModalRoute.of(context)?.settings.arguments;
    return WayaScaffold(
      automaticallyImplyLeading: false,
      removeAppBar: false,
      isLoading: viewModel.isLoading!,
      isScrollable: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Gap(50),
          Image.asset(
            'assets/images/wallet/check.png',
            height: 100.h,
            width: 100.w,
          ),
          const Gap(50),
          Text(
            'Payout Request Sent Successfully',
            style: wayaTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: WayaColors.greyColor500,
            ),
          ),
          const Gap(10),
          Text(
            '₦${args['amount']}',
            style: wayaTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: WayaColors.primary,
            ),
          ),
          const Gap(10),
          Text(
            'This payout request has been sent and would be\nprocess in under 24hrs.',
            style: wayaTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: WayaColors.greyColor600,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(150),
          WayaButton(
            callback: !viewModel.isLoading!
                ? () async {
                    WayaNav.removeAllUntil(WalletPage(), '/wallet');
                  }
                : null,
            centerWidget:
                LoadingState(loading: viewModel.isLoading!, text: 'Done'),
            height: 50.h,
          ),
          const Gap(10),
          Text(
            'If you have any issue with this transaction.\nYou can reach out to our Support Center',
            style: wayaTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: WayaColors.greyColor600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

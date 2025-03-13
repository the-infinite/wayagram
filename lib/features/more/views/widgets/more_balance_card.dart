import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/wallet/view/fund_wallet_options_screen.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';

class MoreBalanceCard extends ConsumerStatefulWidget {
  const MoreBalanceCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MoreBalanceCardState();
}

class _MoreBalanceCardState extends ConsumerState<MoreBalanceCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(walletVmProvider.notifier).getUserWallet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(walletVmProvider);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            width: 1.sw,
            decoration: BoxDecoration(
              color: wayaTheme.colorScheme.primary50,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Balance',
                          style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                            color: wayaTheme.colorScheme.greyColor400,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        WayaAmountFormatter(
                          color: wayaTheme.colorScheme.customPrimary,
                          balanceColor: wayaTheme.colorScheme.customPrimary,
                          koboValueColor: wayaTheme.colorScheme.primary75,
                          amount: double.parse(viewModel.data?.balance ?? "0"),
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WayaButton(
                      text: 'Fund Wallet',
                      horizontalPadding: 22,
                      color: wayaTheme.colorScheme.customPrimary,
                      height: 36.h,
                      textStyle: wayaTheme.textTheme.labelSmall
                          ?.wayaCopyWith(color: wayaTheme.colorScheme.white),
                      callback: () =>
                          WayaNav.toNamed(FundWalletOptionsScreen.route),
                    ),
                    SizedBox(width: 10.w),
                    WayaButton(
                      horizontalPadding: 22,
                      height: 36.h,
                      border: Border.all(
                        width: 1,
                        color: wayaTheme.colorScheme.customPrimary,
                      ),
                      color: wayaTheme.colorScheme.transparent,
                      text: 'Learn More',
                      textStyle: wayaTheme.textTheme.labelSmall,
                      textColor: wayaTheme.colorScheme.customPrimary,
                      callback: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SvgPicture.asset('assets/icons/more-acct-bal.svg'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/promotion/vm/create_promotion_vm.dart';
import 'package:wayagram/features/wallet/view/fund_wallet_options_screen.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';

class PayForPromotion extends ConsumerStatefulWidget {
  final String title;
  final int budget;
  const PayForPromotion({super.key, required this.title, required this.budget});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JoinEventState();
}

class _JoinEventState extends ConsumerState<PayForPromotion> {
  late final notifier = ref.read(promotionVmProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final walletState = ref.watch(walletVmProvider);
    final state = ref.watch(promotionVmProvider);
    final walletBalance = walletState.data?.balance ?? '0';
    final isInsufficientBalance = double.parse(walletBalance).toInt() < widget.budget;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Promote ${widget.title.capitalizeFirst}",
              style: wayaTheme.textTheme.titleLarge),
          const Gap(5),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      "Are you sure you want to promote this ${widget.title.toLowerCase()}, this would cost ",
                  style: wayaTheme.textTheme.hintStyle,
                ),
                TextSpan(
                  text: WayaHelpers.formatPrice(widget.budget),
                  style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                    color: wayaTheme.colorScheme.customPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          ),
          const Gap(30),
          Container(
            padding: EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.primary50,
                borderRadius: BorderRadius.circular(12)),
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Available Balance",
                  style: Theme.of(context).textTheme.bodyMedium?.wayaCopyWith(
                        fontSize: 14.sp,
                        color: wayaTheme.colorScheme.greyColor900,
                      ),
                ),
                const Gap(6),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          isInsufficientBalance
                              ? "Insufficient Balance"
                              : "Wallet Balance",
                          style: isInsufficientBalance
                              ? wayaTheme.textTheme.errorHintStyle
                              : wayaTheme.textTheme.hintStyle),
                      const Gap(3),
                      WayaAmountFormatter(
                        color: wayaTheme.colorScheme.customBlack,
                        balanceColor: wayaTheme.colorScheme.customBlack,
                        koboValueColor: wayaTheme.colorScheme.greyColor600,
                        amount: double.parse(walletState.data?.balance ?? "0"),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
          const Gap(30),
          WayaButton(
            callback: !state.isLoading
                ? () async {
                    if (isInsufficientBalance) {
                      await WayaNav.toNamed(
                        FundWalletOptionsScreen.route,
                      );
                      return;
                    }

                    await notifier.payForPromotion(context: context);
                  }
                : null,
            centerWidget: LoadingState(
              loading: state.isLoading,
              text: isInsufficientBalance
                  ? "Fund Wallet"
                  : "Yes, Promote ${widget.title.capitalizeFirst}",
            ),
          ),
          const Gap(10),
          WayaButton(
            callback: () => WayaNav.goBack(),
            textColor: wayaTheme.colorScheme.greyColor500,
            color: wayaTheme.colorScheme.transparent,
            border:
                Border.all(color: wayaTheme.colorScheme.greyColor500, width: 1),
            text: 'Go Back',
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/wallet/view/fund_wallet_options_screen.dart';
import 'package:gap/gap.dart';
class MoreBalanceCard extends ConsumerStatefulWidget {
  const MoreBalanceCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MoreBalanceCardState();
}

class _MoreBalanceCardState extends ConsumerState<MoreBalanceCard> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(12),
      width: 1.sw,
      decoration: BoxDecoration(
          color: wayaTheme.colorScheme.primar50,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            const Gap(10),
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
                callback: () => WayaNav.toNamed(FundWalletOptionsScreen.route),
              ),
              SizedBox(width: 10.w),
              WayaButton(
                  horizontalPadding: 22,
                  height: 36.h,
                  border: Border.all(
                      width: 1, color: wayaTheme.colorScheme.customPrimary),
                  color: wayaTheme.colorScheme.transparent,
                  text: 'Learn More',
                  textStyle: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                      color: wayaTheme.colorScheme.customPrimary),
                  callback: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

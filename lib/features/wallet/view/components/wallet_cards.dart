// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/wallet/view/components/modal_content.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';

class InstructionContainer extends StatelessWidget {
  const InstructionContainer({
    super.key,
    required this.position,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
  final String position;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                height: 32.h,
                width: 32.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: wayaTheme.colorScheme.primar50),
                child: Text(position,
                    style: wayaTheme.textTheme.labelSmall
                        ?.wayaCopyWith(color: wayaTheme.colorScheme.black)),
              ),
              SizedBox(width: 10.w),
              Text(title,
                  style: wayaTheme.textTheme.titleMedium
                      ?.wayaCopyWith(color: wayaTheme.colorScheme.black)),
            ],
          ),
          SizedBox(height: 6.h),
          Text(description, style: wayaTheme.textTheme.labelMedium)
        ],
      ),
    );
  }
}

class WalletBalanceCard extends ConsumerStatefulWidget {
  const WalletBalanceCard({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WalletBalanceCardState();
}

class _WalletBalanceCardState extends ConsumerState<WalletBalanceCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(walletVmProvider.notifier).getUserWallet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(walletVmProvider);
    final wayaTheme = Theme.of(context);
    log("${viewModel.data}");
    return Container(
      padding: EdgeInsets.only(left: 20.w, top: 15.h, bottom: 20),
      width: 1.sw,
      decoration: BoxDecoration(
          image: DecorationImage(
            opacity: 0.2,
            image: AssetImage(WayaAssests.images.wallet.walletBg.path),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              wayaTheme.colorScheme.customPrimary,
              BlendMode.darken,
            ),
          ),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 5.h),
          Text('Total Balance',
              style: wayaTheme.textTheme.labelSmall
                  ?.wayaCopyWith(color: wayaTheme.colorScheme.greyColor100)),
          SizedBox(height: 10.h),
          WayaAmountFormatter(
            amount: double.parse(viewModel.data?.balance ?? "0"),
          ),
          const Gap(10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              WayaButton(
                text: 'Fund Wallet',
                horizontalPadding: 22,
                color: wayaTheme.colorScheme.onPrimary,
                height: 36.h,
                textStyle: wayaTheme.textTheme.labelSmall
                    ?.wayaCopyWith(color: wayaTheme.colorScheme.primary),
                callback: () => WayaNav.toNamed('/fund-wallet-page'),
              ),
              SizedBox(width: 10.w),
              WayaButton(
                  horizontalPadding: 22,
                  height: 36.h,
                  color: wayaTheme.colorScheme.onPrimary.withOpacity(0.4),
                  text: 'Learn More',
                  textStyle: wayaTheme.textTheme.labelSmall
                      ?.wayaCopyWith(color: wayaTheme.colorScheme.onPrimary),
                  callback: () => WayaUtils.showModalSheet(
                        context,
                        child: LearnMoreInstructionsContent(),
                      )),
            ],
          ),
        ],
      ),
    );
  }
}

class AccountDetailsCard extends StatelessWidget {
  const AccountDetailsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Container(
        decoration: BoxDecoration(
            color: wayaTheme.colorScheme.greyColor100,
            borderRadius: BorderRadius.circular(12.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Account Numbers',
                        style: wayaTheme.textTheme.hintStyle
                            .wayaCopyWith(color: wayaTheme.colorScheme.black),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        children: [
                          buildAccountDetails(wayaTheme,
                              accountType: 'Wayabank',
                              accountNumber: '1234567890'),
                          SizedBox(width: 12.w),
                          buildAccountDetails(wayaTheme,
                              accountType: '9PSB', accountNumber: '1234567890'),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Container buildAccountDetails(ThemeData wayaTheme,
      {required String accountType, required String accountNumber}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(accountType, style: wayaTheme.textTheme.labelSmall),
              SizedBox(height: 4.h),
              Text(accountNumber,
                  style: wayaTheme.textTheme.hintStyleSemiBold
                      .wayaCopyWith(color: wayaTheme.colorScheme.black)),
            ],
          ),
          SizedBox(width: 20.w),
          buildCopyButton(accountNumber, wayaTheme),
        ],
      ),
    );
  }
}

buildCopyButton(String text, ThemeData wayaTheme) {
  return InkWell(
    onTap: () {
      WayaUtils.copyText(text);
    },
    child: Container(
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        children: [
          Icon(Icons.copy_sharp,
              size: 12, color: wayaTheme.colorScheme.primary),
          SizedBox(width: 3.w),
          Text('Copy', style: wayaTheme.textTheme.hintStyle),
        ],
      ),
    ),
  );
}

class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({
    super.key,
    required this.iconPath,
    required this.paymentMethod,
    required this.description,
    this.onTap,
  });

  final SvgGenImage iconPath;
  final String paymentMethod;
  final String description;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: wayaTheme.colorScheme.onPrimary),
        child: Row(
          children: [
            Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: wayaTheme.colorScheme.primar50,
                  shape: BoxShape.circle,
                ),
                child: iconPath.svg(fit: BoxFit.none)),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(paymentMethod,
                    style: wayaTheme.textTheme.hintStyleSemiBold
                        .wayaCopyWith(color: wayaTheme.colorScheme.black)),
                SizedBox(height: 4.h),
                Text(description,
                    style: wayaTheme.textTheme.labelSmall
                        ?.wayaCopyWith(color: wayaTheme.colorScheme.black)),
              ],
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: wayaTheme.colorScheme.greyColor500,
            )
          ],
        ),
      ),
    );
  }
}
// class TransactionOverviewCard extends StatelessWidget {
//   final WalletProvider walletProvider;
//   const TransactionOverviewCard({
//     required this.walletProvider,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
//       decoration: BoxDecoration(
//         color: getAppColor(AppColors.grey100),
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Quick Overview', style: AppTextStyle.subtitle2.copyWith(color: AppColors.black)),
//           SizedBox(height: 10.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               OverViewContainer(
//                 title: 'Total Credit',
//                 totalAmount: walletProvider.totalCreditAmount.toDouble(),
//                 iconPath: 'assets/svg/arrow-circle-down.svg',
//                 iconColor: AppColors.success50,
//               ),
//               OverViewContainer(
//                 title: 'Total Debit',
//                 totalAmount: walletProvider.totalDebitAmount.toDouble(),
//                 iconPath: 'assets/svg/arrow-circle-up.svg',
//                 iconColor: AppColors.error50,
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

// class HistoryFilter extends StatefulWidget {
//   final WalletProvider walletProvider;
//   const HistoryFilter({
//     required this.walletProvider,
//     super.key,
//   });

//   @override
//   State<HistoryFilter> createState() => _HistoryFilterState();
// }

// class _HistoryFilterState extends State<HistoryFilter> {
//   List filter = ['This Month', 'This Week', 'Last 6 Months', 'This Year', 'Custom'];
//   String title = 'This month';
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.r), side: BorderSide(color: getAppColor(AppColors.fadedPrimary))),
//       menuPadding: EdgeInsets.symmetric(vertical: 0.h),
//       offset: Offset(0, 8),
//       position: PopupMenuPosition.under,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//         decoration: BoxDecoration(
//             color: getAppColor(AppColors.white),
//             borderRadius: BorderRadius.circular(6.r),
//             border: Border.all(color: getAppColor(AppColors.fadedPrimary))),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(title,
//                 style:
//                     AppTextStyle.subtitle2.copyWith(fontWeight: FontWeight.w600, color: getAppColor(AppColors.black3))),
//             SizedBox(width: 4.w),
//             ImageHelper.svgImage('assets/svg/drop-down-arrow-icon.svg')
//           ],
//         ),
//       ),
//       itemBuilder: (context) {
//         return [
//           PopupMenuItem(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: SizedBox(
//               width: 264.w,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Sort by',
//                     style: AppTextStyle.subtitle2
//                         .copyWith(fontWeight: FontWeight.w600, color: getAppColor(AppColors.black)),
//                   ),
//                   SizedBox(height: 4.h),
//                   Text('Choose filter',
//                       style: AppTextStyle.subtitle2
//                           .copyWith(fontWeight: FontWeight.w400, color: getAppColor(AppColors.grayColor2))),
//                 ],
//               ),
//             ),
//           ),
//           // Filter options with onTap actions
//           buildPopupMenuItem(
//               title: 'This Week',
//               isChecked: true,
//               onTap: () {
//                 context.read<WalletProvider>().toggleSearchVisibility(false);
//                 widget.walletProvider.filterTransactionHistory(
//                   widget.walletProvider.transactionLocalList,
//                   HistoryDate.thisWeek,
//                 );
//                 setState(() {
//                   title = filter[1];
//                 });
//               }),
//           buildPopupMenuItem(
//               title: 'This Month',
//               onTap: () {
//                 context.read<WalletProvider>().toggleSearchVisibility(false);
//                 widget.walletProvider.filterTransactionHistory(
//                   widget.walletProvider.transactionLocalList,
//                   HistoryDate.thisMonth,
//                 );
//                 setState(() {
//                   title = filter[1];
//                 });
//               }),
//           buildPopupMenuItem(
//               title: 'Last 6 Months',
//               onTap: () {
//                 context.read<WalletProvider>().toggleSearchVisibility(false);
//                 widget.walletProvider.filterTransactionHistory(
//                   widget.walletProvider.transactionLocalList,
//                   HistoryDate.last6Months,
//                 );
//                 setState(() {
//                   title = filter[2];
//                 });
//               }),
//           buildPopupMenuItem(
//               title: 'This Year',
//               onTap: () {
//                 context.read<WalletProvider>().toggleSearchVisibility(false);
//                 widget.walletProvider.filterTransactionHistory(
//                   widget.walletProvider.transactionLocalList,
//                   HistoryDate.thisYear,
//                 );
//                 setState(() {
//                   title = filter[3];
//                 });
//               }),
//           buildPopupMenuItem(
//               title: 'Custom Date Range',
//               onTap: () {
//                 context.read<WalletProvider>().toggleSearchVisibility(false);
//                 setState(() {
//                   title = filter[4];
//                 });
//                 showModalBottomSheet(
//                     context: context,
//                     builder: (context) {
//                       return TransactionFilterContent();
//                     });
//               }),
//         ];
//       },
//     );
//   }
// }

// PopupMenuItem<dynamic> buildPopupMenuItem({
//   required String title,
//   required VoidCallback onTap,
//   bool hasCheckbox = false,
//   bool isChecked = false,
// }) {
//   return PopupMenuItem(
//     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//     onTap: onTap,
//     child: Row(mainAxisSize: MainAxisSize.min, children: [
//       Text(
//         title,
//         style: AppTextStyle.subtitle2.copyWith(
//           fontWeight: FontWeight.w400,
//           color: getAppColor(AppColors.black3),
//         ),
//       ),
//       // if (hasCheckbox) ...[
//       //   Spacer(),
//       hasCheckbox
//           ? Checkbox(
//               shape: CircleBorder(),
//               value: isChecked,
//               onChanged: (_) {},
//               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//             )
//           : SizedBox.shrink(),
//     ]
//         //],
//         ),
//   );
// }

// class OverViewContainer extends StatelessWidget {
//   const OverViewContainer({
//     super.key,
//     required this.title,
//     required this.iconPath,
//     required this.iconColor,
//     required this.totalAmount,
//   });

//   final String title;
//   final String iconPath;
//   final Color iconColor;
//   final double totalAmount;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(8.0),
//       decoration: BoxDecoration(color: getAppColor(AppColors.white), borderRadius: BorderRadius.circular(8.r)),
//       child: Row(
//         children: [
//           Container(
//             height: 32.h,
//             width: 32.w,
//             decoration: BoxDecoration(color: getAppColor(iconColor), borderRadius: BorderRadius.circular(6.4.r)),
//             child: ImageHelper.svgImage(iconPath, fit: BoxFit.scaleDown),
//           ),
//           SizedBox(width: 16.w),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.w400, color: getAppColor(AppColors.black1)),
//               ),
//               SizedBox(height: 4.h),
//               TextAmountFormatter(
//                   amount: totalAmount,
//                   textStyle:
//                       AppTextStyle.subtitle2.copyWith(fontWeight: FontWeight.w600, color: getAppColor(AppColors.black)))
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

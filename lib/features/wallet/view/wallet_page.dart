import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/wallet/view/components/wallet_cards.dart';

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
    return WayaScaffold(
      color: wayaTheme.colorScheme.scaffoldColor2,
      title: 'Wallet',
      body: Column(
        children: [
          WalletBalanceCard(),
          Gap(10),
          AccountDetailsCard(),
          Gap(20),
          _buildHistoryHeader(wayaTheme),
          Gap(Get.height * 0.05),
          WayaAssests.images.wallet.searchDocu.image(scale: 1.5),
          Text('No transaction yet', style: wayaTheme.textTheme.headlineMedium),
          SizedBox(
            width: 310,
            child: Text(
              'Looks like you haven’t performed any transaction yet',
              textAlign: TextAlign.center,
              style: wayaTheme.textTheme.labelMedium?.wayaCopyWith(color: wayaTheme.colorScheme.greyColor500),
            ),
          ),
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
          child: Text(
            'See All',
            style: wayaTheme.textTheme.titleMedium?.wayaCopyWith(color: wayaTheme.colorScheme.primary500),
          ),
        ),
      ],
    );
  }
}


// class WalletScreen extends StatefulWidget {
//   const WalletScreen({super.key});

//   static const route = '/wallet';

//   @override
//   State<WalletScreen> createState() => _WalletScreenState();
// }

// class _WalletScreenState extends State<WalletScreen> {


//   @override
//   Widget build(BuildContext context) {
   
//       return WayaScaffold(
//           backgroundColor: getAppColor(AppColors.grey50),
//           title: 'Wallet',
//           body: RefreshIndicator(
//             onRefresh: () async {
//               await walletProvider.getTransaction(
//                 limit: '1',
//               );
//               Future.value();
//             },
//             child: Column(
//               children: [
//                 WalletBalanceCard(),
//                 SizedBox(height: 10.h),
//                 AccountDetailsCard(),
//                 SizedBox(height: 15.h),
//                 _buildHistoryHeader(context),
//                 SizedBox(height: 15.h),
//                 walletProvider.transactionData.loading
//                     ? Column(
//                         children: [
//                           Gap(Get.height * 0.2),
//                           buildLoader(),
//                         ],
//                       )
//                     : walletProvider.transactionData.data == null
//                         ? buildReloadButton(() {
//                             walletProvider.getTransaction(
//                               limit: '10',
//                             );
//                           })
//                         : walletProvider.transactionData.data!.data!.isEmpty
//                             ? buildNoTransactionState()
//                             : Expanded(
//                                 child: ListView.separated(
//                                   itemBuilder: (context, index) {
//                                     return TransactionListTile(
//                                       transactionDetails: walletProvider.transactionData.data!.data![index],
//                                     );
//                                   },
//                                   separatorBuilder: (context, index) {
//                                     return SizedBox(height: 8.h);
//                                   },
//                                   itemCount: walletProvider.transactionData.data!.data!.length >= 7
//                                       ? 7
//                                       : walletProvider.transactionData.data!.data!.length,
//                                 ),
//                               )
//               ],
//             ),
//           ));
   
//   }

//   Widget buildReloadButton(Function()? reCall) {
//     return buildReloadBtn(reCall);
//   }

//   Column buildNoTransactionState() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Gap(Get.height * 0.08),
//         Image.asset(
//           'assets/images/empty.png',
//           scale: 2,
//         ),
//         Gap(20),
//         Text(
//           'No Transaction yet',
//           style: AppTextStyle.headline6.copyWith(color: AppColors.black),
//         ),
//         Gap(10),
//         SizedBox(
//           child: Text(
//             'Looks like you haven’t performed any transaction yet',
//             textAlign: TextAlign.center,
//             style: AppTextStyle.bodyText1.copyWith(color: AppColors.grayColor2, fontWeight: FontWeight.w400),
//           ),
//         )
//       ],
//     );
//   }

//   Row _buildHistoryHeader(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           'Transaction History',
//           style: AppTextStyle.subtitle2
//               .copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: getAppColor(AppColors.onBackground)),
//         ),
//         context.watch<WalletProvider>().transactionData.data?.data?.isEmpty ?? true
//             ? SizedBox.shrink()
//             : GestureDetector(
//                 onTap: () => Navigator.of(context).pushNamed(TransactionHistoryScreen.route),
//                 child: Text(
//                   'See All',
//                   style: AppTextStyle.subtitle2
//                       .copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: getAppColor(AppColors.primary)),
//                 ),
//               ),
//       ],
//     );
//   }
// }

// class TransactionListTile extends StatelessWidget {
//   final TransactionData transactionDetails;
//   const TransactionListTile({
//     required this.transactionDetails,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: () => Navigator.of(context).pushNamed(TransactionDetails.route, arguments: transactionDetails),
//       contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
//       tileColor: getAppColor(AppColors.white),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
//       leading: Container(
//         height: 36.w,
//         width: 36.w,
//         decoration: BoxDecoration(shape: BoxShape.circle, color: getAppColor(AppColors.lightPeach)),
//         child: ImageHelper.svgImage('assets/svg/wallet-03.svg', fit: BoxFit.scaleDown),
//       ),
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             transactionDetails.transactionCategory ?? 'n/a',
//             style: AppTextStyle.subtitle2.copyWith(color: getAppColor(AppColors.black3)),
//             overflow: TextOverflow.ellipsis,
//           ),
//           SizedBox(height: 4.h),
//           buildChip(color: AppHelper.getColor(transactionDetails.type), text: transactionDetails.type),
//         ],
//       ),
//       trailing: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextAmountFormatter(
//               inFlow: AppHelper.getInflow(transactionDetails.type),
//               amount: transactionDetails.amount?.toDouble() ?? 0.0,
//               textStyle: AppTextStyle.caption
//                   .copyWith(fontWeight: FontWeight.w400, color: AppHelper.getColor(transactionDetails.type))),
//           Text(DateFormatterUtil.formatDateAndTime(transactionDetails.createdAt.toString()),
//               style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.w400, color: AppColors.black3))
//         ],
//       ),
//     );
//   }
// }




// class FundWallet extends StatelessWidget with WalletMixin {
//   static const route = '/fund-wallet';
//   const FundWallet({super.key});

//   @override
//   Widget build(BuildContext context) {
   
//       return CustomScaffold(
//         backgroundColor: Color.fromARGB(255, 248, 249, 250),
//         isLoading: wallet.thirdPartyPaymentData.loading,
//         title: 'Fund Wallet',
//         body: SizedBox(
//           height: 1.sh,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
       
//               Text(
//                 'Select Payment Method',
//                 style: AppTextStyle.headline6
//                     .copyWith(fontWeight: FontWeight.w700, color: getAppColor(AppColors.onBackground)),
//               ),
            
//               Text(
//                 'Choose the way you want to fund your \naccount',
//                 style: AppTextStyle.subtitle1.copyWith(color: getAppColor(AppColors.grayColor2)),
//               ),
       
//               PaymentMethodTile(
//                 iconPath: 'assets/svg/wallet-03.svg',
//                 paymentMethod: 'Fund with Bank Transfer',
//                 description: 'Add money via mobile or internet banking',
//                 onTap: () => Navigator.of(context).pushNamed(FundWithBankTransfer.route),
//               ),
           
       
//               PaymentMethodTile(
//                 iconPath: 'assets/svg/credit-card.svg',
//                 paymentMethod: 'Fund with WayaQuick Card',
//                 description: 'Add money directly from your bank card',
//                 onTap: () async {
//                   // Navigator.of(context).pushNamed(FundWithBankAccount.route, arguments: true);
//                 },
//               ),
             
//               PaymentMethodTile(
//                 iconPath: 'assets/svg/credit-card.svg',
//                 paymentMethod: 'Fund with Paystack Card',
//                 description: 'Add money directly from your bank card',
//                 onTap: () async {
//                 },
//               ),
//             ],
//           ),
//         ),
//       );
    
//   }
// }

// class PaymentMethodListTile extends StatelessWidget {
//   const PaymentMethodListTile({
//     super.key,
//     required this.iconPath,
//     required this.paymentMethod,
//     required this.description,
//     this.onTap,
//   });

//   final String iconPath;
//   final String paymentMethod;
//   final String description;
//   final void Function()? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//         decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: getAppColor(AppColors.background)),
//         child: Row(
//           children: [
//             Container(
//               height: 40.h,
//               width: 40.w,
//               decoration: BoxDecoration(shape: BoxShape.circle, color: getAppColor(AppColors.lightPeach)),
//               child: ImageHelper.svgImage(fit: BoxFit.scaleDown, height: 16.5.h, width: 18.75.w, iconPath),
//             ),
//             SizedBox(width: 8.w),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(paymentMethod, style: AppTextStyle.subtitle2.copyWith(color: getAppColor(AppColors.onBackground))),
//                 SizedBox(height: 4.h),
//                 Text(description,
//                     style: AppTextStyle.caption
//                         .copyWith(fontWeight: FontWeight.w400, color: getAppColor(AppColors.grayColor2)))
//               ],
//             ),
//             Spacer(),
//             Icon(Icons.arrow_forward_ios_rounded, size: 12, color: getAppColor(AppColors.grayColor2))
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FundWalletListTile extends StatelessWidget {
//   const FundWalletListTile({
//     super.key,
//     required this.iconPath,
//     required this.title,
//     required this.subtitle,
//     this.onTap,
//   });

//   final String iconPath;
//   final String title;
//   final String subtitle;
//   final void Function()? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: EdgeInsets.zero,
//       onTap: onTap,
//       leading: Container(
//         padding: EdgeInsets.all(12.0),
//         decoration: BoxDecoration(shape: BoxShape.circle, color: getAppColor(AppColors.fadedPrimary)),
//         child: ImageHelper.svgImage(iconPath),
//       ),
//       title: Text(title, style: AppTextStyle.subtitle2.copyWith(color: getAppColor(AppColors.onBackground))),
//       subtitle: Text(
//         subtitle,
//         style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.w400, color: getAppColor(AppColors.black3)),
//       ),
//       trailing: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: getAppColor(AppColors.black3)),
//     );
//   }
// }

// class WalletDetailsContainer extends StatelessWidget {
//   const WalletDetailsContainer({
//     super.key,
//     required this.title,
//     required this.details,
//   });

//   final String title;
//   final String details;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           title,
//           style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.w400, color: getAppColor(AppColors.grayColor2)),
//         ),
//         SizedBox(height: 4.h),
//         Text(
//           details,
//           style: AppTextStyle.headline5.copyWith(color: getAppColor(AppColors.black3)),
//         )
//       ],
//     );
//   }
// }

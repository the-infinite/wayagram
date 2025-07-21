import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/auth/forgot_password/vm/credential_input_vm.dart';
import 'package:wayagram/features/donation/donation_modal/donation_modal.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/polls_and_voting/data/model/payout_review_model.dart';
import 'package:wayagram/features/polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';
import 'package:wayagram/features/polls_and_voting/views/payout_verification.dart';
import 'package:wayagram/features/wallet/transactions/view/payout_history.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';
import 'package:wayagram/shared/components/engagement_range.dart';

import '../../../shared/features/user/models/default.dart';
import '../../auth/upgrade_to_business/views/upgrade_to_business.dart';
import '../../chat/state/default.dart';

class DonationDashboard extends ConsumerStatefulWidget {
  static const route = '/donationDashboard';
  const DonationDashboard({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DonationDashboardState();
}

class _DonationDashboardState extends ConsumerState<DonationDashboard> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(walletVmProvider.notifier).getPayoutMethod();
      ref.read(donationVmProvider.notifier).getPayoutCommission();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(donationVmProvider);
    final walletViewModel = ref.watch(walletVmProvider);
    final wayaTheme = Theme.of(context);
    final dynamic args = ModalRoute.of(context)?.settings.arguments;
    debugPrint('DAYSLEFT Is DASHBOARD ===>> ${args['daysLeft']}');
    return WayaScaffold(
      title: "Donation Dashboard",
      isLoading: viewModel.isLoading,
      isScrollable: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            args['title'],
            style: TextStyle()
                .wayaCopyWith(color: wayaTheme.colorScheme.black, fontSize: 24.sp, fontWeight: FontWeight.w700),
          ),
          Gap(10),
          WayaImage(
              imageUrl: args['image'],
              height: 180.h,
              width: double.infinity,
              radius: BorderRadius.all(Radius.circular(12))),
          Gap(10),
          EngagementRange(
            topLeft:
                "${WayaHelpers.formatPrice(int.parse('${args['amountRaised']}'))} raised from ${WayaHelpers.formatPrice(int.parse('${args['targetAmount']}'))}",
            bottomLeft: "${args['donationCount']} Donations",
            bottomRight: "${args['daysLeft']} days left",
            range: 0.0,
          ),
          Gap(10),
          Row(
            children: [
              Expanded(
                child: _detailCard(WayaHelpers.formatPrice(int.parse('${args['amountRaised']}')), 'Amount Raised',
                    wayaTheme.colorScheme.success50),
              ),
              Gap(10),
              Expanded(
                child: _detailCard(WayaHelpers.formatPrice(int.parse('${args['targetAmount']}')), 'Target Amount',
                    wayaTheme.colorScheme.pendingColor),
              )
            ],
          ),
          Gap(20),
          Text(
            "Donation Information",
            style: TextStyle()
                .wayaCopyWith(color: wayaTheme.colorScheme.greyColor400, fontSize: 12.sp, fontWeight: FontWeight.w400),
          ),
          Gap(20),
          _reviewText('Cause Title', '${args['title']}'),
          Gap(10),
          _reviewText('Cause Description', '${args['desc']}'),
          Gap(10),
          _reviewText('Proposed Solution', '${args['solution']}'),
          Gap(10),
          _reviewText('Impact Statement', '${args['impact']}'),
        ],
      ),
      bottomNavigationBar: args['daysLeft'] == '0'
          ? Container(
        height: 120.h,
        padding: EdgeInsets.fromLTRB(10, 4, 10, 10),
            child: Column(
              children: [
                WayaButton(

                    callback: !viewModel.isLoading
                        ? () {
                      final percentage =
                          '${(double.parse(viewModel.commission) / 100) * num.parse('${args['amountRaised']}')}';
                      final amountDue = double.parse('${args['amountRaised']}') - double.parse(percentage);

                      if(walletViewModel.payoutMethod.isEmpty){
                        WayaUtils.showModalSheet(
                          context,
                          child: AddPayoutModal(),
                        );
                      }else if(args['amountRaised'] == 0){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'No revenue was generated from this donation.' ,
                              style: TextStyle(fontFamily: WayaConstants.fontFamily, fontSize: 12.sp),
                            ),
                            backgroundColor: WayaColors.primary,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }else{
                        ref
                            .read(credentialInputProvider.notifier)
                            .onSubmitPayoutPin(() => WayaNav.toNamed('/payoutVerification', arguments: {
                          "id": args['id'],
                          "Module": PayoutModule.donation,
                          "Model": PayoutReviewModel(
                              comission: percentage,
                              amount: '${args['amountRaised']}',
                              amountDue: '$amountDue',
                              endDate: args['endDate'])
                        }));
                      }



                          }
                        : null,
                    centerWidget: LoadingState(loading: viewModel.isLoading, text: 'Request Payout'),
                  ),
                Gap(10),
                GestureDetector(
                  onTap: () {
                    // "ECOMMERCE" "CONTEST" "DONATION" "POLL & VOTE" "QUOTATION" "EVENT" "COMMISSION",
                    WayaNav.toNamed(PayoutHistory.route, arguments: {
                      "referenceId": args['id'] ?? "",
                      "Module": 'DONATION'
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: REdgeInsets.symmetric(
                        vertical: 8.dg, horizontal: 12.dg),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: wayaTheme.colorScheme.primary600,
                        width: 1.5,
                      ),
                      color: wayaTheme.colorScheme.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Payout History',
                          style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                            color: wayaTheme.colorScheme.primary600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
          : Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(10, 4, 10, 10),
              decoration: BoxDecoration(
                color: wayaTheme.colorScheme.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: context.width * 0.45,
                    child: WayaButton(
                      centerWidget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/share.svg',
                            colorFilter: ColorFilter.mode(wayaTheme.colorScheme.primary300, BlendMode.srcIn),
                          ),
                          const Gap(10),
                          Text(
                            "Share Invite",
                            style: TextStyle().wayaCopyWith(
                                color: wayaTheme.colorScheme.customPrimary, fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ],
                      ),
                      border: Border.all(width: 1, color: wayaTheme.colorScheme.primary500),
                      callback: () {
                        Share.share('${args['url']}', subject: 'Share Options');
                      },
                      color: wayaTheme.colorScheme.white,
                    ),
                  ),
                  const Gap(8),
                  SizedBox(
                    width: context.width * 0.45,
                    child: WayaButton(
                        text: 'Set Minimum amount',
                        color: wayaTheme.colorScheme.primary500,
                        textStyle: TextStyle(color: wayaTheme.colorScheme.white),
                        callback: () {
                          if (viewModel.kycStatus != 'APPROVED' &&
                              ConversationState.self.accountType == UserAccountType.business) {
                            WayaUtils.showNotice(
                                context: context,
                                title: "Update KYC Information ",
                                message: 'You must complete KYC verification before setting minimum amount.',
                                onPress: () {
                                  WayaNav.goBack();
                                  WayaNav.toNamed('/kycUpdate', arguments: {'kyc': '${viewModel.kycStatus}'});
                                },
                                buttonText: 'Update KYC',
                                secondButtonText: 'Cancel',
                                icon: Image.asset('assets/images/cp-shop.png'));
                          } else if (ConversationState.self.accountType == UserAccountType.personal) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              WayaUtils.showNotice(
                                  context: context,
                                  title: "You don't have a Business Account",
                                  message: 'Please upgrade to a business account to create a donation post',
                                  onPress: () {
                                    WayaNav.goBack();
                                    WayaNav.toNamed(UpgradeToBusiness.route);
                                  },
                                  buttonText: 'Upgrade to Business',
                                  secondButtonText: 'Cancel',
                                  icon: Image.asset('assets/images/cp-shop.png'));
                            });
                          } else {
                            WayaUtils.showModalSheet(
                              context,
                              child: DonationAmountSetupModal(
                                id: args['id'],
                              ),
                            );
                          }
                        }),
                  )
                ],
              ),
            ),
    );
  }

  _detailCard(number, name, color) {
    return Container(
      width: 122.w,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 17),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 12.sp, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.greyColor500),
            ),
          ),
          const Gap(10),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              number,
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24.sp, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.black),
            ),
          ),
        ],
      ),
    );
  }

  _reviewText(title, subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
              fontSize: 14.sp, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.greyColor500),
        ),
        Text(
          subTitle,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .wayaCopyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.black),
        ),
      ],
    );
  }
}

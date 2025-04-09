import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/donation/donation_modal/donation_modal.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/promotion/data/models/promotion_service_type.dart';
import 'package:wayagram/features/promotion/views/promote.dart';
import 'package:wayagram/shared/components/engagement_range.dart';

class DonationDetails extends ConsumerStatefulWidget {
  static const route = '/donationDetails';
  const DonationDetails({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DonationDetailsState();
}

class _DonationDetailsState extends ConsumerState<DonationDetails>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final dynamic args = ModalRoute.of(context)?.settings.arguments;
      ref.read(donationVmProvider.notifier).getSingleDonation('${args['id']}');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(donationVmProvider);
    final wayaTheme = Theme.of(context);
    final dynamic args = ModalRoute.of(context)?.settings.arguments;

    return WayaScaffold(
      title: "Donation Details",
      isLoading: viewModel.isLoading,
      isScrollable: true,
      appBarTrailing: DonationAction(
          donationId: args['id'],
          isUser: ConversationState.self.id == args['organizerId']),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${args['title']}',
            style: TextStyle().wayaCopyWith(
                color: wayaTheme.colorScheme.black,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700),
          ),
          Gap(10),
          WayaImage(
              imageUrl: '${args['image']}',
              height: 180.h,
              width: double.infinity,
              radius: BorderRadius.all(Radius.circular(12))),
          Gap(10),
          EngagementRange(
            topLeft:
                "${WayaHelpers.formatPrice(int.parse('${args['amountRaised']}'))} raised from ${WayaHelpers.formatPrice(int.parse('${args['targetAmount']}'))}",
            bottomLeft: "${args['donationCount']} Donations",
            bottomRight:
                "${args['daysLeft']} ${args['daysLeft'] == '1' ? 'day' : 'days'} left",
            range: args['ratioLeft'],
            //range: args['donationCount'] == '0' ? 0.0 : 0.4
          ),
          Gap(10),
          Row(
            children: [
              Expanded(
                child: _detailCard(
                    WayaHelpers.formatPrice(
                        int.parse('${args['amountRaised']}')),
                    'Amount Raised',
                    wayaTheme.colorScheme.success50),
              ),
              Gap(10),
              Expanded(
                child: _detailCard(
                    WayaHelpers.formatPrice(
                        int.parse('${args['targetAmount']}')),
                    'Target Amount',
                    wayaTheme.colorScheme.pendingColor),
              )
            ],
          ),
          Gap(20),
          Text(
            "Donation Information",
            style: TextStyle().wayaCopyWith(
                color: wayaTheme.colorScheme.greyColor400,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400),
          ),
          Gap(20),
          _reviewText('Cause Title', '${args['title']}'),
          Gap(10),
          _reviewText('Cause  Description', '${args['desc']}'),
          Gap(10),
          _reviewText('Proposed Solution', '${args['solution']}'),
          Gap(10),
          _reviewText('Impact Statement', '${args['impact']}'),
        ],
      ),
      bottomNavigationBar: Container(
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
                      colorFilter: ColorFilter.mode(
                          wayaTheme.colorScheme.primary300, BlendMode.srcIn),
                    ),
                    const Gap(10),
                    Text(
                      "Share Invite",
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.customPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp),
                    ),
                  ],
                ),
                border: Border.all(
                    width: 1, color: wayaTheme.colorScheme.primary500),
                callback: () {
                  Share.share(
                    WayaValueHelper.getShareableUrl(
                        WayaAppRoutes.getDonationDetailsPage('${args['id']}')),
                    subject: 'Share Donation',
                  );
                  // Share.share('${args['url']}', subject: 'Share Options');
                },
                color: wayaTheme.colorScheme.white,
              ),
            ),
            const Gap(8),
            SizedBox(
              width: context.width * 0.45,
              child: WayaButton(
                  text: 'Donate',
                  color: wayaTheme.colorScheme.primary500,
                  textStyle: TextStyle(color: wayaTheme.colorScheme.white),
                  callback: () {
                    /* if(viewModel.kycStatus != 'APPROVED' && ConversationState.self.accountType == UserAccountType.business){
                  WayaUtils.showNotice(
                      context: context,
                      title: "Update KYC Information ",
                      message: 'You must complete KYC verification before you can donate.',
                      onPress: () {
                        WayaNav.goBack();
                        WayaNav.toNamed('/kycUpdate', arguments: {
                          'kyc': '${viewModel.kycStatus}'
                        });
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
                } else{
                  WayaUtils.showModalSheet(
                    context,
                    child: DonationModal(
                        amountRaised: '${args['amountRaised']}',
                        targetAmount: '${args['targetAmount']}',
                        title: '${args['title']}',
                        minimumDonationAmount: '${args['minimumDonationAmount']}',
                        campaignId: '${args['id']}',
                        privacy: '${args['privacy']}',
                        daysLeft: '${args['daysLeft']}',
                        donationCount: '${args['donationCount']}'
                    ),
                  );
                }*/
                    WayaUtils.showModalSheet(
                      context,
                      child: DonationModal(
                          amountRaised: '${args['amountRaised']}',
                          targetAmount: '${args['targetAmount']}',
                          title: '${args['title']}',
                          minimumDonationAmount:
                              '${args['minimumDonationAmount']}',
                          campaignId: '${args['id']}',
                          privacy: '${args['privacy']}',
                          daysLeft: '${args['daysLeft']}',
                          donationCount: '${args['donationCount']}'),
                    );
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
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.greyColor500),
            ),
          ),
          const Gap(10),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              number,
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.black),
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
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.greyColor500),
        ),
        Text(
          subTitle,
          style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.black),
        ),
      ],
    );
  }
}

class DonationAction extends StatelessWidget {
  final String donationId;
  final bool isUser;

  // Construct.
  const DonationAction({
    super.key,
    required this.donationId,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return PopupMenuButton(
      onSelected: (value) {},
      iconColor: wayaTheme.colorScheme.greyColor400,
      position: PopupMenuPosition.under,
      itemBuilder: (context) {
        return [
          if (isUser)
            PopupMenuItem<int>(
              value: 2,
              onTap: () async {
                WayaNav.toNamed(Promote.route, arguments: {
                  "contentId": donationId,
                  "contentType": PromotionServiceType.donation.name
                });
              },
              child: WayaActionNav(
                context: context,
                color: wayaTheme.colorScheme.customBlack,
                asset: SvgPicture.asset(
                  WayaAssets.icons.mFire.path,
                  color: wayaTheme.colorScheme.customBlack,
                ),
                text: "Promote Donation",
              ),
            ),
        ];
      },
    );
  }
}

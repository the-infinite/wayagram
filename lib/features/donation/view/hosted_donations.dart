import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';
import 'package:wayagram/features/auth/upgrade_to_business/views/upgrade_to_business.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/donation/model/my_donation_model.dart';
import 'package:wayagram/features/donation/view/application_details.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/donation/widget/applied_donationi_widget.dart';
import 'package:wayagram/features/donation/widget/manage_donation_widget.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

import '../../../shared/features/user/models/default.dart';
import 'dart:io' show Platform;

class HostedDonations extends ConsumerStatefulWidget {
  final bool isExpanded;
  const HostedDonations({super.key,  this.isExpanded = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HostedDonationsState();
}

class _HostedDonationsState extends ConsumerState<HostedDonations> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(donationVmProvider.notifier).getHostedDonation();
      ref.read(donationVmProvider.notifier).getAppliedDonation();
      ref.read(donationVmProvider.notifier).getMyKYC();
    });
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {});
    });
  }



  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(donationVmProvider);
    final wayaTheme = Theme.of(context);
    final dynamic args = ModalRoute.of(context)?.settings.arguments;

    final state = ref.watch(donationVmProvider);

    // Filter the myDonations
    final filteredMyDonations = WayaUtils.search<MyDonationDocs>(
      viewModel.myDonationDocs!,
      [
        'title',
      ],
      searchController.text,
    );

    List<MyDonationDocs>? myDonations = widget.isExpanded
        ? state.myDonationDocs
        : state.myDonationDocs!.sublist(0, min(state.myDonationDocs!.length, 1));

    return SizedBox(
      height: 560,
      child: ListView(
       // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WayaButton(
            centerWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/donation.svg',
                  colorFilter: ColorFilter.mode(
                      wayaTheme.colorScheme.primary300, BlendMode.srcIn),
                ),
                const Gap(10),
                Text(
                  "Create a Donation Post",
                  style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.customPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp),
                ),
              ],
            ),
            callback: () {
              if(viewModel.kycStatus != 'APPROVED' && ConversationState.self.accountType == UserAccountType.business){
                WayaUtils.showNotice(
                    context: context,
                    title: "Update KYC Information ",
                    message: 'You must complete KYC verification before creating a donation post',
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
                      onPress:  () {
                        WayaNav.goBack();
                        WayaNav.toNamed(UpgradeToBusiness.route);
                      },
                      buttonText: 'Upgrade to Business',
                      secondButtonText: 'Cancel',
                      icon: Image.asset('assets/images/cp-shop.png'));
                });
              } else{
                WayaNav.toNamed('/createDonation');
              }
            },
            color: wayaTheme.colorScheme.primary50,
          ),
          Gap(20),
          FilterWidget(
              search: TextEditingController(), hintText: 'Search Donations'),
          Gap(20),
          Text("Approved Donations", style: wayaTheme.textTheme.titleLarge),
          Row(
            children: [
              Text(
                "See and manage all your approved donations",
                style: WayaTextStyles.bodySmall.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.greyColor500),
              ),
              Spacer(),
              InkWell(
                onTap: (){
                  WayaNav.toNamed('/seeAllApprovedDonations');
                },
                child: Text(
                  "See All",
                  style: WayaTextStyles.bodySmall.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.primary500),
                ),
              ),
            ],
          ),
          const Gap(10),
          viewModel.approvedDonations!.isEmpty ? ActivityLogsEmptyState(text: 'You don\'t have approved donations yet',):
          SizedBox(
            height: Platform.isAndroid ? 350 : 250,
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 20),
                shrinkWrap: true,
                itemCount: viewModel.approvedDonations?.length,
                //viewModel.myDonationDocs?.length,
                //filteredMyDonations.length,
                itemBuilder: (context, index) {
                  //final donation = filteredMyDonations[index];
                  final donation = viewModel.approvedDonations?[index];
                  int daysLeft = DateTime.parse('${donation?.expirationDate}').difference(DateTime.parse('${donation?.startDate}')).inDays;

                  int amountRaised = double.parse('${donation?.amountRaised}').toInt();

                  int targetedAmount = double.parse('${donation?.targetAmount}').toInt();

                  double ratioLeft = amountRaised / targetedAmount;
                  return ManageDonationWidget(
                    text: "Manage Donation",
                    amountRaised: WayaHelpers.formatPrice(int.parse('${donation?.amountRaised?.replaceAll('.00', '')}')),
                    targetAmount: WayaHelpers.formatPrice(int.parse('${donation?.targetAmount?.replaceAll('.00', '')}')),
                    title: donation?.title?.capitalizeFirst,
                    image: donation?.imageURL,
                    dayLeft: daysLeft < 0 ? '0' : '$daysLeft',
                    donationCount: donation?.donationCount!,
                    rangeRatio: ratioLeft,
                    onTap: () {
                      WayaNav.toNamed('/donationManagement', arguments: {
                        'title': '${donation?.title?.capitalizeFirst}',
                        'image': '${donation?.imageURL}',
                        'amountRaised': '${donation?.amountRaised?.replaceAll('.00', '')}',
                        'targetAmount': '${donation?.targetAmount?.replaceAll('.00', '')}',
                        'desc': '${donation?.description}',
                        'solution': '${donation?.solution}',
                        'impact': '${donation?.impact}',
                        'url': '${donation?.url}',
                        'minimumDonationAmount': '${donation?.minimumDonationAmount}',
                        'daysLeft': '$daysLeft',
                        'id': '${donation?.id}',
                        'range':ratioLeft,
                        'donationCount': '${donation?.donationCount}'
                      });
                    },
                    buttonWidth: 120.0,
                  );
                }),
          ),
          const Gap(10),
          Text("Pending Donations", style: wayaTheme.textTheme.titleLarge),

          Row(
            children: [
              Text(
                "See and manage all your pending donations",
                style: WayaTextStyles.bodySmall.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.greyColor500),
              ),
              Spacer(),
              InkWell(
                onTap: (){
                  WayaNav.toNamed('/seeAllDonations');
                },
                child: Text(
                  "See All",
                  style: WayaTextStyles.bodySmall.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.primary500),
                ),
              ),
            ],
          ),
          const Gap(10),
          myDonations!.isEmpty ? ActivityLogsEmptyState(text: 'You don\'t have pending donations yet',):
          SizedBox(
            height: Platform.isAndroid ? 300 : 460,
            //height: Platform.isAndroid ? 560 : 460,
            child: ListView.builder(
              //physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: myDonations.length,
                //filteredMyDonations.length,
                itemBuilder: (context, index) {
                  final donation = myDonations![index];
                  //final donation = filteredMyDonations[index];
                  int daysLeft = DateTime.parse('${donation.expirationDate}').difference(DateTime.parse('${donation.startDate}')).inDays;

                  int amountRaised = double.parse('${donation.amountRaised}').toInt();

                  int targetedAmount = double.parse('${donation.targetAmount}').toInt();

                  double ratioLeft = amountRaised / targetedAmount;
                  return AppliedDonationWidget(
                    onTap: ()async{
                      await WayaUtils.showModalSheet(context,
                          child: ApplicationStatus(
                            causeTitle: '${donation.title?.capitalizeFirst}',
                            solution: '${donation.solution}',
                            desc: '${donation.description}',
                            startDate: ref.read(createPollVotingProvider.notifier).formatDonationDate('${donation.startDate}'),
                            endDate: ref.read(createPollVotingProvider.notifier).formatDonationDate('${donation.expirationDate}'),
                            targetAmount:'${donation.targetAmount?.replaceAll('.00', '')}',
                            amountRaised: '${donation.amountRaised?.replaceAll('.00', '')}',
                            status: donation.status == 'pending_approval'?'Pending':donation.status =='approved'?'Accepted':'Rejected',
                            privacy: '${donation.privacy}',
                            showRaised: donation.showRaised == true?'YES':'NO',
                            url: '${donation.url}',
                            image: '${donation.imageURL}',
                            id: '${donation.id}',
                            donationCount: donation.donationCount,
                            daysLeft: daysLeft,
                            impact: '${donation.impact}',
                            minimumDonationAmount: '${donation.minimumDonationAmount}',
                            ratioLeft: ratioLeft,
                          ));
                    },
                    privacy: '${donation.privacy?.capitalizeFirst}',
                    title: '${donation.title}',
                    status: donation.status == 'pending_approval'?'Pending':donation.status =='approved'?'Accepted':'Rejected',
                    image: '${donation.imageURL}',
                    targetAmount: WayaHelpers.formatPrice(int.parse('${donation.targetAmount?.replaceAll('.00', '')}')),
                    startDate: ref.read(createPollVotingProvider.notifier).formatDt1('${donation.startDate}'),
                    endDate: ref.read(createPollVotingProvider.notifier).formatDt1('${donation.expirationDate}'),
                    color:donation.status == 'pending_approval'? WayaColors.pendingColor: donation.status =='approved'? WayaColors.success50: WayaColors.error50,
                    textColor:donation.status == 'pending_approval'? WayaColors.pendingColor2 :donation.status =='approved'? WayaColors.success: WayaColors.error,
                  );

                }),
          ),
          const Gap(30),
       /*   Expanded(
      child: PaginatedDataView<MyDonationDocs>(
      uniqueKey: 'Hosted-donations',
      loadingState: SizedBox(
      height: context.height * 0.4,
      child: Center(
      child: CircularProgressIndicator(),
      )),
      emptyState:DonationEmptyState(),
      fetchData: ref.read(donationVmProvider.notifier).getHostedDonation,
      result: (data, s ) {
      return ListView.builder(
      //physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: viewModel.myDonationDocs?.length,
      itemBuilder: (context, index){
      final donation = viewModel.myDonationDocs?[index];
      int daysLeft = DateTime.parse('${donation?.expirationDate}').day;
      return ManageDonationWidget(
      text:  "Donate",
      amountRaised: donation?.amountRaised,
      targetAmount: donation?.targetAmount,
      title: donation?.title?.capitalizeFirst,
      image: donation?.imageURL,
      dayLeft: '$daysLeft',
      onTap: (){
      WayaNav.toNamed('/donationDetails');
      },
      buttonWidth: 60.0,
      );
      }
      );
      },),
      );*/
        ],
      ),
    );

  }
}



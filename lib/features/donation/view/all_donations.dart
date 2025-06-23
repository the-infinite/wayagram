
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/upgrade_to_business/views/upgrade_to_business.dart';
import 'package:wayagram/features/donation/model/all_donation_model.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/donation/widget/donation_empty_state.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
import '../../chat/state/default.dart';
import '../widget/manage_donation_widget.dart';

class AllDonations extends ConsumerStatefulWidget {
  const AllDonations({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllDonationsState();
}

class _AllDonationsState extends ConsumerState<AllDonations> {

  late TextEditingController searchController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(donationVmProvider.notifier).getAllDonation(page: 1);
      ref.read(donationVmProvider.notifier).getMyKYC();
      ref.read(donationVmProvider.notifier).fetchCategory();
    });
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   final  viewModel = ref.watch(donationVmProvider);
    final wayaTheme = Theme.of(context);
   final dynamic args  = ModalRoute.of(context)?.settings.arguments;
   debugPrint('DONATION ARGS $args');

   // Filter the allDonations
   final filteredAllDonations = WayaUtils.search<AllDonationDocs>(
     viewModel.allDonationDocs!,
     ['title', ],
     searchController.text,
   );


    return Expanded(
      child: ListView(
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
                      color: wayaTheme.colorScheme.customPrimary, fontWeight: FontWeight.w600, fontSize: 16.sp),
                ),
              ],
            ),
            callback: () async{

              await ref.read(donationVmProvider.notifier).getMyKYC();
              debugPrint('KYc STATUS ==> ${viewModel.kycStatus}');
              if (ConversationState.self.accountType == UserAccountType.personal) {
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
                return;
              }
              if(viewModel.kycStatus != 'APPROVED'){
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
              }
              else{
                WayaNav.toNamed('/createDonation');
              }
            },
            color: wayaTheme.colorScheme.primary50,
            isLoading: viewModel.isLoading,
          ),
          Gap(20),
          FilterWidget(
              search: searchController,
              hintText: 'Search Donations'),
          Gap(20),
          Text("Featured Donations",
              style: wayaTheme.textTheme.titleLarge),
          Text(
              "Support a Cause That Matters",
              style: WayaTextStyles.bodySmall.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.greyColor500 ),),
          const Gap(30),
          filteredAllDonations.isEmpty ? DonationEmptyState(title: "You haven't added any donations yet",) :
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredAllDonations.length,
              itemBuilder: (context, index){
                final donation = filteredAllDonations[index];
                int daysLeft = DateTime.parse('${donation.expirationDate}').difference(DateTime.parse('${donation.startDate}')).inDays;
                int amountRaised = double.parse(donation.amountRaised!).toInt();

                int targetedAmount = double.parse(donation.targetAmount!).toInt();

                double ratioLeft = amountRaised / targetedAmount;

                return ManageDonationWidget(
                  text:  "Donate",
                  amountRaised: donation.showRaised == true  ? WayaHelpers.formatPrice(int.parse('${donation.amountRaised?.replaceAll('.00', '')}')) : '',
                  targetAmount: WayaHelpers.formatPrice(int.parse('${donation.targetAmount?.replaceAll('.00', '')}')),
                  title: donation.title?.capitalizeFirst,
                  image: donation.imageURL,
                  dayLeft: daysLeft < 0  ? '0' : '$daysLeft',
                  donationCount: donation.donationCount,
                  rangeRatio: ratioLeft,
                  onTap: (){
                    debugPrint('MY RATIO $daysLeft');
                    WayaNav.toNamed('/donationDetails',
                        arguments: {
                          'title':'${donation.title?.capitalizeFirst}',
                          'image':'${donation.imageURL}',
                          'amountRaised': '${donation.amountRaised?.replaceAll('.00', '')}',
                          'targetAmount': '${donation.targetAmount?.replaceAll('.00', '')}',
                          'desc': '${donation.description}',
                          'solution': '${donation.solution}',
                          'impact': '${donation.impact}',
                          'url': '${donation.url}',
                          'minimumDonationAmount':'${donation.minimumDonationAmount}',
                          'daysLeft':'$daysLeft',
                          'privacy':'${donation.privacy}',
                          'id': '${donation.id}',
                          'donationCount': '${donation.donationCount}',
                          'ratioLeft': ratioLeft,
                          'organizerId': donation.organizerId,
                          "donation": donation
                        });
                  },
                  buttonWidth: 60.0,
                );
              }
          ),
          Gap(20),
          Text("Based On Categories",
              style: wayaTheme.textTheme.titleLarge),
          Text(
            "View donations based on their categories",
            style: WayaTextStyles.bodySmall.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.greyColor500 ),),
          const Gap(10),
          SizedBox(
            height: 50.h,
            child: ListView.builder(
              itemCount: 1 + viewModel.categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {

                //? For you kini, shey you get?
                if (index == 0) {
                  // First
                  return  Row(
                    children: [
                      const Gap(6),
                      WayaButton(
                        callback: () {
                          ref.read(donationVmProvider.notifier).getAllDonation(page: 1);

                        },
                        border: Border.all(
                            color:
                            viewModel.selected.contains(viewModel.categories[0].value)
                            ? wayaTheme.colorScheme.primary50 :
                            wayaTheme.colorScheme.greyColor300),
                        horizontalPadding: 8,
                        color:
                         viewModel.selected.contains(viewModel.categories[0].value)
                         ? wayaTheme.colorScheme.primary50 :
                        wayaTheme.colorScheme.transparent,
                        radius: 10,
                        height: 40,
                        centerWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            SizedBox(
                              width: 2.w,
                            ),
                            Text('All Category',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: viewModel.selected.contains(viewModel.categories[index].value)?
                                  wayaTheme.colorScheme.customPrimary:
                                  WayaColors.greyColor400,
                                  fontFamily: WayaConstants.fontFamily,
                                  // overflow: TextOverflow.ellipsis,
                                ))
                          ],
                        ),
                      ),
                      const Gap(6),
                    ],
                  );
                }

                //? For the other user's kini.
                else {
                  // Others
                  final donation = viewModel.categories[index - 1];

                  //? Return this like this.
                  return Row(
                    children: [
                      WayaButton(
                        callback: () {
                          ref.read(donationVmProvider.notifier).updateSelectedCategory(donation);
                          ref.read(donationVmProvider.notifier).fetchDonationBasedOnCategory(donation.label);
                          },
                        border: Border.all(
                            color: viewModel.selected.contains(donation.value)
                             ? wayaTheme.colorScheme.primary50 :
                            wayaTheme.colorScheme.greyColor300),
                        horizontalPadding: 8,
                        color: viewModel.selected.contains(donation.value)
                         ? wayaTheme.colorScheme.primary50 :
                        wayaTheme.colorScheme.transparent,
                        radius: 10,
                        height: 40,
                        centerWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            SizedBox(
                              width: 2.w,
                            ),
                            Text(donation.label,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: viewModel.selected.contains(donation.value)?
                                  wayaTheme.colorScheme.customPrimary:
                                  WayaColors.greyColor400,
                                  fontFamily: WayaConstants.fontFamily,
                                ))
                          ],
                        ),
                      ),
                      const Gap(6),
                    ],
                  );
                }
              },
            ),
          ),
          const Gap(10),
          viewModel.myDonationDocs!.isEmpty ?DonationEmptyState(title: "You don't have any donation under this category yet",) :
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: viewModel.myDonationDocs?.length,
              itemBuilder: (context, index){
                final donation = viewModel.myDonationDocs?[index];
                int daysLeft = DateTime.parse('${donation?.expirationDate}').difference(DateTime.parse('${donation?.startDate}')).inDays;

                int amountRaised = double.parse('${donation?.amountRaised}').toInt();

                int targetedAmount = double.parse('${donation?.targetAmount}').toInt();

                double ratioLeft = amountRaised / targetedAmount;
                return ManageDonationWidget(
                  text: "Donate",
                  amountRaised: donation?.amountRaised,
                  targetAmount: WayaHelpers.formatPrice(double.parse('${donation?.targetAmount}').toInt()),
                  title: donation?.title?.capitalizeFirst,
                  image: donation?.imageURL,
                  dayLeft: '$daysLeft',
                  donationCount: donation?.donationCount!,
                  rangeRatio: ratioLeft,
                  onTap: (){
                    WayaNav.toNamed('/donationDetails',
                        arguments: {
                          'title':'${donation?.title?.capitalizeFirst}',
                          'image':'${donation?.imageURL}',
                          'amountRaised': '${donation?.amountRaised?.replaceAll('.00', '')}',
                          'targetAmount': '${donation?.targetAmount?.replaceAll('.00', '')}',
                          'desc': '${donation?.description}',
                          'solution': '${donation?.solution}',
                          'impact': '${donation?.impact}',
                          'url': '${donation?.url}',
                          'minimumDonationAmount':'${donation?.minimumDonationAmount}',
                          'daysLeft':'$daysLeft',
                          'privacy':'${donation?.privacy}',
                          'donationCount': '${donation?.donationCount}',
                          'id': '${donation?.id}',
                          'ratioLeft': ratioLeft,
                          'organizerId': donation?.organizerId,
                           "donation": donation

                        });
                  },
                  buttonWidth: 60.0,
                );
              }
          )

        ],
      ),
    );
  }
}

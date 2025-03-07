import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/upgrade_to_business/views/upgrade_to_business.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/donation/model/all_donation_model.dart';
import 'package:wayagram/features/donation/model/my_donation_model.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/donation/widget/manage_donation_widget.dart';
import 'package:wayagram/features/polls_and_voting/views/my_polls.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

import '../../../shared/features/user/models/default.dart';
import '../../kyc/view/kyc_update.dart';

class MyDonations extends ConsumerStatefulWidget {
  const MyDonations({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyDonationsState();
}

class _MyDonationsState extends ConsumerState<MyDonations> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(donationVmProvider.notifier).getMyDonation();
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

  String userType = "PERSONAL";

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(donationVmProvider);
    final wayaTheme = Theme.of(context);
    final dynamic args = ModalRoute.of(context)?.settings.arguments;

    // Filter the myDonations
    final filteredMyDonations = WayaUtils.search<MyDonationDocs>(
      viewModel.myDonationDocs!,
      [
        'title',
      ],
      searchController.text,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                    fontSize: 16),
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
              Navigator.pop(context);
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
                Navigator.pop(context);
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
          color: wayaTheme.colorScheme.primar50,
        ),
        Gap(20),
        FilterWidget(
            search: TextEditingController(), hintText: 'Search Donations'),
        Gap(20),
        Text("My Donations", style: wayaTheme.textTheme.titleLarge),
        Text(
          "See and manage all your created donations",
          style: WayaTextStyles.bodySmall.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.greyColor500),
        ),
        const Gap(30),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: filteredMyDonations.length,
            itemBuilder: (context, index) {
              final donation = filteredMyDonations[index];
              int daysLeft = DateTime.parse('${donation.expirationDate}').difference(DateTime.parse('${donation.startDate}')).inDays;

              int amountRaised = double.parse('${donation.amountRaised}').toInt();

              int targetedAmount = double.parse('${donation.targetAmount}').toInt();

              double ratioLeft = amountRaised / targetedAmount;
              return ManageDonationWidget(
                text: "Manage Donation",
                amountRaised: WayaHelpers.formatPrice(int.parse('${donation.amountRaised?.replaceAll('.00', '')}')),
                targetAmount: WayaHelpers.formatPrice(int.parse('${donation.targetAmount?.replaceAll('.00', '')}')),
                title: donation.title?.capitalizeFirst,
                image: donation.imageURL,
                dayLeft: daysLeft < 0 ? '0' : '$daysLeft',
                donationCount: donation.donationCount!,
                rangeRatio: ratioLeft,
                onTap: () {
                  WayaNav.toNamed('/donationManagement', arguments: {
                    'title': '${donation.title?.capitalizeFirst}',
                    'image': '${donation.imageURL}',
                    'amountRaised': '${donation.amountRaised?.replaceAll('.00', '')}',
                    'targetAmount': '${donation.targetAmount?.replaceAll('.00', '')}',
                    'desc': '${donation.description}',
                    'solution': '${donation.solution}',
                    'impact': '${donation.impact}',
                    'url': '${donation.url}',
                    'minimumDonationAmount': '${donation.minimumDonationAmount}',
                    'daysLeft': '$daysLeft',
                    'id': '${donation.id}',
                    'range':ratioLeft,
                    'donationCount': '${donation.donationCount}'
                  });
                },
                buttonWidth: 120.0,
              );
            }),
      ],
    );
    /* Expanded(
      child: PaginatedDataView<MyDonationDocs>(
        uniqueKey: 'My-donations',
        loadingState: SizedBox(
            height: context.height * 0.4,
            child: Center(
              child: CircularProgressIndicator(),
            )),
        emptyState:DonationEmptyState(),
        fetchData: ref.read(donationVmProvider.notifier).getMyDonation,
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
  }
}

class DonationEmptyState extends StatelessWidget {
  const DonationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        child: EmptyState(
            hasButton: false,
            onTap: () {
              //WayaNav.toNamed(CreatePost.route);
            },
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter: ColorFilter.mode(
                  wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You haven't added any donations yet"),
      ),
    );
  }
}

/*

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        color: wayaTheme.colorScheme.customPrimary, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
              callback: () {
                WayaNav.toNamed('/createDonation');
              },
              color: wayaTheme.colorScheme.primar50,
            ),

            Gap(20),
            FilterWidget(search: TextEditingController(), hintText: 'Search Donations'),
            Gap(20),
            Text("My Donations",
                style: wayaTheme.textTheme.titleLarge),
            Text(
              "See and manage all your created donations",
              style: WayaTextStyles.bodySmall.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.greyColor500 ),),
            const Gap(30),
          ],
        ),
 */

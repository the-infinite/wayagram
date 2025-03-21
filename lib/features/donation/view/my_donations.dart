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
import 'package:wayagram/features/donation/model/my_donation_model.dart';
import 'package:wayagram/features/donation/view/application_details.dart';
import 'package:wayagram/features/donation/view/applied_donations.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/donation/widget/applied_donationi_widget.dart';
import 'package:wayagram/features/donation/widget/donation_tab.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';

import '../../../shared/features/user/models/default.dart';
import 'hosted_donations.dart';

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
      ref.read(donationVmProvider.notifier).getDonatedDonation;
      ref.read(donationVmProvider.notifier).getMyKYC();
      ref.read(donationVmProvider.notifier).getHostedDonation();
      ref.read(donationVmProvider.notifier).getAppliedDonation();
    });
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {});
    });
  }

  int _selectedIndex = 0;

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
        const Gap(10),
        Row(
          children: [
            DonationTabButton(
              isSelected: _selectedIndex == 0,
              text: 'Hosted Donations',
              onTap: () => setState(() => _selectedIndex = 0),
            ),
            const Gap(20),
            DonationTabButton(
              isSelected: _selectedIndex == 1,
              text: 'Applied Donations',
              onTap: () => setState(() => _selectedIndex = 1),
            ),

          ],
        ),
        const Gap(20),

        _selectedIndex == 0 ? HostedDonations() : AppliedDonations(),

        // WayaButton(
        //   centerWidget: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       SvgPicture.asset(
        //         'assets/icons/donation.svg',
        //         colorFilter: ColorFilter.mode(
        //             wayaTheme.colorScheme.primary300, BlendMode.srcIn),
        //       ),
        //       const Gap(10),
        //       Text(
        //         "Create a Donation Post",
        //         style: TextStyle().wayaCopyWith(
        //             color: wayaTheme.colorScheme.customPrimary,
        //             fontWeight: FontWeight.w600,
        //             fontSize: 16),
        //       ),
        //     ],
        //   ),
        //   callback: () {
        //     if(viewModel.kycStatus != 'APPROVED' && ConversationState.self.accountType == UserAccountType.business){
        //       WayaUtils.showNotice(
        //           context: context,
        //           title: "Update KYC Information ",
        //           message: 'You must complete KYC verification before creating a donation post',
        //           onPress: () {
        //             WayaNav.goBack();
        //             WayaNav.toNamed('/kycUpdate', arguments: {
        //               'kyc': '${viewModel.kycStatus}'
        //             });
        //           },
        //           buttonText: 'Update KYC',
        //           secondButtonText: 'Cancel',
        //           icon: Image.asset('assets/images/cp-shop.png'));
        //     } else if (ConversationState.self.accountType == UserAccountType.personal) {
        //       WidgetsBinding.instance.addPostFrameCallback((_) {
        //         WayaUtils.showNotice(
        //             context: context,
        //             title: "You don't have a Business Account",
        //             message: 'Please upgrade to a business account to create a donation post',
        //             onPress:  () {
        //               WayaNav.goBack();
        //               WayaNav.toNamed(UpgradeToBusiness.route);
        //             },
        //             buttonText: 'Upgrade to Business',
        //             secondButtonText: 'Cancel',
        //             icon: Image.asset('assets/images/cp-shop.png'));
        //       });
        //     } else{
        //       WayaNav.toNamed('/createDonation');
        //     }
        //   },
        //   color: wayaTheme.colorScheme.primar50,
        // ),
        // Gap(20),
        // FilterWidget(
        //     search: TextEditingController(), hintText: 'Search Donations'),
        // Gap(20),
        // Text("My Donations", style: wayaTheme.textTheme.titleLarge),
        // Text(
        //   "See and manage all your created donations",
        //   style: WayaTextStyles.bodySmall.copyWith(
        //       fontSize: 12,
        //       fontWeight: FontWeight.w400,
        //       color: Theme.of(context).colorScheme.greyColor500),
        // ),

       /* ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: filteredMyDonations.length,
            itemBuilder: (context, index) {
              final donation = filteredMyDonations[index];
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
                          startDate: ref.read(createPollVotingProvider.notifier).formatDt1('${donation.startDate}'),
                          endDate: ref.read(createPollVotingProvider.notifier).formatDt1('${donation.expirationDate}'),
                          targetAmount:'${donation.targetAmount?.replaceAll('.00', '')}',
                          amountRaised: '${donation.amountRaised?.replaceAll('.00', '')}',
                          status: '${donation.status}',
                          privacy: '${donation.privacy}',
                            ));
                  },
                    privacy: '${donation.privacy}',
                    title: '${donation.title}',
                    status: '${donation.status}',
                    image: '${donation.imageURL}',
                    targetAmount: WayaHelpers.formatPrice(int.parse('${donation.targetAmount?.replaceAll('.00', '')}')),
                    startDate: ref.read(createPollVotingProvider.notifier).formatDt1('${donation.startDate}'),
                    endDate: ref.read(createPollVotingProvider.notifier).formatDt1('${donation.expirationDate}'),
                    color: WayaColors.primary50,
                );

              */

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


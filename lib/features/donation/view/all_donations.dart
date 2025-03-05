
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/upgrade_to_business/views/upgrade_to_business.dart';
import 'package:wayagram/features/donation/model/all_donation_model.dart';
import 'package:wayagram/features/donation/view/my_donations.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/explore/widgets/donation_widget.dart';
import 'package:wayagram/features/polls_and_voting/views/my_polls.dart';
import 'package:wayagram/features/shop/widgets/categories_filter_widget.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

import '../../chat/state/default.dart';
import '../widget/manage_donation_widget.dart';

class AllDonations extends ConsumerStatefulWidget {
  const AllDonations({super.key});

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
   print('DONATION ARGS $args');

   // Filter the allDonations
   final filteredAllDonations = WayaUtils.search<AllDonationDocs>(
     viewModel.allDonationDocs!,
     ['title', ],
     searchController.text,
   );


    return filteredAllDonations.isEmpty ?DonationEmptyState() :Column(
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
            print('DARLINGTON ACCOUNT TYPE ${ConversationState.self.accountType}');

             if(viewModel.kycStatus != 'APPROVED' && ConversationState.self.accountType == 'BUSINESS'){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'You must complete KYC verification before creating a donation post',
                    style:
                    TextStyle(fontFamily: WayaConstants.fontFamily, fontSize: 12),
                  ),
                  backgroundColor: WayaColors.primary,
                  duration: Duration(seconds: 2),
                ),
              );
              WayaNav.toNamed('/createDonation');
            } else if (ConversationState.self.accountType == 'PERSONAL') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                WayaUtils.showNotice(
                    context: context,
                    title: "You don't have a Business Account",
                    message: 'Please upgrade to a business account to create a donation post',
                    onPress: () => WayaNav.toNamed(UpgradeToBusiness.route),
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
            search: searchController,
            hintText: 'Search Donations'),
        Gap(20),
        Text("Featured Donations",
            style: wayaTheme.textTheme.titleLarge),
        Text(
            "Support a Cause That Matters",
            style: WayaTextStyles.bodySmall.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.greyColor500 ),),
        const Gap(30),

    SizedBox(
      height: 500,
      child: PaginatedDataView<AllDonationDocs>(
        uniqueKey: 'All-donations',
        loadingState: SizedBox(
            height: context.height * 0.4,
            child: Center(
              child: CircularProgressIndicator(),
            )),
        emptyState:DonationEmptyState(),
        fetchData: ref.read(donationVmProvider.notifier).getAllDonation,
        result: (data, s ) {
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredAllDonations.length,
              itemBuilder: (context, index){
               final donation = filteredAllDonations[index];
               int daysLeft = DateTime.parse('${donation.expirationDate}').difference(DateTime.parse('${donation.startDate}')).inDays;
                return ManageDonationWidget(
                  text:  "Donate",
                  amountRaised:  WayaHelpers.formatPrice(int.parse('${donation.amountRaised?.replaceAll('.00', '')}')),
                  targetAmount: WayaHelpers.formatPrice(int.parse('${donation.targetAmount?.replaceAll('.00', '')}')),
                  title: donation.title?.capitalizeFirst,
                  image: donation.imageURL,
                  dayLeft: daysLeft < 0  ? '0' : '$daysLeft',
                  donationCount: donation.donationCount,
                  onTap: (){
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
                          'donationCount': '${donation.donationCount}'

                        });
                  },
                  buttonWidth: 60.0,
                );
              }
          );
        },),
    ),

        Gap(20),
        Text("Based On Categories",
            style: wayaTheme.textTheme.titleLarge),
        Text(
          "View donations based on their categories",
          style: WayaTextStyles.bodySmall.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.greyColor500 ),),
        const Gap(30),
        SizedBox(
          height: 500,
          child: PaginatedDataView<AllDonationDocs>(
            uniqueKey: 'All-donations',
            loadingState: SizedBox(
                height: context.height * 0.4,
                child: Center(
                  child: CircularProgressIndicator(),
                )),
            emptyState:DonationEmptyState(),
            fetchData: ref.read(donationVmProvider.notifier).getAllDonation,
            result: (data, s ) {
              return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: viewModel.allDonationDocs?.length,
                  itemBuilder: (context, index){
                    final donation = viewModel.allDonationDocs?[index];
                    int daysLeft = DateTime.parse('${donation?.expirationDate}').difference(DateTime.parse('${donation?.startDate}')).inDays;
                    return ManageDonationWidget(
                      text: "Donate",
                      amountRaised: donation?.amountRaised,
                      targetAmount: WayaHelpers.formatPrice(double.parse('${donation?.targetAmount}').toInt()),
                      title: donation?.title?.capitalizeFirst,
                      image: donation?.imageURL,
                      dayLeft: '$daysLeft',
                      donationCount: donation?.donationCount!,
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
                              'id': '${donation?.id}'

                            });
                      },
                      buttonWidth: 60.0,
                    );
                  }
              );
            },),
        ),
      ],
    );
  }
}

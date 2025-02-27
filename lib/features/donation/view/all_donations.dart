
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
import 'package:wayagram/features/donation/model/all_donation_model.dart';
import 'package:wayagram/features/donation/view/my_donations.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/explore/widgets/donation_widget.dart';
import 'package:wayagram/features/polls_and_voting/views/my_polls.dart';
import 'package:wayagram/features/shop/widgets/categories_filter_widget.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

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
      ref.read(donationVmProvider.notifier).getAllDonation(1);
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
        emptyState:PollEmptyState(),
        fetchData: ref.read(donationVmProvider.notifier).getAllDonation,
        result: (data, s ) {
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredAllDonations.length,
              itemBuilder: (context, index){
               final donation = filteredAllDonations[index];
               int daysLeft = DateTime.parse('${donation.expirationDate}').difference(DateTime.parse('${donation.createdAt}')).inDays;
               //int daysLeft = DateTime.parse('${donation.expirationDate}').day;
                return ManageDonationWidget(
                  text:  "Donate",
                  amountRaised:  WayaHelpers.formatPrice(int.parse('${donation.amountRaised?.replaceAll('.00', '')}')),
                  targetAmount: WayaHelpers.formatPrice(int.parse('${donation.targetAmount?.replaceAll('.00', '')}')),
                  title: donation.title?.capitalizeFirst,
                  image: donation.imageURL,
                  dayLeft: '$daysLeft',
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
                          'daysLeft':'$daysLeft'

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
                    int daysLeft = DateTime.parse('${donation?.expirationDate}').day;
                    return ManageDonationWidget(
                      text: "Donate",
                      amountRaised: donation?.amountRaised,
                      targetAmount: WayaHelpers.formatPrice(double.parse('${donation?.targetAmount}').toInt()),
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
        ),
      ],
    );
  }
}

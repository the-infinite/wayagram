import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/utils/string_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';
import 'package:wayagram/features/donation/model/my_donation_model.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/donation/widget/manage_donation_widget.dart';

class SeeAllApprovedDonations extends ConsumerStatefulWidget {
  static const route = '/seeAllApprovedDonations';
  const SeeAllApprovedDonations({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SeeAllApprovedDonationsState();
}

class _SeeAllApprovedDonationsState
    extends ConsumerState<SeeAllApprovedDonations>
    with SingleTickerProviderStateMixin {
  late TextEditingController searchController;

  void _onSearchChanged() {
    setState(() {}); // Rebuild when search text changes
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(donationVmProvider.notifier).getApprovedDonation();
      ref.read(donationVmProvider.notifier).getMyKYC();
    });
    searchController = TextEditingController();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(donationVmProvider);
    //final wayaTheme = Theme.of(context);

    // Filter the myDonations
    final filteredMyDonations = WayaUtils.search<MyDonationDocs>(
      viewModel.approvedDonations!,
      [
        'title',
      ],
      searchController.text,
    );

    return WayaScaffold(
        resizeToAvoidBottomInset: false,
        title: "Approved Donations",
        isLoading: viewModel.isLoading,
        isScrollable: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            viewModel.approvedDonations!.isEmpty
                ? ActivityLogsEmptyState(
                    text: 'You don\'t have approved donations yet',
                  )
                : Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        shrinkWrap: true,
                        itemCount:
                            //viewModel.myDonationDocs?.length,
                            filteredMyDonations.length,
                        itemBuilder: (context, index) {
                          final donation = filteredMyDonations[index];
                          int daysLeft =
                              DateTime.parse('${donation.expirationDate}')
                                  .difference(
                                      DateTime.parse('${donation.startDate}'))
                                  .inDays;

                          int amountRaised =
                              double.parse('${donation.amountRaised}').toInt();

                          int targetedAmount =
                              double.parse('${donation.targetAmount}').toInt();

                          double ratioLeft = amountRaised / targetedAmount;
                          return ManageDonationWidget(
                            text: "Manage Donation",
                            amountRaised: donation.showRaised == true
                                ? WayaHelpers.formatPrice(int.parse(
                                    '${donation.amountRaised?.replaceAll('.00', '')}'))
                                : '****',
                            targetAmount: WayaHelpers.formatPrice(int.parse(
                                '${donation.targetAmount?.replaceAll('.00', '')}')),
                            title: donation.title?.capitalizeFirst,
                            image: donation.imageURL,
                            dayLeft: daysLeft < 0 ? '0' : '$daysLeft',
                            donationCount: donation.donationCount!,
                            rangeRatio: ratioLeft,
                            onTap: () {
                              WayaNav.toNamed('/donationDashboard', arguments: {
                                'title': '${donation.title?.capitalizeFirst}',
                                'image': '${donation.imageURL}',
                                'amountRaised':
                                    '${donation.amountRaised?.replaceAll('.00', '')}',
                                'targetAmount':
                                    '${donation.targetAmount?.replaceAll('.00', '')}',
                                'desc': '${donation.description}',
                                'solution': '${donation.solution}',
                                'impact': '${donation.impact}',
                                'url': '${donation.url}',
                                'minimumDonationAmount':
                                    '${donation.minimumDonationAmount}',
                                'daysLeft': '$daysLeft',
                                'id': '${donation.id}',
                                'range': ratioLeft,
                                'donationCount': '${donation.donationCount}'
                              });
                            },
                            buttonWidth: 120.0,
                          );
                        }),
                  ),
          ],
        ));
  }
}

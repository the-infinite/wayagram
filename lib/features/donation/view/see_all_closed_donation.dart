import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/donation/widget/manage_donation_widget.dart';

class SeeAllClosedDonations extends ConsumerStatefulWidget {
  static const route = '/seeAllClosedDonations';
  const SeeAllClosedDonations({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SeeAllClosedDonationsState();
}

class _SeeAllClosedDonationsState extends ConsumerState<SeeAllClosedDonations>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(donationVmProvider.notifier).getClosedDonation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(donationVmProvider);

    return WayaScaffold(
        resizeToAvoidBottomInset: false,
        title: "Closed Donations",
        isLoading: viewModel.isLoading,
        isScrollable: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            viewModel.closedDonations.isEmpty
                ? ActivityLogsEmptyState(
                    text: 'You don\'t have closed donations yet',
                  )
                : Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 20),
                        shrinkWrap: true,
                        itemCount: viewModel.closedDonations.length,
                        itemBuilder: (context, index) {
                          final donation = viewModel.closedDonations[index];
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
                            amountRaised: WayaHelpers.formatPrice(int.parse(
                                '${donation.amountRaised?.replaceAll('.00', '')}')),
                            targetAmount: WayaHelpers.formatPrice(int.parse(
                                '${donation.targetAmount?.replaceAll('.00', '')}')),
                            title: donation.title?.capitalizeFirst,
                            image: donation.imageURL,
                            dayLeft: DateTime.now().isAfter(DateTime.parse(
                                    "${donation.expirationDate}"))
                                ? '0'
                                : daysLeft.toString(),
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
                                'daysLeft': '0',
                                //'$daysLeft',
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

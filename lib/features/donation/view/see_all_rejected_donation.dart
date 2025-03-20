
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';
import 'package:wayagram/features/donation/model/my_donation_model.dart';
import 'package:wayagram/features/donation/view/application_details.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/donation/widget/applied_donationi_widget.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

class SeeAllRejectedDonations extends ConsumerStatefulWidget {
  static const route = '/seeAllRejectedDonations';
  const SeeAllRejectedDonations({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SeeAllRejectedDonationsState();
}

class _SeeAllRejectedDonationsState extends ConsumerState<SeeAllRejectedDonations> with SingleTickerProviderStateMixin {


  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(donationVmProvider.notifier).getRejectedDonation();
      ref.read(donationVmProvider.notifier).getMyKYC();
    });
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(donationVmProvider);
    final wayaTheme = Theme.of(context);

    // Filter the myDonations
    final filteredMyDonations = WayaUtils.search<MyDonationDocs>(
      viewModel.myDonationDocs!,
      [
        'title',
      ],
      searchController.text,
    );

    return WayaScaffold(
        resizeToAvoidBottomInset: false,
        title: "Rejected Donations",
        isLoading: viewModel.isLoading,
        isScrollable: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            viewModel.rejectedDonations!.isEmpty ? ActivityLogsEmptyState(text: 'You don\'t have rejected donations yet',):
            Expanded(
              child: ListView.builder(
                //physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: viewModel.rejectedDonations?.length,
                  //filteredMyDonations.length,
                  itemBuilder: (context, index) {
                    //final donation = filteredMyDonations[index];
                    final donation = viewModel.rejectedDonations![index];
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
                              status: 'Rejected',
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
          ],
        ) );
  }
}

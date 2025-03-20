import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/donation/widget/manage_donation_widget.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'dart:io' show Platform;

class AppliedDonations extends ConsumerStatefulWidget {
  const AppliedDonations({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppliedDonationsState();
}

class _AppliedDonationsState extends ConsumerState<AppliedDonations> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(donationVmProvider.notifier).getDonatedDonation;
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


    return
      viewModel.appliedDonationDocs!.isEmpty ? DonationEmptyState() :ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: viewModel.appliedDonationDocs?.length,
        itemBuilder: (context, index){
          final donation = viewModel.appliedDonationDocs?[index];
          int daysLeft = DateTime.parse('${donation?.expirationDate}').difference(DateTime.parse('${donation?.startDate}')).inDays;
          int amountRaised = double.parse('${donation?.amountRaised}').toInt();

          int targetedAmount = double.parse('${donation?.targetAmount}').toInt();

          double ratioLeft = amountRaised / targetedAmount;

          return ManageDonationWidget(
            text:  "Donate",
            amountRaised:  WayaHelpers.formatPrice(int.parse('${donation?.amountRaised?.replaceAll('.00', '')}')),
            targetAmount: WayaHelpers.formatPrice(int.parse('${donation?.targetAmount?.replaceAll('.00', '')}')),
            title: donation?.title?.capitalizeFirst,
            image: donation?.imageURL,
            dayLeft: daysLeft < 0  ? '0' : '$daysLeft',
            donationCount: donation?.donationCount,
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
                    'id': '${donation?.id}',
                    'donationCount': '${donation?.donationCount}',
                    'ratioLeft': ratioLeft

                  });
            },
            buttonWidth: 60.0,
          );
        }
    );
   /* return Column(
      children: [
        Expanded(
          child: PaginatedDataView<AllDonationDocs>(
              uniqueKey: 'applied-donations',
              loadingState: SizedBox(
                  height: context.height * 0.4,
                  child: Center(
                    child: CircularProgressIndicator(),
                  )),
              emptyState: ActivityLogsEmptyState(text: 'There is no applied donations yet'),
              fetchData: ref.read(donationVmProvider.notifier).getDonatedDonation,
              result: (data, s) {
                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: viewModel.appliedDonationDocs?.length,
                    itemBuilder: (context, index){
                      final donation = viewModel.appliedDonationDocs?[index];
                      int daysLeft = DateTime.parse('${donation?.expirationDate}').difference(DateTime.parse('${donation?.startDate}')).inDays;
                      int amountRaised = double.parse('${donation?.amountRaised}').toInt();

                      int targetedAmount = double.parse('${donation?.targetAmount}').toInt();

                      double ratioLeft = amountRaised / targetedAmount;

                      return ManageDonationWidget(
                        text:  "Donate",
                        amountRaised:  WayaHelpers.formatPrice(int.parse('${donation?.amountRaised?.replaceAll('.00', '')}')),
                        targetAmount: WayaHelpers.formatPrice(int.parse('${donation?.targetAmount?.replaceAll('.00', '')}')),
                        title: donation?.title?.capitalizeFirst,
                        image: donation?.imageURL,
                        dayLeft: daysLeft < 0  ? '0' : '$daysLeft',
                        donationCount: donation?.donationCount,
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
                                'id': '${donation?.id}',
                                'donationCount': '${donation?.donationCount}'

                              });
                        },
                        buttonWidth: 60.0,
                      );
                    }
                );
              }),
        ),
      ],
    );*/

  /*  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        filteredMyDonations.isEmpty ? ActivityLogsEmptyState(text: 'There is no applied donations yet'):
        SizedBox(
          height: Platform.isAndroid ? 560 : 460,
          child: ListView.builder(
              //physics: const NeverScrollableScrollPhysics(),
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
      ],
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
            message: "You don\'t have applied donations yet"),
      ),
    );
  }
}


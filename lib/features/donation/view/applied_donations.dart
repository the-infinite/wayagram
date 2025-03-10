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
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/donation/widget/applied_donationi_widget.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';

import '../../../shared/features/user/models/default.dart';

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
        SizedBox(
          height: 560,
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


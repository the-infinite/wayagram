import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/donation/widget/manage_donation_widget.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

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
      ref.read(donationVmProvider.notifier).getDonatedDonation(1);
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
    
    return
      viewModel.appliedDonationDocs?.isEmpty ?? true ? DonationEmptyState()
          :SizedBox(
        height: 530.h,
            child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
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
              targetAmount: donation?.showRaised == true ? WayaHelpers.formatPrice(int.parse('${donation?.targetAmount?.replaceAll('.00', '')}')) : '****',
              title: donation?.title?.capitalizeFirst,
              image: donation?.imageURL,
              dayLeft: daysLeft < 0  ? '0' : '$daysLeft',
              donationCount: donation?.donationCount,
              rangeRatio: ratioLeft,
              onTap: (){
                WayaNav.toNamed('/donation-details',
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
                      'ratioLeft': ratioLeft,
                      'organizerId': donation?.organizerId,
                       "donation": donation

                    });
              },
              buttonWidth: 60.0,
            );
                    }
                ),
          );
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
            message: "You don't have applied donations yet"),
      ),
    );
  }
}


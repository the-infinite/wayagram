import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/donation/donation_modal/donation_modal.dart';
import 'package:wayagram/features/donation/state/donation_state.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';

class ReviewDonation extends ConsumerStatefulWidget {
  final Function(int index) goBack;
  final Function gotoPreviousTab;
  final bool isWayagramDeal;
  const ReviewDonation(
      {super.key, required this.goBack, required this.gotoPreviousTab, this.isWayagramDeal =false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReviewDonationState();
}

class _ReviewDonationState extends ConsumerState<ReviewDonation> {
  DonationState? viewModel;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      viewModel = ref.read(donationVmProvider);

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    viewModel = ref.watch(donationVmProvider);
    final donation = ref.watch(donationVmProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Review Donation Details", style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text("Review your donation details before submission",
            style: wayaTheme.textTheme.hintStyle),
        const Gap(20),
        Text("Donation Thumbnail",
          style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.black),),
        const Gap(30),
        EditHeader(
          onTap: () {
            widget.goBack(0);
          },
          title: 'Donation Information ',
        ),
    _reviewText('Cause Title', '${viewModel?.title.text.capitalizeFirst}'),
        const Gap(10),
    _reviewText('Cause Description', '${viewModel?.description.text.capitalizeFirst}'),
        const Gap(10),
    _reviewText('Proposed Solution', '${viewModel?.solution.text.capitalizeFirst}'),
        const Gap(10),
    _reviewText('Impact Statement', '${viewModel?.statement.text.capitalizeFirst}'),
        const Gap(10),
    _reviewText('Target Amount', WayaHelpers.formatPrice(int.parse('${viewModel?.amount.text}'))),
        const Gap(10),
        Row(children: [
          _reviewText('Start Date', '${viewModel?.startDate}'),
          Spacer(),
          _reviewText('End Date', '${viewModel?.endDate}'),
        ],),
        const Gap(10),
    _reviewText('Fundraiser Details', '${viewModel?.details.text.capitalizeFirst}'),
        const Gap(10),
    _reviewText('Privacy Settings', '${'Public'}'),
        const Gap(10),
    Row(children: [
      _reviewText('Show Amount Raised', viewModel!.showAmountRaised ? 'Yes':'No'),
      Spacer(),
      _reviewText('Show Number of Donors', viewModel!.showNumberOfDonors? 'Yes':'No'),
    ],),

        const Gap(30),



        WayaButton(
          callback: !viewModel!.isLoading
              ? ()  async{

            WayaUtils.showModalSheet(
              context,
              child: DonationSuccessModal(),
            );

            //donation.reset();
            //WayaNav.toNamed('/seeBuyer-bids');
          }
              : null,
          centerWidget: LoadingState(
              loading: viewModel!.isLoading, text: 'Post Donation'),
        ),

        const Gap(8),
        WayaButton(
            text: 'Go Back',
            color: wayaTheme.colorScheme.transparent,
            textColor: wayaTheme.colorScheme.customBlack,
            border:
            Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
            callback: () {
              widget.gotoPreviousTab();
            })
      ],
    );
  }
  _reviewText(title, subTitle){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(title,
        style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.greyColor500),),

      Text(subTitle,
        style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.black),),
    ],);
  }
}



class EditHeader extends StatelessWidget {
  final VoidCallback onTap;
  final String title;

  const EditHeader({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle().wayaCopyWith(
            color: wayaTheme.colorScheme.customBlack,
            fontSize: 16,
          ),
        ),
        const Gap(3),
        Expanded(
          child: Divider(
            color: wayaTheme.colorScheme.greyColor200,
            thickness: 1,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: wayaTheme.colorScheme.greyColor300, width: 1)),
            child: Row(
              children: [
                Icon(Icons.edit_outlined),
                const Gap(5),
                Text(
                  "Edit",
                  style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.customBlack, fontSize: 14),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

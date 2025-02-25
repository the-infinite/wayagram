
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/donation/donation_modal/donation_modal.dart';
import 'package:wayagram/features/donation/view/all_donations.dart';
import 'package:wayagram/features/donation/view/my_donations.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/polls_and_voting/views/my_polls.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/shared/components/engagement_range.dart';

class DonationManagement extends ConsumerStatefulWidget {
  static const route = '/donationManagement';
  const DonationManagement({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DonationManagementState();
}

class _DonationManagementState extends ConsumerState<DonationManagement> with SingleTickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(donationVmProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      title: "Manage Donation",
      isLoading: viewModel.isLoading,

      isScrollable: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Send Michael to Oxford University",
            style: TextStyle().wayaCopyWith(
                color: wayaTheme.colorScheme.black,
                fontSize: 24,
                fontWeight: FontWeight.w700),
          ),
          Gap(10),
          WayaImage(
              imageUrl: "",
              height: 180.h,
              width: double.infinity,
              radius: BorderRadius.all(Radius.circular(12))
          ),
          Gap(10),
          EngagementRange(
              topLeft: "₦20,000 raised from ₦100,000",
              bottomLeft: "500 Donators",
              bottomRight: "20 days left",
              range: 0.4),
          Gap(10),
          Row(children: [
            Expanded(child: _detailCard('₦20,000', 'Amount Raised', wayaTheme.colorScheme.success50),),
            Gap(10),
            Expanded(child:  _detailCard('₦500,000', 'Target Amount', wayaTheme.colorScheme.pendingColor),)

          ],),
          Gap(20),
          Text(
            "Donation Information",
            style: TextStyle().wayaCopyWith(
                color: wayaTheme.colorScheme.greyColor400,
                fontSize: 12,
                fontWeight: FontWeight.w400),
          ),
          Gap(20),
          _reviewText('Cause Title', 'Send Michael to Oxford University'),
          Gap(10),
          _reviewText('Cause  Description', 'Help us send Michael to Oxford University! Michael is a bright and ambitious student with dreams of making a difference in the world. Your generous donations will support his tuition, living expenses, and educational materials, allowing him to focus on his studies and achieve his goals. With your help, we can provide him with the opportunity of a lifetime to learn from the best and contribute to his community upon his return. Join us in making this dream a reality!'),
          Gap(10),
          _reviewText('Proposed Solution', 'Support Michael\'s journey to Oxford University! Your contributions will help cover his tuition and living expenses, allowing him to focus on his studies. Together, we can help him learn from top educators and make a positive impact in his community. Let\'s make this dream a reality!'),
          Gap(10),
          _reviewText('Impact Statement', 'Support Michael\'s dream of studying at Oxford! Your donations will help cover his tuition and living costs, allowing him to focus on his education. Together, we can turn this aspiration into reality!'),

        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: context.width * 0.45,
            child: WayaButton(
              centerWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/share.svg',
                    colorFilter: ColorFilter.mode(
                        wayaTheme.colorScheme.primary300, BlendMode.srcIn),
                  ),
                  const Gap(10),
                  Text(
                    "Share Invite",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.customPrimary,
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
              border:
              Border.all(width: 1, color: wayaTheme.colorScheme.primary500),
              callback: () {
                Share.share('h', subject: 'Share Options');
              },
              color: wayaTheme.colorScheme.white,
            ),
          ),
          const Gap(8),
          SizedBox(
            width: context.width * 0.45,
            child: WayaButton(
                text: 'Set Minimum amount',
                color: wayaTheme.colorScheme.primary500,
                textStyle: TextStyle(color: wayaTheme.colorScheme.white),
                callback: () {
                  WayaUtils.showModalSheet(
                    context,
                    child: DonationAmountSetupModal(),
                  );
                }),
          )
        ],),);
  }
  _detailCard(number, name, color){
    return Container(
      width: 122.w,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 17),
      decoration:
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child:  Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.greyColor500 ),
            ),
          ),
          const Gap(10),
          Text(
            number,
            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.black ),
          ),


        ],
      ),
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

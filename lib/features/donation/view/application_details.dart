

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

import '../../../core/theme/waya_colors.dart';

class ApplicationStatus extends ConsumerStatefulWidget {
  final String causeTitle;
  final String solution;
  final String desc;
  final String startDate;
  final String endDate;
  final String targetAmount;
  final String amountRaised;
  final String status;
  final String privacy;
  final String showRaised;

  const ApplicationStatus(
      {super.key,
        required this.causeTitle,
        required this.solution,
        required this.desc,
        required this.startDate,
        required this.endDate,
        required this.targetAmount,
        required this.amountRaised,
        required this.status,
        required this.privacy,
        required this.showRaised,
      });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ApplicationDetailsState();
}

class _ApplicationDetailsState extends ConsumerState<ApplicationStatus> {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final reportState = ref.watch(createGroupProvider);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Application Status ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const Gap(5),
          Text(
              maxLines: 3,
              "Stay updated with the progress of your Donation application. Below are the submitted details of your donation",
              style: wayaTheme.textTheme.hintStyle),
          const Gap(30),
          _reviewText('Cause Title', widget.causeTitle),
          Gap(10),
          _reviewText('Proposed Solution', widget.solution),
          Gap(10),
          _reviewText('Cause  Description', widget.desc),
          const Gap(10),
          Divider(
            color: wayaTheme.colorScheme.greyColor200,
            thickness: 1,
          ),
          Gap(20),
          Row(children: [
            _reviewText( 'Start date', widget.startDate),
            const Gap(30),
            _reviewText( 'End date', widget.endDate),
            const Gap(30),
            _reviewText( 'Privacy\n', widget.privacy.capitalizeFirst),
            const Gap(30),
            _reviewText( 'Show Amount\nRaised', widget.showRaised),
          ],),
          Gap(20),
          Row(children: [
            _reviewText( 'Target Amount', WayaHelpers.formatPrice(int.parse(widget.targetAmount.replaceAll('.00', '')))),
            const Gap(30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Text(
                  'Application',
                  style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.greyColor600 ),
                ),
                const Gap(5),
                Container(
                  decoration: BoxDecoration(
                    color: widget.status == 'Pending'?WayaColors.pendingColor:
                    widget.status =='Approved'? WayaColors.success50:
                    WayaColors.error50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 20.h,
                  width: 68.w,
                  child: Center(
                    child: Text(
                      widget.status,
                      style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: widget.status == 'Pending'? WayaColors.pendingColor2: widget.status == 'Approved'? WayaColors.success: WayaColors.error ),
                    ),
                  ),

                ),
              ],
            ),


          ],),
          const Gap(30),
          widget.status == 'Pending'?  WayaButton(
            text: 'Go Back',
            color: wayaTheme.colorScheme.primary500,
            textColor: wayaTheme.colorScheme.white,
            border:
            Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
            callback: (){
              Navigator.of(context).pop();
            },
            height: 40,
            textStyle: WayaTextStyles.bodySmall.copyWith(
                fontSize: 14.sp,
                fontFamily: WayaConstants.fontFamily,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.white ),

          ):
          widget.status == 'Approved'?WayaButton(
            text: 'Manage Donation',
            color: wayaTheme.colorScheme.primary500,
            textColor: wayaTheme.colorScheme.white,
            border:
            Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
            callback: (){
              WayaNav.toNamed('/donationManagement', arguments: {
                'title': widget.causeTitle,
                //'image': '${donation.imageURL}',
                'amountRaised': widget.amountRaised.replaceAll('.00', ''),
                'targetAmount': widget.targetAmount.replaceAll('.00', ''),
                'desc': widget.desc,
                'solution': widget.solution,
                // 'impact': '${donation.impact}',
                // 'url': '${donation.url}',
                // 'minimumDonationAmount': '${donation.minimumDonationAmount}',
                // 'daysLeft': '$daysLeft',
                // 'id': '${donation.id}',
                // 'range':ratioLeft,
                // 'donationCount': '${donation.donationCount}'
              });
            },
            height: 40,
            textStyle: WayaTextStyles.bodySmall.copyWith(
                fontSize: 14.sp,
                fontFamily: WayaConstants.fontFamily,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.white ),

          ):
          WayaButton(
            text: 'Go Back',
            color: wayaTheme.colorScheme.primary500,
            textColor: wayaTheme.colorScheme.white,
            border:
            Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
            callback: (){
              Navigator.of(context).pop();
            },
            height: 40,
            textStyle: WayaTextStyles.bodySmall.copyWith(
                fontSize: 14.sp,
                fontFamily: WayaConstants.fontFamily,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.white ),

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
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.greyColor500),),

        Text(subTitle,
          style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.black),),
      ],);
  }


}

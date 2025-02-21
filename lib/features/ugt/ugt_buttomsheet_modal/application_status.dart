import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/widgets/contest_card.dart';

import '../../../core/components/waya_buttons.dart';
import '../../../core/components/waya_select_field.dart';
import '../../../core/components/waya_text_form_field.dart';
import '../../../core/utils/waya_navigation.dart';
import '../widgets/upcoming_widgets/upcoming_widget.dart';

class ApplicationStatus extends StatefulWidget {
  Contest? post;
   ApplicationStatus(this.post, {super.key});

  @override
  State<ApplicationStatus> createState() => _ApplicationStatusState();
}

class _ApplicationStatusState extends State<ApplicationStatus> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 5.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Application Status",
                    style: wayaTheme.textTheme.bodyMedium),
              ],
            ),

            SizedBox(height: 3.h),
            Text(
              "Stay updated with the progress of your University Got Talent application. Below are the details and current status of your submission",

              style: wayaTheme.textTheme.hintStyle, textAlign: TextAlign.start,),



            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UpcomingWidget(title: "Start Date", content: formatDate(widget.post?.startDate??"")),
                const Gap(20),
                UpcomingWidget(title: "End Date", content: formatDate(widget.post?.endDate??"")),
                const Gap(20),
                UpcomingWidget(title: "Entry Type", content:widget.post?.entryType??"" ),
                const Gap(20),
                UpcomingWidget(title: "Duration", content:widget.post?.durationType??""),
              ],
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UpcomingWidget(title: "Total Stages", content:widget.post?.multipleStages??""),
                const Gap(20),
                UpcomingWidget(title: "Category", content:widget.post?.categoryName??""),
                const Gap(20),
                UpcomingWidget(title: "Prize", content: widget.post?.winnerPrize??""),
                const Gap(20),
                UpcomingWidget(title: "Host", content:"Host"),
              ],
            ),
            const Gap(20),

            SizedBox(height: 17.h),
            WayaButton(
              callback: () async{
                Navigator.pop(context);
                  WayaNav.toNamed("/create-profile-contest1");
              },
              text: "Create Contest Profile",
            ),
            const Gap(10),
            WayaButton(
                text: 'Go Back',
                color: wayaTheme.colorScheme.greyColor300,
                textColor: wayaTheme.colorScheme.customBlack,
                border:
                Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
                callback: () {

                })
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/ugt/ugt_buttomsheet_modal/contestant_reject_modal.dart';
import 'package:wayagram/features/ugt/ugt_buttomsheet_modal/successful_modal.dart';
import 'package:wayagram/features/ugt/video_player.dart';
import 'package:wayagram/features/ugt/widgets/upcoming_widgets/upcoming_widget.dart';

import '../../../core/components/waya_scaffold.dart';

class ViewSingleContestantData extends StatefulHookConsumerWidget {
  static const route = '/view-contestant-single-data';
  const ViewSingleContestantData({super.key});

  @override
  ConsumerState<ViewSingleContestantData> createState() =>
      _ManageStateContestState();
}

class _ManageStateContestState extends ConsumerState<ViewSingleContestantData> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Manage application",
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        //  padding: EdgeInsets.all(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Text("Your Bio", style: wayaTheme.textTheme.bodyMedium),

            Text("Application submission",
                style: wayaTheme.textTheme.displaySmall!
                    .wayaCopyWith(fontWeight: FontWeight.w700, fontSize: 24)),
            const Gap(5),
            Text(
                "View all the details submitted by the contestant to enter for the contest",
                style: wayaTheme.textTheme.hintStyle
                    .wayaCopyWith(fontSize: 16, fontWeight: FontWeight.w400)),
            //  Text("Your Bio", style: wayaTheme.textTheme.bodyMedium),
            const Gap(20),

            // Manage States
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _singleWidget(context, "Name", "RUFAI MALEEK"),
                _singleWidget(
                    context, "Email Address", "olutomiwarufai@ mail.com"),
                _singleWidget(context, "Phone Number", "+234813151709"),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _singleWidget(context, "Address", "64,Lekki expressway"),
                _singleWidget(context, "State", "Lagos State"),
                _singleWidget(context, "University", "Lagos State University"),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _singleWidget(context, "Talent Category", "Music & Arts"),
                _singleWidget(context, "Description of Talent",
                    '''The Best University Musician 2024 talent show is a celebration of extraordinary musical talent from our campus. Participants will showcase their unique skills, whether it's singing, playing an instrument, or composing original pieces.''',
                    longer: true),
              ],
            ),
            SizedBox(height: 20),
            Text("School ID or Acceptance Letter",
                style: wayaTheme.textTheme.displaySmall!
                    .wayaCopyWith(fontWeight: FontWeight.w500, fontSize: 14)),
            const Gap(5),
            VideoThumbnailPlayer(
              imageUrl: "",
              videoUrl: "",
            ),

            Text("Show Us Your Talent",
                style: wayaTheme.textTheme.displaySmall!
                    .wayaCopyWith(fontWeight: FontWeight.w500, fontSize: 14)),
            const Gap(5),
            VideoThumbnailPlayer(
              imageUrl: "",
              videoUrl: "",
            ),
            const Gap(5),
            WayaButton(
              callback: () {
                WayaUtils.showModalSheet(
                  context,
                  child: SuccessfulModal(
                      "Submission approved",
                      "You have approved the submission for this contestant. Contestant will receive a notification on their application status",
                      false, () {
                    WayaNav.removeUntilNamed('/manage-application-contest');
                  }),
                );
              },
              centerWidget:
                  LoadingState(loading: false, text: 'Approve submission'),
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.greyColor300),
              color: Colors.white,
              callback: () async {
                // Navigator.of(context).pop();
                WayaUtils.showModalSheet(
                  context,
                  child: ContestantRejectModal(),
                );
              },
              text: "Reject submission",
              textColor: WayaColors.black,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _singleWidget(BuildContext context, String title, String subTitle,
    {bool longer = false}) {
  final wayaTheme = Theme.of(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,
          style: wayaTheme.textTheme.displaySmall!.wayaCopyWith(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: wayaTheme.colorScheme.greyColor900)),
      const Gap(5),
      SizedBox(
        width: longer ? context.width * 0.5 : context.width * 0.2,
        child: Text(subTitle,
            style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: wayaTheme.colorScheme.greyColor900)),
      ),
    ],
  );
}

Color getColor(bool isText, String text) {
  return isText ? Color(0xff9E0A05) : Color(0xffFEF6E7);
  /*  } else if (text == "rejected") {
      return isText ? Color(0xff9E0A05) : Color(0xffFBEAE9);
    } else {
      return isText ? Color(0xff865503) : Color(0xffFEF6E7);
    } */
}



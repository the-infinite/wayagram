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
import 'package:wayagram/features/ugt/my_contest_details/admin_contest_details.dart';
import 'package:wayagram/features/ugt/ugt_buttomsheet_modal/contestant_reject_modal.dart';
import 'package:wayagram/features/ugt/ugt_buttomsheet_modal/successful_modal.dart';
import 'package:wayagram/features/ugt/video_player.dart';
import 'package:wayagram/features/ugt/vm/ugt_contestant_profile_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
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
    var model = ref.watch(selectedApplicantProfile);
    var selectedContestModel =
        ref.watch(selectedContestProvider.notifier).state;
    var viewModel = ref.watch(votersContestNotifier.notifier);
    var isLoading = useState(false);
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
                    .wayaCopyWith(fontWeight: FontWeight.w700, fontSize: 24.sp)),
            const Gap(5),
            Text(
                "View all the details submitted by the contestant to enter for the contest",
                style: wayaTheme.textTheme.hintStyle
                    .wayaCopyWith(fontSize: 16.sp, fontWeight: FontWeight.w400)),
            //  Text("Your Bio", style: wayaTheme.textTheme.bodyMedium),
            const Gap(20),

            // Manage States
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _singleWidget(context, "Name", model?.fullName ?? ""),
                _singleWidget(context, "Email Address", model?.email ?? ""),
                _singleWidget(
                    context, "Phone Number", model?.phoneNumber ?? ""),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _singleWidget(context, "Address", model?.address ?? ""),
                _singleWidget(context, "State", model?.state ?? ""),
                //  _singleWidget(context, "University", "Lagos State University"),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _singleWidget(context, "Talent Category",
                    selectedContestModel?.categoryName ?? ""),
                _singleWidget(context, "Description of Talent",
                    selectedContestModel?.description ?? "",
                    longer: true),
              ],
            ),
            SizedBox(height: 20),
            ...model?.applicationData?.entries.map((entry) {
                  if (!isValidUrl(entry.value)) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(entry.key,
                            style: wayaTheme.textTheme.displaySmall!
                                .wayaCopyWith(
                                    fontWeight: FontWeight.w500, fontSize: 16.sp)),
                        const Gap(5),
                        Text(entry.value,
                            style: wayaTheme.textTheme.displaySmall!
                                .wayaCopyWith(
                                    fontWeight: FontWeight.w500, fontSize: 14.sp)),
                        const Gap(5),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(entry.key,
                            style: wayaTheme.textTheme.displaySmall!
                                .wayaCopyWith(
                                    fontWeight: FontWeight.w500, fontSize: 16.sp)),
                        const Gap(5),
                        WayaImage(
                          imageUrl: entry.key,
                          height: 200,
                          width: context.width,
                          fit: BoxFit.cover,
                          radius: BorderRadius.circular(10),
                        )
                      ],
                    );
                  }
                  //  return Text("${entry.key} scored ${entry.value}");
                }).toList() ??
                [],

            /*  VideoThumbnailPlayer(
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
            ), */
            const Gap(25),
            WayaButton(
              callback: () async {
                bool isPass = await ref
                    .read(votersContestNotifier.notifier)
                    .acceptRejectContestant(
                        isLoading, model?.id ?? "", model?.contestId ?? "", {
                  "status": "APPROVED",
                });
                if (isPass) {
                  WayaUtils.showModalSheet(
                    context,
                    child: SuccessfulModal(
                        title: "Submission approved",
                        subtitle:
                            "You have approved the submission for this contestant. Contestant will receive a notification on their application status",
                        showCopyLink: false,
                        buttonText: null,
                        onTap: (_, __) {
                          WayaNav.removeAllUntil(AdminContestDetails(),
                              '/upcoming-manage-contest-details');
                          /*  WayaNav.removeUntilNamed(
                              '/contest-mydashboard-profile-page'); */
                        }),
                  );
                } else {
                  WayaSnackBar.showToast(
                      "Please try again, unable to send request");
                }
              },
              centerWidget:
                  LoadingState(loading: false, text: 'Approve submission'),
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.greyColor300),
              color: Colors.white,
              callback: () async {
                // WayaNav.goBack();
                WayaUtils.showModalSheet(
                  context,
                  child: ContestantRejectModal(
                    onTap: (value, myReason) async {
                      bool isPass = await ref
                          .read(votersContestNotifier.notifier)
                          .acceptRejectContestant(
                              value, model?.id ?? "", model?.contestId ?? "", {
                        "status": "REJECTED",
                        "rejectedReason": myReason,
                      });
                      if (isPass) {
                        WayaSnackBar.showToast("Rejected sent successfully!");
                        /*  viewModel
                            .fetchAllContestApplicant(model?.contestId ?? ""); */
                        /*  WayaNav.removeUntilNamed(
                            '/contest-mydashboard-profile-page'); */
                        WayaNav.removeAllUntil(AdminContestDetails(),
                            '/upcoming-manage-contest-details');
                      } else {
                        WayaSnackBar.showToast(
                            "Please try again, unable to send request");
                      }
                    },
                  ),
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
              fontSize: 14.sp,
              color: wayaTheme.colorScheme.greyColor900)),
      const Gap(5),
      SizedBox(
        width: longer ? context.width * 0.5 : context.width * 0.2,
        child: Text(subTitle,
            style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                fontSize: 12.sp,
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

bool isValidUrl(String text) {
  final urlPattern = r"^(https?:\/\/)?([\w.-]+)\.([a-z]{2,6})([\/\w .-]*)*\/?$";
  final regex = RegExp(urlPattern, caseSensitive: false);
  return regex.hasMatch(text);
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/ugt/data/model/ugt_applied_post_model.dart';
import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';
import 'package:wayagram/features/ugt/ugt_buttomsheet_modal/successful_modal.dart';

import 'package:wayagram/features/ugt/vm/ugt_aplied_contest_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/widgets/contest_card.dart';

import '../../../core/components/waya_buttons.dart';
import '../../../core/utils/waya_navigation.dart';

import 'custom_modal_contest.dart';

class ApplicationStatus extends StatefulHookConsumerWidget {
  AppliedContestModel? post;
  ApplicationStatus(this.post, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ApplicationStatusState();
}

class _ApplicationStatusState extends ConsumerState<ApplicationStatus> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final hasProfile = useState(false);
    final hasPaid = useState(false);
    useEffect(() {
      ref
          .read(postProvider.notifier)
          .fetchSingleContest(ref, widget.post?.contestId ?? "");
      if (widget.post?.status?.toLowerCase() == "approved") {
        ref
            .read(postProvider.notifier)
            .fetchSingleContestantDetails(ref,widget.post?.contestId ?? "",
                widget.post?.userId ?? "")
            .then((model) {
          if (model != null) {
            if (model.data?.totalDocs == 1) {
              if (model.data?.docs?.first.profilePhoto != null &&
                  model.data?.docs?.first.bio != null) {
                hasProfile.value = true;
              }

              if (model.data?.docs?.length == 1) {
                hasPaid.value = model.data?.docs?.first.hasPaid ?? false;
              }
            }
          }
        });
      }

      return null;
    }, []);
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
                Text("Application Status",
                    style: wayaTheme.textTheme.bodyMedium),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              "Stay updated with the progress of your University Got Talent application. Below are the details and current status of your submission",
              style: WayaTextStyles.hintStyleBold.wayaCopyWith(
                  color: WayaColors.greyColor500, fontWeight: FontWeight.w400),
              textAlign: TextAlign.start,
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UpcomingWidget(
                    title: "Name", content: widget.post?.fullName ?? ""),
                // const Gap(20),
                UpcomingWidget(title: "University", content: "University"),
                //  const Gap(20),
                UpcomingWidget(
                    title: "Entry Type",
                    content: widget.post?.contest?.entryType ?? ""),
                /*   const Gap(20),
                UpcomingWidget(
                    title: "Duration",
                    content: widget.post?.contest?.durationType ?? ""), */
              ],
            ),
            _lineThick(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UpcomingWidget(
                    title: "Talent\nCategory",
                    content: formatDate(widget.post?.contest?.startDate ?? "")),
                //  const Gap(20),
                UpcomingWidget(
                    title: "Submission\nDate",
                    content: formatDate(widget.post?.createdAt ?? "")),
                //   const Gap(20),
                UpcomingWidget(
                  title: "Application\nStatus",
                  content: widget.post?.status ?? "",
                  status: true,
                ),
                /*   const Gap(20),
                UpcomingWidget(
                    title: "Duration",
                    content: widget.post?.contest?.durationType ?? ""), */
              ],
            ),
            const Gap(20),
            if (widget.post?.status == "REJECTED")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Reasons for Rejection",
                      overflow: TextOverflow.ellipsis,
                      style: wayaTheme.textTheme.bodyMedium),
                  const Gap(10),
                  Text(
                      widget.post?.rejectionReason ??
                          "We regret to inform you that your application has been rejected due to insufficient originality in your proposed act. We encourage you to explore more unique ideas and reapply in the future!",
                      style: wayaTheme.textTheme.bodyMedium),
                ],
              ),
            if (widget.post?.status == "REJECTED")
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UpcomingWidget(
                          title: "Start Date",
                          isFromDetailsPage: true,
                          content: formatDate(
                              widget.post?.contest?.startDate ?? "")),
                      const Gap(20),
                      UpcomingWidget(
                          title: "End Date",
                          isFromDetailsPage: true,
                          content:
                              formatDate(widget.post?.contest?.endDate ?? "")),
                      const Gap(20),
                      UpcomingWidget(
                          title: "Entry Type",
                          isFromDetailsPage: true,
                          content: widget.post?.contest?.entryType ?? ""),
                      const Gap(20),
                      UpcomingWidget(
                          title: "Duration",
                          isFromDetailsPage: true,
                          content: getRealDateDiffBtwDate(
                              widget.post?.contest?.startDate ?? "",
                              widget.post?.contest?.endDate ?? "")),
                    ],
                  ),
                  const Gap(10),
                  _lineThick(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UpcomingWidget(
                          title: "Total Stages",
                          isFromDetailsPage: true,
                          content: widget.post?.contest?.multipleStages ?? ""),
                      const Gap(20),
                      UpcomingWidget(
                          title: "Category",
                          isFromDetailsPage: true,
                          content: widget.post?.categoryName ?? ""),
                      const Gap(20),
                      UpcomingWidget(
                          title: "Prize",
                          isFromDetailsPage: true,
                          content: widget.post?.contest?.winnerPrize ?? ""),
                      const Gap(20),
                      UpcomingWidget(
                          title: "Host",
                          isFromDetailsPage: true,
                          content: "Host"),
                    ],
                  ),
                  const Gap(20),
                ],
              ),
            SizedBox(height: 17.h),
            WayaButton(
              callback: () async {
                //? check if users request has been approved
                if (widget.post?.status?.toLowerCase() == "approved") {
                  if (hasProfile.value) {
                    WayaNav.toNamed("/upcoming-manage-contest-details");
                    return;
                  }
                  //? check if contest is free
                  if (widget.post?.contest?.entryType?.toLowerCase() ==
                      "free") {
                    ref.read(selectedAppliedContestProvider.notifier).state =
                        widget.post;
                    WayaNav.goBack();
                    WayaNav.toNamed("/create-profile-contest1");
                  } else {
                    //? User has already paid for a contest
                    if (hasPaid.value) {
                      WayaNav.goBack();
                      WayaNav.toNamed("/create-profile-contest1");
                      return;
                    }

                    //? move on to pay for a contest
                    WayaNav.goBack();
                    WayaUtils.showModalSheet(
                      context,
                      child: AvailableBalanceModal(
                        voteCount: "0",
                        model: widget.post,
                        voteFee:
                            widget.post?.contest?.amount?.toString() ?? "0",
                        // model: widget.model,
                        votingLink: "",
                        onTap: () {
                          print("i am on the verge");
                        },
                        candidateName: "",
                      ),
                    );
                  }
                } else {
                  //? contest not approved, could be pending or rejected, can go on to view the contest details
                  WayaNav.toNamed("/upcoming-manage-contest-details");
                }
              },
              //? first checking if contest is approved or not
              text: widget.post?.status?.toLowerCase() == "approved"
                  ? widget.post?.contest?.entryType?.toLowerCase() == "free"
                      //? if it free and has profile details
                      ? hasProfile.value
                          ? "View Contest Details"
                          : "Create Contest Profile"
                      //? if it free and has profile details
                      : hasProfile.value
                          ? "View Contest Details"
                          : "Pay NGN${formatMoney(widget.post?.contest?.amount?.toString() ?? "0")} to continue"
                  : "View Contest Details",
            ),
            const Gap(10),
            WayaButton(
                text: 'Go Back',
                color: wayaTheme.colorScheme.greyColor300,
                textColor: wayaTheme.colorScheme.customBlack,
                border: Border.all(
                    width: 1, color: wayaTheme.colorScheme.greyColor300),
                callback: () {
                  WayaNav.goBack();
                })
          ],
        ),
      ),
    );
  }

  _lineThick() {
    return Column(
      children: [
        const Gap(5),
        Container(
          height: 2, // Thickness of the line
          width: double.infinity, // Full width
          color: Color(0xffF0F2F5), // Line color
        ),
        const Gap(5),
      ],
    );
  }
}

class UpcomingWidget extends StatelessWidget {
  final String title;
  final String content;
  final bool status;
  final bool isFromDetailsPage;
  const UpcomingWidget({
    super.key,
    required this.title,
    required this.content,
    this.status = false,
    this.isFromDetailsPage = false,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width:
              isFromDetailsPage ? context.width * 0.18 : context.width * 0.21,
          child: Text(title,
              style: WayaTextStyles.hintStyleBold.wayaCopyWith(
                  color: WayaColors.greyColor500, fontWeight: FontWeight.w400)),
        ),
        const Gap(5),
        if (!status)
          SizedBox(
            width:
                isFromDetailsPage ? context.width * 0.18 : context.width * 0.21,
            child: Text(content,
                // overflow: TextOverflow.ellipsis,
                style: wayaTheme.textTheme.bodyMedium),
          ),
        if (status)
          Container(
            decoration: BoxDecoration(
              color: getColor(false, content.toLowerCase()), // Background color
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  content,
                  style: TextStyle(
                      color: getColor(true, content.toLowerCase()),
                      fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Color getColor(bool isText, String text) {
    if (text == "pending") {
      return isText ? Color(0xff865503) : Color(0xffFEF6E7);
    } else if (text == "rejected") {
      return isText ? Color(0xff9E0A05) : Color(0xffFBEAE9);
    } else {
      return isText ? Color(0xff036B26) : Color(0xffE7F6EC);
    }
  }
}

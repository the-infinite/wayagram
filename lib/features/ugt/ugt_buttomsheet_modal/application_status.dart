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
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/ugt/data/model/ugt_applied_post_model.dart';

import 'package:wayagram/features/ugt/vm/ugt_aplied_contest_vm.dart';
import 'package:wayagram/features/ugt/widgets/contest_card.dart';

import '../../../core/components/waya_buttons.dart';
import '../../../core/utils/waya_navigation.dart';
import '../widgets/upcoming_widgets/upcoming_widget.dart';
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
              style: wayaTheme.textTheme.hintStyle,
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
            if (widget.post?.rejectionReason != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Reasons for Rejection",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle().wayaCopyWith(
                        color: Theme.of(context).colorScheme.customBlack,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  const Gap(10),
                  Text(
                      widget.post?.rejectionReason ??
                          "We regret to inform you that your application for the University Got Talent contest has been rejected due to insufficient originality in your proposed act. We encourage you to explore more unique ideas and reapply in the future!",
                      style: TextStyle().wayaCopyWith(
                        color: Theme.of(context).colorScheme.customBlack,
                        fontSize: 14,
                      )),
                ],
              ),
            if (widget.post?.rejectionReason == null)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UpcomingWidget(
                          title: "Start Date",
                          content: formatDate(
                              widget.post?.contest?.startDate ?? "")),
                      const Gap(20),
                      UpcomingWidget(
                          title: "End Date",
                          content:
                              formatDate(widget.post?.contest?.endDate ?? "")),
                      const Gap(20),
                      UpcomingWidget(
                          title: "Entry Type",
                          content: widget.post?.contest?.entryType ?? ""),
                      const Gap(20),
                      UpcomingWidget(
                          title: "Duration",
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
                          content: widget.post?.contest?.multipleStages ?? ""),
                      const Gap(20),
                      UpcomingWidget(
                          title: "Category",
                          content: widget.post?.categoryName ?? ""),
                      const Gap(20),
                      UpcomingWidget(
                          title: "Prize",
                          content: widget.post?.contest?.winnerPrize ?? ""),
                      const Gap(20),
                      UpcomingWidget(title: "Host", content: "Host"),
                    ],
                  ),
                  const Gap(20),
                ],
              ),
            SizedBox(height: 17.h),
            WayaButton(
              callback: () async {
                if (widget.post?.status?.toLowerCase() == "approved") {
                  if (widget.post?.contest?.entryType?.toLowerCase() ==
                      "free") {
                    ref.read(selectedAppliedContestProvider.notifier).state =
                        widget.post;
                    Navigator.pop(context);
                    WayaNav.toNamed("/create-profile-contest1");
                  } else {
                    WayaUtils.showModalSheet(
                      context,
                      child: AvailableBalanceModal(
                        voteCount: "0",
                        voteFee:
                            widget.post?.contest?.amount?.toString() ?? "0",
                        // model: widget.model,
                        votingLink: "",
                        candidateName: "",
                      ),
                    );
                  }
                } else {}
              },
              text: widget.post?.status?.toLowerCase() == "approved"
                  ? widget.post?.contest?.entryType?.toLowerCase() == "free"
                      ? "Create Contest Profile"
                      : "Pay NGN${widget.post?.contest?.amount} to continue"
                  : "View Contest Details",
            ),
            const Gap(10),
            WayaButton(
                text: 'Go Back',
                color: wayaTheme.colorScheme.greyColor300,
                textColor: wayaTheme.colorScheme.customBlack,
                border: Border.all(
                    width: 1, color: wayaTheme.colorScheme.greyColor300),
                callback: () {})
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

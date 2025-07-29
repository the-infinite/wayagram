import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/helpers/value.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/utils/waya_routes.dart';
import 'package:wayagram/features/promotion/data/models/promotion_service_type.dart';
import 'package:wayagram/features/promotion/views/promote.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/my_contest_details/ended_contest_page.dart';
import 'package:wayagram/features/ugt/my_contest_details/my_full_media_type.dart';
import 'package:wayagram/features/ugt/vm/register_contest_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/features/ugt/widgets/about_ugt_widget.dart';
import 'package:wayagram/features/ugt/widgets/status_ongoing.dart';
import 'package:wayagram/features/ugt/widgets/status_widget.dart';
import 'package:wayagram/shared/features/profile/widget/action_type.dart';

import '../../../core/utils/waya_navigation.dart';

class ContestCard extends StatefulHookConsumerWidget {
  final Contest post;
  final bool isFromHost;
  final void Function(String) onLikePressed;
  final void Function(String) onSharePressed;
  final void Function(String) onFollowPressed;

  const ContestCard(
    this.post,
    this.onLikePressed,
    this.onSharePressed,
    this.onFollowPressed, {
    this.isFromHost = false,
    super.key,
  });

  @override
  ConsumerState<ContestCard> createState() => _ContestCardState();
}

class _ContestCardState extends ConsumerState<ContestCard> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    // final postNotifier = ref.read(postProvider.notifier);
    final voteNotifier = ref.read(votersContestNotifier.notifier);
    final hasClickedLiked = useState(false);
    final hasClickedShared = useState(false);
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.white,
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: wayaTheme.colorScheme.greyColor200, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref.read(selectedContestProvider.notifier).state =
                                widget.post;
                            WayaNav.toNamed('/contest-details-page');
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                45), // Adjust the radius as needed
                            child: widget.post.uploadCoverImages != null
                                ? WayaImage(
                                    imageUrl: widget.post.uploadCoverImages!,
                                    height: 45,
                                    width: 45,
                                    fit: BoxFit.cover,
                                    radius: BorderRadius.circular(45),
                                  )
                                : Image.asset(
                                    'assets/images/frameuni.png',
                                    height: 45,
                                    width: 45,
                                    fit: BoxFit
                                        .cover, // Ensures the image covers the area properly
                                  ),
                          ),
                        ),
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: widget.post.profileId ==
                                      voteNotifier.getLoggedInUserId()
                                  ? width * 0.38
                                  : width * 0.45,
                              child: Text(
                                //"you are going to print the form help me now qwerty",
                                widget.post.title ?? "Title",
                                overflow: TextOverflow.ellipsis,
                                style: wayaTheme.textTheme.bodyMedium,
                              ),
                            ),
                            const Gap(8),
                            Text(
                                '${widget.post.applicantCount ?? 0} Participants',
                                style: WayaTextStyles.hintStyleBold
                                    .wayaCopyWith(
                                        color: WayaColors.greyColor500,
                                        fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  //  post.isFollowing!
                  if (widget.post.profileId ==
                      voteNotifier.getLoggedInUserId()) ...[
                    Expanded(
                        flex: 2,
                        child: WayaButton(
                          fontSize: 12.sp,
                          callback: () {
                            WayaNav.toNamed(Promote.route, arguments: {
                              "contentId": widget.post.id,
                              "contentType": PromotionServiceType.contest.name,
                              "data": widget.post
                            });
                          },
                          height: 40,
                          leadingIcon: SvgPicture.asset(
                            WayaAssets.icons.mFire.path,
                            fit: BoxFit.none,
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                              wayaTheme.colorScheme.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          text: "Promote",
                        )),
                  ] else ...[
                    Expanded(
                        flex: 1,
                        child: widget.post.isFollowing == true
                            ? WayaButton(
                                text: 'Unfollow',
                                height: 40,
                                horizontalPadding: 2,
                                fontSize: 11.sp,
                                color: wayaTheme.colorScheme.greyColor300,
                                textColor: wayaTheme.colorScheme.customBlack,
                                border: Border.all(
                                    width: 1,
                                    color: wayaTheme.colorScheme.greyColor300),
                                callback: () {
                                  widget.onFollowPressed(widget.post.id!);
                                })
                            : WayaButton(
                                fontSize: 12.sp,
                                callback: () =>
                                    widget.onFollowPressed(widget.post.id!),
                                height: 40,
                                text: "   Follow  ",
                              )),
                  ]
                ],
              ),
              const Gap(20),
              GestureDetector(
                onTap: () {
                  WayaNav.toNamed("/view-media-full-page", arguments: {
                    "url": widget.post.uploadCoverImages,
                    "title": widget.post.title ?? "Title",
                    "createdAt": widget.post.createdAt,
                    "likeCount": widget.post.likeCount,
                    "isLike": widget.post.hasLiked,
                    "showDescription": true,
                    "discription": widget.post.description,
                    "shareCount": widget.post.shareCount,
                    "type": MyFullMediaType.image
                  });
                },
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10), // Adjust the radius as needed
                  child: widget.post.uploadCoverImages != null
                      ? WayaImage(
                          imageUrl: widget.post.uploadCoverImages ?? "",
                          height: 200,
                          width: width,
                          fit: BoxFit.cover,
                          radius: BorderRadius.circular(10),
                        )
                      : Image.asset(
                          'assets/images/frameuni.png',
                          height: 200,
                          fit: BoxFit
                              .cover, // Ensures the image covers the area properly
                        ),
                ),
              ),
              const Gap(20),
              Text(
                widget.post.description ?? "Description",
                style: WayaTextStyles.hintStyleBold.wayaCopyWith(
                    color: WayaColors.greyColor500,
                    fontWeight: FontWeight.w400),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                //   mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AboutUgtWidget(
                          title: "Start Date",
                          content: formatDate(widget.post.startDate)),
                      const Gap(30),
                      //? here using contestStatus as the important one, cause rejected and pending can
                      //? can be assigned to it
                      if (widget.post.contestStatus?.toLowerCase() !=
                              "approved" ||
                          widget.post.status?.toLowerCase() != "active")
                        StatusWidget(
                          title: "Application",
                          content: (widget.post.contestStatus?.toLowerCase() ==
                                      "pending" ||
                                  widget.post.contestStatus?.toLowerCase() ==
                                      "rejected")
                              ? widget.post.contestStatus ?? ""
                              : widget.post.status ?? "Pending",
                        ),
                      //? if this conditions are met, that when the green ongoing can be used
                      if (widget.post.contestStatus?.toLowerCase() ==
                              "approved" &&
                          widget.post.status?.toLowerCase() == "active")
                        StatusOngoing(
                          title: "Application",
                          content: widget.post.status ?? "Pending",
                        ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AboutUgtWidget(
                          title: "End Date",
                          content: formatDate(widget.post.endDate)),
                      //  AboutUgtWidget(title: "Status", content: "Ongoing", ),
                      const Gap(30),
                      AboutUgtWidget(
                          title: "Category",
                          content: widget.post.categoryName ?? "Category"),
                      const Gap(30),
                      /*  AboutUgtWidget(
                          title: "Prize",
                          content:
                              "₦${formatMoney(widget.post.winnerPrize?.replaceAll("\$", "") ?? "0")}"),
                      const Gap(30), */
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AboutUgtWidget(
                        title: "Prize", content: "${widget.post.winnerPrize}"),
                  )
                ],
              ),
              WayaButton(
                callback: () {
                  ref.read(selectedContestProvider.notifier).state =
                      widget.post;
                  if (widget.isFromHost) {
                    WayaNav.toNamed("/contest-details-page",
                        arguments: {"canViewDashboard": true});
                    return;
                  }
                  if (widget.post.status == "CLOSED") {
                    WayaNav.toNamed(EndedContestPage.route, arguments: {
                      'id': widget.post.id,
                    });
                    return;
                  }
                  if (widget.post.profileId ==
                      voteNotifier.getLoggedInUserId()) {
                    WayaNav.toNamed('/contest-details-page');
                    return;
                  }

                  if (isTodayInRange(widget.post.participationStartDate ?? "",
                      widget.post.participationEndDate ?? "")) {
                    ref.read(registerFormProvider.notifier).addDefault(
                        widget.post.contestSettings?.formRequirements ?? [],
                        widget.post);
                    //  WayaNav.toNamed("/register-contest1");
                    ref.read(selectedContestProvider.notifier).state =
                        widget.post;
                    WayaNav.toNamed("/upcoming-contest-details");
                  } else {
                    /*   if (isDateInFuture(widget.post.endDate ?? "")) {
                      ref.read(registerFormProvider.notifier).addDefault(
                          widget.post.contestSettings?.formRequirements ?? [],
                          widget.post);
                      //  WayaNav.toNamed("/register-contest1");
                      ref.read(selectedContestProvider.notifier).state =
                          widget.post;
                      WayaNav.toNamed("/upcoming-contest-details");
                      return;
                    }
 */
                    ref.read(selectedContestProvider.notifier).state =
                        widget.post;
                    WayaNav.toNamed('/contest-details-page');
                  }
                },
                text: widget.post.status == "CLOSED"
                    ? "View Result"
                    : "View Details",
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostActionType(
                    text:
                        "${widget.post.likeCount} ${WayaValueHelper.getComment(widget.post.likeCount ?? 0, WayaPostAction.likes)}",
                    image: WayaAssets.images.pages.like2.path,
                    color: widget.post.hasLiked == true
                        ? wayaTheme.colorScheme.primary
                        : wayaTheme.colorScheme.greyColor500,
                    onPressed: () {
                      if (hasClickedLiked.value == false) {
                        hasClickedLiked.value = true;
                        widget.onLikePressed(widget.post.id!);
                      }
                      Future.delayed(Duration(seconds: 2), () {
                        hasClickedLiked.value = false;
                      });
                    },
                  ),
                  const Gap(30),
                  PostActionType(
                    text:
                        "${widget.post.shareCount} ${WayaValueHelper.getComment(widget.post.shareCount ?? 0, WayaPostAction.share)}",
                    image: WayaAssets.images.pages.share2.path,
                    color: wayaTheme.colorScheme.primary,
                    onPressed: () async {
                      final result = await SharePlus.instance.share(ShareParams(
                        text: WayaValueHelper.getShareableUrl(
                            WayaAppRoutes.getContestDetailRoute(
                                widget.post.id ?? "")),
                        subject: "Share Contest",
                      ));

                      if (result.status == ShareResultStatus.success) {
                        if (hasClickedShared.value == false) {
                          widget.onSharePressed(widget.post.id!);
                        }
                        Future.delayed(Duration(seconds: 2), () {
                          hasClickedShared.value = false;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const Gap(30)
      ],
    );
  }
}

String formatDate(String? isoDate) {
  String realDate = isoDate ?? "2025-03-03T07:21:39.036Z";
  try {
    DateTime date = DateTime.parse(realDate);
    String day = DateFormat('d').format(date);
    String suffix = getDaySuffix(int.parse(day));
    String month = DateFormat('MMM').format(date);
    String year = DateFormat('y').format(date);
    return "$day$suffix $month $year";
  } catch (e) {
    return "No Date";
  }
}

String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return "th";
  }
  switch (day % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
}

Duration getDateDifference(DateTime startDate, DateTime endDate) {
  return endDate.difference(startDate);
}

int getWeeksDifference(DateTime startDate, DateTime endDate) {
  return endDate.difference(startDate).inDays ~/ 7;
}

int getMonthsDifference(DateTime startDate, DateTime endDate) {
  int yearsDiff = endDate.year - startDate.year;
  int monthsDiff = endDate.month - startDate.month;
  return (yearsDiff * 12) + monthsDiff;
}

String getRealDateDiffBtwDate(String realStartDate, String realEndDate) {
  DateTime startDate = DateTime.parse(realStartDate);
  DateTime endDate = DateTime.parse(realEndDate);

  Duration difference = getDateDifference(startDate, endDate);
  int weeks = getWeeksDifference(startDate, endDate);
  if (weeks < 1) {
    return "${difference.inDays} days";
  } else {
    if (weeks == 1) {
      return "$weeks Week";
    } else {
      return "$weeks Weeks";
    }
  }
}

bool isCurrentDateBetween(
    String startDateStr, String endDateStr, String format) {
  try {
    DateTime startDate = DateFormat(format).parse(startDateStr);
    DateTime endDate = DateFormat(format).parse(endDateStr);
    DateTime currentDate = DateTime.now();

    return currentDate.isAfter(startDate) && currentDate.isBefore(endDate);
  } catch (e) {
    debugPrint("Invalid date format: $e");
    return false;
  }
}

bool isTodayInRange(String startDateStr, String endDateStr) {
  // Parse input strings
  DateTime startDate = DateTime.parse(startDateStr);
  DateTime endDate = DateTime.parse(endDateStr);

  // Get current date without time
  DateTime today = DateTime.now();
  today = DateTime(today.year, today.month, today.day);

  // Optional: Normalize start and end to remove time (if needed)
  startDate = DateTime(startDate.year, startDate.month, startDate.day);
  endDate = DateTime(endDate.year, endDate.month, endDate.day);

  // Check if today is within range [start, end]
  return today.isAtSameMomentAs(startDate) ||
      today.isAtSameMomentAs(endDate) ||
      (today.isAfter(startDate) && today.isBefore(endDate));
}

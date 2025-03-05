import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
//import 'package:wayagram/features/explore/data/model/default.dart';
import 'package:wayagram/features/ugt/data/model/ugt_model.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';
import 'package:wayagram/features/ugt/vm/register_contest_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import 'package:wayagram/features/ugt/widgets/about_ugt_widget.dart';
import 'package:wayagram/features/ugt/widgets/status_ongoing.dart';
import 'package:wayagram/features/ugt/widgets/status_widget.dart';

import '../../../core/utils/waya_navigation.dart';

class ContestCard extends ConsumerWidget {
  Contest post;
  final Function(String) onLikePressed;
  final Function(String) onSharePressed;
  final Function(String) onFollowPressed;
  ContestCard(
      this.post, this.onLikePressed, this.onSharePressed, this.onFollowPressed,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final postNotifier = ref.read(postProvider.notifier);
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    // width: context.width * 0.8,
                    child: Row(
                      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /*SvgPicture.asset(
                        '',
                        colorFilter: ColorFilter.mode(
                            wayaTheme.colorScheme.success, BlendMode.srcIn),
                      ),*/
                        GestureDetector(
                          onTap: () {},
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                45), // Adjust the radius as needed
                            child: post.uploadCoverImages != null
                                ? WayaImage(
                                    imageUrl: post.uploadCoverImages!,
                                    height: 45,
                                    width: 45,
                                    fit: BoxFit.cover,
                                    radius: BorderRadius.circular(45),
                                  )

                                /*  Image.network(
                                    post.uploadCoverImages!,
                                    height: 45,
                                    width: 45,
                                    fit: BoxFit
                                        .cover, // Ensures the image covers the area properly
                                  ) */
                                : Image.asset(
                                    'assets/images/frameuni.png',
                                    height: 45,
                                    width: 45,
                                    fit: BoxFit
                                        .cover, // Ensures the image covers the area properly
                                  ),
                          ),
                        ),
                        /*WayaImage(
                        imageUrl: 'assets/images/destructive.png',
                        height: 45,
                        width: 45,
                        fit:BoxFit.cover ,
                        radius: BorderRadius.circular(45),
                      ),*/
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: context.width * 0.4,
                              child: Text(
                                post.title ?? "Title",
                                overflow: TextOverflow.ellipsis,
                                style: wayaTheme.textTheme.bodyMedium,
                              ),
                            ),
                            const Gap(8),
                            Text(
                              '${post.applicantCount ?? 0} Participants',
                              style: wayaTheme.textTheme.hintStyle,
                            ),
                          ],
                        ),
                        // Spacer(),
                        Gap(
                          context.width * 0.15,
                        ),
                        //  post.isFollowing!
                        WayaButton(
                          callback: () => onFollowPressed(post.id!),
                          height: 40,
                          text: "Follow",
                        )
                        /*  : SizedBox(
                                height: 40,
                                width: 90,
                                child: OutlinedButton(
                                    onPressed: () =>
                                        postNotifier.doFollow(post.id!),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          color: wayaTheme.primaryColor,
                                          width: 2), // Border color and width
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            4), // Rounded corners
                                      ),
                                    ),
                                    child: Text("Follow")),
                              ), */
                        /*  WayaButton(
                          callback: () => postNotifier.doFollow(post.id!),
                          height: 40,
                          text: "Follow",
                        ), */
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(20),
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(10), // Adjust the radius as needed
                child: post.uploadCoverImages != null
                    ? WayaImage(
                        imageUrl: post.uploadCoverImages ?? "",
                        height: 200,
                        width: context.width,
                        fit: BoxFit.cover,
                        radius: BorderRadius.circular(10),
                      )

                    /*   Image.network(
                        post.uploadCoverImages!,
                        width: context.width,
                        height: 200,
                        fit: BoxFit
                            .cover, // Ensures the image covers the area properly
                      ) */
                    : Image.asset(
                        'assets/images/frameuni.png',
                        height: 200,
                        fit: BoxFit
                            .cover, // Ensures the image covers the area properly
                      ),
              ),
              /*WayaImage(
                imageUrl: "assets/images/frameuni.png",
                height: 200,
                radius: BorderRadius.circular(16),
              ),*/
              const Gap(20),
              Text(
                post.description ?? "Description",
                style: wayaTheme.textTheme.hintStyle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AboutUgtWidget(
                      title: "Start Date",
                      content: formatDate(post.startDate ?? "Date")),
                  const Gap(30),
                  AboutUgtWidget(
                      title: "End Date",
                      content: formatDate(post.endDate ?? "")),
                ],
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.status?.toLowerCase() != "active")
                    StatusWidget(
                      title: "Application",
                      content: post.status ?? "Pending",
                    ),
                  if (post.status?.toLowerCase() == "active")
                    StatusOngoing(
                      title: "Application",
                      content: post.status ?? "Pending",
                    ),
                  //  AboutUgtWidget(title: "Status", content: "Ongoing", ),
                  const Gap(30),
                  AboutUgtWidget(
                      title: "Prize",
                      content:
                          "NGN ${formatMoney(post.winnerPrize?.replaceAll("\$", "") ?? "0")}"),
                  const Gap(30),
                  AboutUgtWidget(
                      title: "Category",
                      content: post.categoryName ?? "Category"),
                ],
              ),
              const Gap(20),
              WayaButton(
                callback: () {
                  ref.read(selectedContestProvider.notifier).state = post;
                  WayaNav.toNamed('/upcoming-manage-contest-details');

                  /*   ref.read(registerFormProvider.notifier).addDefault(
                      post.contestSettings?.formRequirements ?? [], post);
                  //  WayaNav.toNamed("/register-contest1");
                  ref.read(selectedContestProvider.notifier).state = post;
                  WayaNav.toNamed("/upcoming-contest-details"); */

                  /*    if (isDateInFuture(post.startDate ?? "")) {
                    ref.read(registerFormProvider.notifier).addDefault(
                        post.contestSettings?.formRequirements ?? [], post);
                    //  WayaNav.toNamed("/register-contest1");
                    ref.read(selectedContestProvider.notifier).state = post;
                    WayaNav.toNamed("/upcoming-contest-details");
                  } else {
                    ref.read(selectedContestProvider.notifier).state = post;
                    WayaNav.toNamed('/upcoming-manage-contest-details');
                  } */
                },
                text: "View Details",
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => onLikePressed(post.id!),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: wayaTheme.colorScheme.greyColor200),
                          width: 35,
                          height: 35,
                          child: Center(
                              child: SvgPicture.asset(
                                  "assets/icons/thumbsup.svg")),
                        ),
                        const Gap(3),
                        Text(
                          "${post.likeCount} Likes",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.customBlack,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  const Gap(30),
                  GestureDetector(
                    onTap: () => onSharePressed(post.id!),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: wayaTheme.colorScheme.greyColor200),
                          width: 35,
                          height: 35,
                          child: Center(
                              child:
                                  SvgPicture.asset("assets/icons/u-share.svg")),
                        ),
                        const Gap(3),
                        Text(
                          "${post.shareCount} Shares",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.customBlack,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
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

String formatDate(String isoDate) {
  try {
    DateTime date = DateTime.parse(isoDate);
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
  // int months = getMonthsDifference(startDate, endDate);
}

bool isCurrentDateBetween(
    String startDateStr, String endDateStr, String format) {
  try {
    DateTime startDate = DateFormat(format).parse(startDateStr);
    DateTime endDate = DateFormat(format).parse(endDateStr);
    DateTime currentDate = DateTime.now();

    return currentDate.isAfter(startDate) && currentDate.isBefore(endDate);
  } catch (e) {
    print("Invalid date format: $e");
    return false;
  }
}

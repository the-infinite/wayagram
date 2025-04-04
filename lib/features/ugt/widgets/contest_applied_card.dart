import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/ugt/data/model/ugt_applied_post_model.dart';
import 'package:wayagram/features/ugt/my_contest_details/full_media_view.dart';
import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';
import 'package:wayagram/features/ugt/ugt_buttomsheet_modal/application_status.dart';
import 'package:wayagram/features/ugt/widgets/contest_card.dart';
import 'package:wayagram/features/ugt/widgets/status_ongoing.dart';
//import 'package:wayagram/features/explore/data/model/default.dart';
import 'package:wayagram/features/ugt/widgets/status_widget.dart';

import '../../../core/components/waya_buttons.dart';
import 'about_ugt_widget.dart';

class ContestAppliedCard extends StatelessWidget {
  AppliedContestModel post;
  ContestAppliedCard(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.white,
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: wayaTheme.colorScheme.greyColor200, width: 0),
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
                    width: context.width * 0.8,
                    child: Row(
                      children: [
                        /*SvgPicture.asset(
                        '',
                        colorFilter: ColorFilter.mode(
                            wayaTheme.colorScheme.success, BlendMode.srcIn),
                      ),*/
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              45), // Adjust the radius as needed
                          child: post.contest?.uploadCoverImages != null
                              ? WayaImage(
                                  imageUrl:
                                      post.contest?.uploadCoverImages ?? "",
                                  height: 45,
                                  width: 45,
                                  fit: BoxFit.cover,
                                  radius: BorderRadius.circular(45),
                                )

                              /*  Image.network(
                                  post.contest?.uploadCoverImages ?? "",
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
                          children: [
                            SizedBox(
                              width: context.width * 0.6,
                              child: Text(
                                post.contest?.title ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: wayaTheme.textTheme.bodyMedium,
                              ),
                            ),
                            const Gap(8),
                            Text(
                              '${post.applicantCount} Participants',
                              style: WayaTextStyles.hintStyleBold.wayaCopyWith(
                                  color: WayaColors.greyColor500,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(20),
              Hero(
                tag: "fullPic",
                child: GestureDetector(
                  onTap: () {
                    WayaNav.toNamed("/view-media-full-page", arguments: {
                      "url": post.contest?.uploadCoverImages,
                      "title": post.contest?.title ?? "Title",
                      "createdAt": post.contest?.createdAt,
                      "likeCount": 0,
                      "isLike": false,
                        "showDescription":false,
                      "discription": post.contest?.description,
                      "shareCount": 0,
                      "type": MyFullMediaType.image
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        16), // Adjust the radius as needed
                    child: post.contest?.uploadCoverImages != null
                        ? WayaImage(
                            imageUrl: post.contest?.uploadCoverImages ?? "",
                            height: 200,
                            width: context.width,
                            fit: BoxFit.cover,
                            radius: BorderRadius.circular(10),
                          )

                        /*  Image.network(
                            post.contest?.uploadCoverImages ?? "",
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
                ),
              ),
              /*WayaImage(
                imageUrl: "assets/images/frameuni.png",
                height: 200,
                radius: BorderRadius.circular(16),
              ),*/
              const Gap(20),
              Text(
                post.contest?.description ?? "",
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
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AboutUgtWidget(
                          title: "Start Date",
                          content: formatDate(post.contest?.startDate ?? "")),
                      const Gap(20),
                      AboutUgtWidget(
                          title: "Prize",
                          content:
                              "₦ ${formatMoney(post.contest?.winnerPrize?.replaceAll("\$", "") ?? "0")}"),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AboutUgtWidget(
                          title: "End Date",
                          content: formatDate(post.contest?.endDate ?? "")),
                      const Gap(20),
                      if (post.contest?.status?.toLowerCase() != "active")
                        StatusWidget(
                          title: "Application",
                          content: post.contest?.status ?? "Pending",
                        ),
                      if (post.contest?.status?.toLowerCase() == "active")
                        StatusOngoing(
                          title: "Application",
                          content: post.contest?.status ?? "Pending",
                        ),
                      const Gap(30),
                    ],
                  ),
                  AboutUgtWidget(
                      title: "Category", content: post.categoryName ?? ""),
                ],
              ),
              const Gap(10),
              // const Gap(25),
              WayaButton(
                callback: () {
                  WayaUtils.showModalSheetUgt(
                    context,
                    child: ApplicationStatus(post),
                  );
                },
                text: "View Application Status",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

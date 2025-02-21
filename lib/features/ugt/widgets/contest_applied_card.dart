import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/ugt/data/model/ugt_applied_post_model.dart';
import 'package:wayagram/features/ugt/widgets/contest_card.dart';
//import 'package:wayagram/features/explore/data/model/default.dart';
import 'package:wayagram/features/ugt/widgets/status_widget.dart';

import '../../../core/components/waya_buttons.dart';
import '../../../core/utils/waya_helpers.dart';
import '../data/model/ugt_model.dart';
import 'about_ugt_widget.dart';

class ContestAppliedCard extends StatelessWidget {
  AppliedContestModel post;
  ContestAppliedCard(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    // TODO: implement build
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
                          child: Image.asset(
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
                              '20 Participants',
                              style: wayaTheme.textTheme.hintStyle,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(20),
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(16), // Adjust the radius as needed
                child: post.contest?.uploadCoverImages != null
                    ? Image.network(
                        post.contest?.uploadCoverImages ?? "",
                        height: 200,
                        fit: BoxFit
                            .cover, // Ensures the image covers the area properly
                      )
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
                post.contest?.description ?? "",
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
                      content: formatDate(post.contest?.startDate ?? "")),
                  const Gap(30),
                  AboutUgtWidget(
                      title: "End Date",
                      content: formatDate(post.contest?.endDate ?? "")),
                ],
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusWidget(
                    title: "Application",
                    content: post.contest?.status??"Pending",
                  ),
                  const Gap(30),
                  AboutUgtWidget(
                      title: "Prize", content: post.contest?.winnerPrize ?? ""),
                  const Gap(30),
                  AboutUgtWidget(
                      title: "Category", content: post.categoryName ?? ""),
                ],
              ),
              const Gap(25),
              WayaButton(
                callback: () {},
                text: "View Application Status",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

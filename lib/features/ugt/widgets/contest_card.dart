import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/features/ugt/data/model/ugt_model.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/ugt/widgets/about_ugt_widget.dart';
import 'package:wayagram/features/ugt/widgets/status_ongoing.dart';

import '../../../core/utils/waya_navigation.dart';

class ContestCard extends StatelessWidget {
  const ContestCard({super.key});

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
                    width: context.width * 0.8,
                    child: Row(
                    children: [
                      /*SvgPicture.asset(
                        '',
                        colorFilter: ColorFilter.mode(
                            wayaTheme.colorScheme.success, BlendMode.srcIn),
                      ),*/
                      ClipRRect(
                        borderRadius: BorderRadius.circular(45), // Adjust the radius as needed
                        child: Image.asset(
                          'assets/images/uni.png',
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover, // Ensures the image covers the area properly
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
                            "Best University Musician 2024",
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
                borderRadius: BorderRadius.circular(16), // Adjust the radius as needed
                child: Image.asset(
                  'assets/images/frameuni.png',
                  height: 200,
                  fit: BoxFit.cover, // Ensures the image covers the area properly
                ),
              ),
              /*WayaImage(
                imageUrl: "assets/images/frameuni.png",
                height: 200,
                radius: BorderRadius.circular(16),
              ),*/
              const Gap(20),
              Text(
                "Discover and support the most talented students competing for the top spot! Browse through unique performances, vote for your favorite candidates, and watch them rise to the top",
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
                      title: "Start Date", content: "21st of July 2024"),
                  const Gap(30),
                  AboutUgtWidget(
                      title: "End Date", content: "21st of July 2024"),
                ],
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusOngoing(title: "Status", content: "Ongoing",),
                //  AboutUgtWidget(title: "Status", content: "Ongoing", ),
                  const Gap(30),
                  AboutUgtWidget(title: "Prize", content: "N100,000"),
                  const Gap(30),
                  AboutUgtWidget(title: "Category", content: "Music"),
                ],
              ),
              const Gap(20),
              WayaButton(
                callback: () {
                  WayaNav.toNamed("/register-contest1");
                },
                text: "View Details",
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                                SvgPicture.asset("assets/icons/thumbsup.svg")),
                      ),
                      const Gap(3),
                      Text(
                        "346 Likes",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.customBlack,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  const Gap(30),
                  Row(
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
                        "346 Shares",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.customBlack,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      )
                    ],
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

class VoteItem extends StatelessWidget {
  final Vote vote;
  final int index;
  const VoteItem({super.key, required this.vote, required this.index});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          vote.name,
          style: TextStyle().wayaCopyWith(
              color: wayaTheme.colorScheme.customBlack,
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
        const Gap(8),
        SizedBox(
          width: double.infinity,
          height: 10,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: wayaTheme.colorScheme.greyColor200,
                ),
                height: 10,
                width: double.infinity,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: wayaTheme.colorScheme.customPrimary,
                ),
                height: 10,
                width: context.width * vote.noOfVotes,
              ),
            ],
          ),
        ),
        const Gap(8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${vote.noOfVotes * 100} Votes",
              style: TextStyle().wayaCopyWith(
                  color: wayaTheme.colorScheme.customBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              WayaHelpers.toOrdinal(index + 1),
              textAlign: TextAlign.end,
              style: TextStyle().wayaCopyWith(
                  color: wayaTheme.colorScheme.customBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const Gap(20),
      ],
    );
  }
}

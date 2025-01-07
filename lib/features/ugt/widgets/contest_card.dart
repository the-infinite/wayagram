import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/features/ugt/data/model/ugt_model.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/ugt/widgets/about_ugt_widget.dart';

class ContestCard extends StatelessWidget {
  const ContestCard({super.key});

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
                    width: context.width * 0.6,
                    child: Row(
                    children: [
                      WayaImage(
                        imageUrl: "",
                        height: 45,
                        width: 45,
                        radius: BorderRadius.circular(45),
                      ),
                      const Gap(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: context.width * 0.4,
                            child: Text(
                            "Best University Musician 2024",
                            overflow: TextOverflow.ellipsis,
                           
                            style: wayaTheme.textTheme.bodyMedium,
                          ),
                          ),
                          const Gap(10),
                          Text(
                            '20 Participants',
                            style: wayaTheme.textTheme.hintStyle,
                          ),
                        ],
                      )
                    ],
                  ),
                  ),
                  SizedBox(
                    width: 90,
                    child: WayaButton(
                      callback: () {},
                      text: "Follow Back",
                      height: 35,
                      textStyle: TextStyle().wayaCopyWith(fontSize: 11),
                    ),
                  )
                ],
              ),
              const Gap(20),
              WayaImage(
                imageUrl: "",
                height: 200,
                radius: BorderRadius.circular(16),
              ),
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
                      title: "Start Date", content: "21st of July 2024"),
                ],
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AboutUgtWidget(title: "Status", content: "Ongoing"),
                  const Gap(30),
                  AboutUgtWidget(title: "Prize", content: "N100,000"),
                  const Gap(30),
                  AboutUgtWidget(title: "Category", content: "Music"),
                ],
              ),
              const Gap(20),
              WayaButton(
                callback: () {},
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

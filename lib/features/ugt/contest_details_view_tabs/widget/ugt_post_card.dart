import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:gap/gap.dart';

class UgtPostCard extends ConsumerWidget {
  const UgtPostCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);

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
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: context.width * 0.4,
                              child: Text(
                                "Rufai Maleek",
                                overflow: TextOverflow.ellipsis,
                                style: wayaTheme.textTheme.bodyMedium,
                              ),
                            ),
                            const Gap(8),
                            Text(
                              'Today',
                              style: wayaTheme.textTheme.hintStyle,
                            ),
                          ],
                        ),
                        // Spacer(),
                        Gap(
                          context.width * 0.15,
                        ),
                        //  post.isFollowing!
                        Image.asset("assets/images/vector.png"),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Text('''Hello everyone, I’m trying to be diligent and sharing with
the tribe as! 🚀 #TechLife #Productivity''',
                  style: wayaTheme.textTheme.bodySmall),
              const Gap(20),
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(16), // Adjust the radius as needed
                child: Image.asset(
                  'assets/images/frameuni.png',
                  height: 200,
                  fit: BoxFit
                      .cover, // Ensures the image covers the area properly
                ),
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
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
                              "0 Likes",
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
                        onTap: () {},
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
                                      "assets/icons/u-share.svg")),
                            ),
                            const Gap(3),
                            Text(
                              "0 Shares",
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
                  WayaButton(
                    fontSize: 14,
                    callback: () {},
                    text: "Vote Candidate",
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
  DateTime date = DateTime.parse(isoDate);
  String day = DateFormat('d').format(date);
  String suffix = getDaySuffix(int.parse(day));
  String month = DateFormat('MMM').format(date);
  String year = DateFormat('y').format(date);
  return "$day$suffix $month $year";
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

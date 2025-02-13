import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/data/model/default.dart';

class PagesCard extends ConsumerWidget {
  final bool isPage;
  final bool isFollowing;
  final bool isFollow;
  final bool isGroup;
  final bool isRecommendedGroup;
  final bool isGroupMember;
  final GroupDefault group;
  const PagesCard(
      {super.key,
      this.isFollow = false,
      this.isFollowing = false,
      this.isGroup = false,
      this.isGroupMember = false,
      this.isRecommendedGroup = false,
      required this.group,
      this.isPage = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.white,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        WayaImage(
                          imageUrl: "",
                          height: 60,
                          width: 60,
                          radius: BorderRadius.circular(16),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 150.w,
                              child: Text(group.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: wayaTheme.textTheme.bodyMedium),
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            SizedBox(
                              width: 150.w,
                              child: Text(
                                "${WayaHelpers.abbreviateNumber(group.numberOfFollowers)} Followers",
                                style: wayaTheme.textTheme.hintStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    if (isFollow || isRecommendedGroup)
                      SizedBox(
                        width: 60,
                        child: WayaButton(
                          callback: () {},
                          text: isRecommendedGroup ? 'Join' : 'Follow',
                          height: 30,
                          textStyle: TextStyle(
                              color: wayaTheme.colorScheme.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                          radius: 6,
                        ),
                      ),
                    if (isFollowing || isGroupMember)
                      SizedBox(
                        width: 80,
                        child: WayaButton(
                          callback: () {},
                          text: isGroupMember ? 'Member' : 'Following',
                          height: 30,
                          textColor: wayaTheme.colorScheme.customPrimary,
                          textStyle: TextStyle(
                              color: wayaTheme.colorScheme.customPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                          radius: 6,
                          color: wayaTheme.colorScheme.transparent,
                          border: Border.all(
                              width: 1,
                              color: wayaTheme.colorScheme.customPrimary),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  "Find your sound . Discuss writing, composing, recording, and much more",
                  style: wayaTheme.textTheme.hintStyle,
                )
              ],
            )),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}

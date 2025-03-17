import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

import '../../../core/components/waya_scaffold.dart';

class ManageStateSingleContest extends StatefulHookConsumerWidget {
  static const route = '/manage-application-single-contest';
  const ManageStateSingleContest({super.key});

  @override
  ConsumerState<ManageStateSingleContest> createState() =>
      _ManageStateContestState();
}

class _ManageStateContestState extends ConsumerState<ManageStateSingleContest> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Lagos States",
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        //  padding: EdgeInsets.all(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Text("Your Bio", style: wayaTheme.textTheme.bodyMedium),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Overview",
                    style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
              ],
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                    context,
                    "Number of Contestants",
                    "57",
                    Icon(
                      Icons.map_outlined,
                      color: Colors.white,
                    )),
              ],
            ),

            SizedBox(height: 20),

            // Manage States
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        WayaNav.toNamed('/contest-active-disqualify');
                      },
                      child: _buildStateItem(context, "Obubra Inengite", "")),
                  Gap(20),
                  _buildStateItem(context, "Oluchi Obiano", ""),
                  Gap(20),
                  _buildStateItem(context, "Sadiya Wakili", ""),
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String title, String value, Widget widget) {
    final wayaTheme = Theme.of(context);
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[700])),
                Container(
                    width: 50.w, // Must be equal to height for a perfect circle
                    height: 50.w,
                    decoration: BoxDecoration(
                      color:
                          wayaTheme.colorScheme.primary500, // Background color
                      shape: BoxShape.circle, // Makes the container circular
                      border: Border.all(
                        color: Colors.white, // Optional: Border color
                        width: 3.0, // Optional: Border width
                      ),
                    ),
                    child: widget)
              ],
            ),
            Gap(10),
            Text(value,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title,
      {bool seeAll = false, seeStatistic = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          if (seeAll)
            Row(
              children: [
                Text("See all",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold)),
                Gap(10),
                Icon(Icons.arrow_forward_ios, size: 18, color: Colors.orange)
              ],
            ),
          if (!seeAll && !seeStatistic)
            Row(
              children: [
                Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
                Gap(10)
              ],
            ),
          if (seeStatistic)
            Row(
              children: [
                Icon(Icons.leaderboard_outlined,
                    size: 18, color: Colors.orange),
                Gap(10)
              ],
            )
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(BuildContext context, String votes, String rank,
      String name, Color color) {
    final wayaTheme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                  width: context.width * 0.3,
                  child: Text(votes,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: wayaTheme.colorScheme.greyColor100, // Background color

                  borderRadius: BorderRadius.circular(
                      10), // Optional: for rounded corners
                ),
                child: Center(
                  child: Text(rank,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.orange)),
                ),
              ),
            ],
          ),
          SizedBox(
              width: context.width * 0.3,
              child: Text(
                name,
                //  overflow: TextOverflow.ellipsis,
              )),
        ],
      ),
    );
  }

  Widget _buildStateItem(
      BuildContext context, String state, String contestants) {
    final wayaTheme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: Image.asset(
                'assets/images/frameuni.png',
                height: 45,
                width: 45,
                fit: BoxFit.cover, // Ensures the image covers the area properly
              ),
            ),
            Gap(15),
            Text(state,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 16.sp)),
          ],
        ),
        Row(
          children: [
            Text(contestants,
                style: TextStyle(
                    color: wayaTheme.colorScheme.greyColor700, fontSize: 14.sp)),
            Gap(10),
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
            Gap(10)
          ],
        ),
      ],
    );
  }
}

Color getColor(bool isText, String text) {
  return isText ? Color(0xff9E0A05) : Color(0xffFEF6E7);
  /*  } else if (text == "rejected") {
      return isText ? Color(0xff9E0A05) : Color(0xffFBEAE9);
    } else {
      return isText ? Color(0xff865503) : Color(0xffFEF6E7);
    } */
}


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
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/ugt_details_leaderboard.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/ugt_details_post.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/ugt_leaderboard_card.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/features/ugt/widgets/contest_card.dart';
import 'package:wayagram/features/ugt/widgets/upcoming_widgets/upcoming_widget.dart';

import '../../../core/components/waya_scaffold.dart';

class DashboardContestPage extends StatefulHookConsumerWidget {
  static const route = '/contest-mydashboard-profile-page';
  const DashboardContestPage({super.key});

  @override
  ConsumerState<DashboardContestPage> createState() =>
      _DashboardContestPageState();
}

class _DashboardContestPageState extends ConsumerState<DashboardContestPage> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.read(votersContestNotifier);
    var model = ref.watch(selectedContestProvider.notifier).state;
    print("my title ${model.title}");
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "",
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        //  padding: EdgeInsets.all(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Stats Section
            Text("Dashboard",
                style: wayaTheme.textTheme.displaySmall!
                    .wayaCopyWith(fontWeight: FontWeight.w700)),
            const Gap(5),
            Text("Manage your contest activity",
                style: wayaTheme.textTheme.hintStyle
                    .wayaCopyWith(fontSize: 16, fontWeight: FontWeight.w400)),
            //  Text("Your Bio", style: wayaTheme.textTheme.bodyMedium),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
               if (ConversationState.self.role?.name == "BUSINESS")   SizedBox(
                  width: context.width / 2.5,
                  child: WayaButton(
                      horizontalPadding: 10,
                      fontSize: 14.sp,
                      height: 42,
                      text: "Edit contest details",
                      callback: () async {
                        ivalidateUGTVM(ref);
                        ref.read(stateIsEditingContestProvider.notifier).state =
                            true;
                        ref.watch(selectedContestProvider.notifier).state =
                            model;
                        WayaNav.toNamed('/create-contest');
                      }),
                ),
                Gap(10),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    //  margin: EdgeInsets.only(right: 20.w),
                    padding: REdgeInsets.symmetric(
                        vertical: 8.dg, horizontal: 12.dg),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: wayaTheme.colorScheme.primary600,
                        width: 1.5,
                      ),
                      color: wayaTheme.colorScheme.white,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Filter',
                          style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                            color: wayaTheme.colorScheme.primary600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(5),
                        WayaAssets.icons.actionFilter.svg(
                          color: wayaTheme.colorScheme.primary600,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard("Number of participants", "240"),
                _buildStatCard("Votes per contestant", "120"),
                _buildStatCard("Contest Age\n", "2"),
              ],
            ),

            SizedBox(height: 20),

            // Time Remaining
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                // color: Colors.orange[100],
                border: Border.all(
                  color: Colors.green[100]!, // Border color
                  width: 1.0, // Border width
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Contest time remaining",
                        style: TextStyle(
                            color: wayaTheme.colorScheme.greyColor500,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.timelapse_outlined, color: Colors.orange),
                    ],
                  ),
                  Gap(10),
                  Text(
                    "12 days: 45hrs: 55min: 12sec",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Leaderboard
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                // color: Colors.orange[100],
                border: Border.all(
                  color: Colors.green[100]!, // Border color
                  width: 1.0, // Border width
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _buildSectionTitle("Leaderboard"),
                  /*  ListView.builder(
                    //  controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: viewModel.myContestList.length,
                    itemBuilder: (context, index) {
                      if (viewModel.isLoading!) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final post = viewModel.myContestList[index];
                      return GestureDetector(
                        onTap: () {},
                        child: UgtLeaderboardCard(
                            model: widget.model,
                            position: index + 1,
                            contestantData: post),
                      );
                    },
                  ), */
                  if (viewModel.myContestList.length > 1)
                    _buildLeaderboardItem(
                      context,
                      "${viewModel.myContestList[0].votes} votes",
                      "1st",
                      "${viewModel.myContestList[0].contestApplicant?.fullName}",
                      wayaTheme.colorScheme.success50,
                    ),
                  if (viewModel.myContestList.length > 2)
                    _buildLeaderboardItem(
                      context,
                      "${viewModel.myContestList[1].votes} votes",
                      "2nd",
                      "${viewModel.myContestList[1].contestApplicant?.fullName}",
                      Color(0xffFEF6E7),
                    ),
                  if (viewModel.myContestList.length > 3)
                    _buildLeaderboardItem(
                      context,
                      "${viewModel.myContestList[2].votes} votes",
                      "3rd",
                      "${viewModel.myContestList[2].contestApplicant?.fullName}",
                      Color(0xffF9FAFB),
                    ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Manage States
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                // color: Colors.orange[100],
                border: Border.all(
                  color: Colors.green[100]!, // Border color
                  width: 1.0, // Border width
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        WayaNav.toNamed('/manage-contest-stage');
                      },
                      child: _buildSectionTitle("Manage states")),
                  Gap(10),
                  _buildStateItem(context, "Lagos state", "241 contestants"),
                  Gap(10),
                  _buildStateItem(context, "Oyo state", "241 contestants"),
                  Gap(10),
                  _buildStateItem(context, "Ogun state", "241 contestants"),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Manage Contestants
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                // color: Colors.orange[100],
                border: Border.all(
                  color: Colors.green[100]!, // Border color
                  width: 1.0, // Border width
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        WayaNav.toNamed('/contest-active-disqualify');
                      },
                      child: _buildSectionTitle("Manage contestants",
                          seeAll: true)),
                  ListView.builder(
                    // controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: viewModel.myContestList.length > 6
                        ? 6
                        : viewModel.myContestList.length,
                    itemBuilder: (context, index) {
                      if (viewModel.isLoading!) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final post = viewModel.myContestList[index];
                      return GestureDetector(
                        onTap: () {
                          WayaNav.toNamed('/contest-active-disqualify');
                        },
                        child: _buildProfileItem(context,
                            post.contestApplicant?.fullName ?? "", true),
                      );
                    },
                  ),
                  /*   _buildProfileItem(context, "Obubra Imengie", true),
                  Gap(10),
                  _buildProfileItem(context, "Oluchi Obiano", true),
                  Gap(10),
                  _buildProfileItem(context, "Sadiya Wakil", true),
                  Gap(10),
                  _buildProfileItem(context, "Ibrahim Ahmad", true),
                  Gap(10),
                  _buildProfileItem(context, "Ibrahim Nasiru", true), */
                ],
              ),
            ),

            SizedBox(height: 20),

            // Submitted Applications
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                // color: Colors.orange[100],
                border: Border.all(
                  color: Colors.green[100]!, // Border color
                  width: 1.0, // Border width
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        WayaNav.toNamed('/manage-application-contest');
                      },
                      child: _buildSectionTitle("Submitted Applications",
                          seeAll: true)),
                  Gap(10),
                  ListView.builder(
                    // controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: viewModel.myContestApplicantList.length > 6
                        ? 6
                        : viewModel.myContestApplicantList.length,
                    itemBuilder: (context, index) {
                      if (viewModel.isLoading!) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final post = viewModel.myContestApplicantList[index];
                      return GestureDetector(
                        onTap: () {
                          ref.read(selectedApplicantProfile.notifier).state =
                              post;

                          WayaNav.toNamed('/view-contestant-single-data');
                        },
                        child: _buildProfileItem(
                            context, post.fullName ?? "", false),
                      );
                    },
                  ),

                  /*   GestureDetector(
                      onTap: () {
                        // WayaNav.toNamed('/manage-application-contest');
                      },
                      child:
                          _buildProfileItem(context, "Obubra Imengie", false)),
                  Gap(10),
                  _buildProfileItem(context, "Oluchi Obiano", false),
                  Gap(10),
                  _buildProfileItem(context, "Sadiya Wakil", false),
                  Gap(10),
                  _buildProfileItem(context, "Ibrahim Ahmad", false), */
                ],
              ),
            ),

            SizedBox(height: 20),

            // Contest Stages
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                // color: Colors.orange[100],
                border: Border.all(
                  color: Colors.green[100]!, // Border color
                  width: 1.0, // Border width
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _buildSectionTitle("Contest stage", seeStatistic: true),
                  _buildStageItem("Stage 1: General Level", true),
                  _buildStageItem("Stage 2: State Level", false),
                  _buildStageItem("Stage 3: National Level", false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
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
          children: [
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey[700])),
            Gap(10),
            Text(value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.greyColor50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(state,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16)),
          Text(contestants,
              style: TextStyle(
                  color: wayaTheme.colorScheme.greyColor700, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, String name, bool isprofile) {
    final wayaTheme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.greyColor50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16)),
          Text(isprofile ? "View profile" : "View application",
              style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildApplicationItem(String name) {
    return ListTile(
      title: Text(name),
      trailing: Text("View application",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStageItem(String stage, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(stage, style: TextStyle(fontWeight: FontWeight.bold)),
        Switch(value: isActive, onChanged: (bool value) {}),
      ],
    );
  }
}
/*   @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    var model = ref.watch(selectedContestProvider.notifier).state;
    final selectedViewIndex = useState(0);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "",
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  const Gap(10),

              Text("Dashboard",
                  style: wayaTheme.textTheme.displaySmall!
                      .wayaCopyWith(fontWeight: FontWeight.w700)),
              const Gap(5),
              Text("Manage your contest activity",
                  style: wayaTheme.textTheme.hintStyle
                      .wayaCopyWith(fontSize: 16, fontWeight: FontWeight.w400)),
              //  Text("Your Bio", style: wayaTheme.textTheme.bodyMedium),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: context.width / 2.5,
                    child: WayaButton(
                        horizontalPadding: 10,
                        fontSize: 14.sp,
                        height: 42,
                        text: "Edit contest details",
                        callback: () async {}),
                  ),
                  Gap(10),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      //  margin: EdgeInsets.only(right: 20.w),
                      padding: REdgeInsets.symmetric(
                          vertical: 8.dg, horizontal: 12.dg),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: wayaTheme.colorScheme.primary600,
                          width: 1.5,
                        ),
                        color: wayaTheme.colorScheme.white,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Filter',
                            style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                              color: wayaTheme.colorScheme.primary600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Gap(5),
                          WayaAssets.icons.actionFilter.svg(
                            color: wayaTheme.colorScheme.primary600,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
            ],
          ),
        ),
      ),
    );
  } */

Color getColor(bool isText, String text) {
  return isText ? Color(0xff9E0A05) : Color(0xffFEF6E7);
  /*  } else if (text == "rejected") {
      return isText ? Color(0xff9E0A05) : Color(0xffFBEAE9);
    } else {
      return isText ? Color(0xff865503) : Color(0xffFEF6E7);
    } */
}

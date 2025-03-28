import 'dart:async';

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
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/pdf/contestant_pdf.dart';
import 'package:wayagram/features/ugt/vm/ugt_admin_dashboard_vm.dart';

import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

import '../../../core/components/waya_scaffold.dart';

class DashboardContestPage extends StatefulHookConsumerWidget {
  static const route = '/contest-mydashboard-profile-page';
  const DashboardContestPage({super.key});

  @override
  ConsumerState<DashboardContestPage> createState() =>
      _DashboardContestPageState();
}

class _DashboardContestPageState extends ConsumerState<DashboardContestPage> {
  DateTime targetDate = DateTime(2026, 1, 1, 0, 0, 0); // Example: New Year 2025
  Duration remainingTime = Duration();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Prevent memory leaks
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = targetDate.difference(now);

      if (difference.isNegative) {
        timer.cancel(); // Stop timer when target date is reached
      }

      setState(() {
        remainingTime = difference;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(votersContestNotifier);
    final notifier = ref.read(votersContestNotifier.notifier);
    final dashboardNotifier = ref.watch(ugtAdminDashboardVm.notifier);
    final dashboardVm = ref.watch(ugtAdminDashboardVm);
    var model = ref.watch(selectedContestProvider);
    useEffect(() {
      dashboardNotifier.fetchTotalContestant(model?.id ?? "");
      dashboardNotifier.fetchTotalEarnings(model?.id ?? "", "all");
      Future.delayed(Duration(seconds: 1), () {
        notifier.addStages(model?.contestSettings?.stages ?? []);
      });
      targetDate = DateTime.parse(model?.endDate ?? "2026-01-01T00:00:00.000Z");
      return null;
    }, []);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      onRefresh: (){
          ref
              .read(votersContestNotifier.notifier)
              .fetchAllContestApplicant(model?.id??"");
         dashboardNotifier.fetchTotalContestant(model?.id ?? "");
     return dashboardNotifier.fetchTotalEarnings(model?.id ?? "", "all");
      },
      title: "",
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        //  padding: EdgeInsets.all(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Stats Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Dashboard",
                        style: wayaTheme.textTheme.displaySmall!
                            .wayaCopyWith(fontWeight: FontWeight.w700)),
                    const Gap(5),
                    Text("Manage your contest activity",
                        style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                            fontSize: 16.sp, fontWeight: FontWeight.w400)),
                  ],
                ),
                PopupMenuButton(
                  onSelected: (value) {},
                  position: PopupMenuPosition.under,
                  itemBuilder: (context) {
                    return [
                      ...filterList.map((e) {
                        return PopupMenuItem<int>(
                          value: 1,
                          child: _buildActionNav(
                              context: context,
                              onTap: () {
                                WayaNav.goBack();
                                dashboardNotifier.fetchTotalEarnings(
                                    model?.id ?? "", e.text.toLowerCase());
                                selectPresentTap(e);
                              },
                              asset: WayaAssets.icons.mComments.svg(
                                color: wayaTheme.colorScheme.customBlack,
                                height: 20,
                              ),
                              text: e.text,
                              isActive: e.isActive,
                              color: wayaTheme.colorScheme.customBlack),
                        );
                      })
                    ];
                  },
                  child: Container(
                    //  margin: EdgeInsets.only(right: 20.w),
                    width: 130.w,
                    padding: REdgeInsets.symmetric(
                        vertical: 8.dg, horizontal: 12.dg),
                    decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.greyColor100,
                      border: Border.all(
                        color: wayaTheme.colorScheme.greyColor300,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WayaAssets.icons.actionFilter.svg(
                          color: wayaTheme.colorScheme.greyColor400,
                          //  color: wayaTheme.colorScheme.primary600,
                        ),
                        Gap(5),
                        Text(
                          'Filter By',
                          style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                            color: wayaTheme.colorScheme.greyColor400,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(5),
                        WayaAssets.icons.downArrow.svg(
                          color: wayaTheme.colorScheme.greyColor400,
                          //color: wayaTheme.colorScheme.primary600,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            //  Text("Your Bio", style: wayaTheme.textTheme.bodyMedium),
            const Gap(20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (ConversationState.self.accountType ==
                    UserAccountType.business)
                  SizedBox(
                    width: context.width / 2.5,
                    child: WayaButton(
                        horizontalPadding: 10,
                        fontSize: 14.sp,
                        height: 42,
                        text: "Edit contest details",
                        callback: () async {
                          ivalidateUGTVM(ref);
                          ref
                              .read(stateIsEditingContestProvider.notifier)
                              .state = true;
                          ref.watch(selectedContestProvider.notifier).state =
                              model;
                          WayaNav.toNamed('/create-contest');
                        }),
                  ),
                Gap(10),
                GestureDetector(
                  onTap: () {
                    //?added ability to conver to pdf

                    convertContestantToPDF(viewModel.myContestList,
                        "${viewModel.myContestApplicantList.length - viewModel.myFilteredContestApplicantList.length}");
                  },
                  child: Container(
                    //  margin: EdgeInsets.only(right: 20.w),
                    width: 130.w,
                    padding: REdgeInsets.symmetric(
                        vertical: 8.dg, horizontal: 12.dg),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: wayaTheme.colorScheme.primary600,
                        width: 1.5,
                      ),
                      color: wayaTheme.colorScheme.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        WayaAssets.icons.export.svg(
                          width: 18,
                          height: 18,
                          fit: BoxFit.scaleDown,
                          color: wayaTheme.colorScheme.primary600,
                        ),
                        Gap(8),
                        Text(
                          'Export Data',
                          style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                            color: wayaTheme.colorScheme.primary600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Gap(20),
            GestureDetector(
              onTap: () {
                WayaNav.toNamed('/admin-transaction-page');
              },
              child: _buildStatCard2(context, "Revenue Generated",
                  "₦${dashboardVm.revenueGenerated}"),
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(context, "Number of participants",
                    "${dashboardVm.totalContestants}"),
                //  _buildStatCard("Votes per contestant", "120"),
                _buildStatCard(context, "Contest Stage",
                    model?.contestSettings?.stages?.length.toString() ?? "0"),
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
                      Icon(Icons.timelapse_outlined,
                          color: wayaTheme.primaryColor),
                    ],
                  ),
                  Gap(10),
                  Text(
                    "${remainingTime.inDays}days  :   ${remainingTime.inHours.remainder(24)}hrs  :  ${remainingTime.inMinutes.remainder(60)}mins  :  ${remainingTime.inSeconds.remainder(60)}sec",
                    style: TextStyle(
                        color: wayaTheme.primaryColor,
                        fontWeight: FontWeight.bold),
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
                  InkWell(
                      onTap: () {
                        WayaNav.toNamed('/manage-leaderboard-page');
                      },
                      child: _buildSectionTitle("Leaderboard")),
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
                  if (viewModel.myContestList.isNotEmpty)
                    _buildLeaderboardItem(
                      context,
                      "${viewModel.myContestList[0].votes} votes",
                      "1st",
                      "${viewModel.myContestList[0].contestApplicant?.fullName}",
                      wayaTheme.colorScheme.success50,
                    ),
                  if (viewModel.myContestList.length > 1)
                    _buildLeaderboardItem(
                      context,
                      "${viewModel.myContestList[1].votes} votes",
                      "2nd",
                      "${viewModel.myContestList[1].contestApplicant?.fullName}",
                      Color(0xffFEF6E7),
                    ),
                  if (viewModel.myContestList.length > 2)
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

            /*   // Manage States
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

            SizedBox(height: 20), */

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
                    physics: BouncingScrollPhysics(),
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
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        viewModel.myFilteredContestApplicantList.length > 6
                            ? 6
                            : viewModel.myFilteredContestApplicantList.length,
                    itemBuilder: (context, index) {
                      if (viewModel.isLoading!) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final post =
                          viewModel.myFilteredContestApplicantList[index];
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
                  ...viewModel.stageList.map((e) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.stageName ?? "",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Switch(
                            value: e.isActive ?? false,
                            onChanged: (bool value) {
                              print("map ${e.toString()}");
                              notifier.startStageContest(e.stageName ?? "", {
                                "contestId": model?.id ?? "",
                                "stageName": e.stageName ?? ""
                              });
                            }),
                      ],
                    );
                  })

                  /*  _buildStageItem("Stage 1: General Level", true),
                  _buildStageItem("Stage 2: State Level", false),
                  _buildStageItem("Stage 3: National Level", false), */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
/*      Widget _buildStageItemStages(Stages stage, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(stage.stageName??"", style: TextStyle(fontWeight: FontWeight.bold)),
        Switch(value: isActive, onChanged: (bool value) {

           notifier.startStageContest(e.stageName ?? "", {
                          "contestId": model.id ?? "",
                          "stageName": e.stageName ?? ""
                        });

         
        }),
      ],
    );
  } */

  Widget _buildStatCard(BuildContext context, String title, String value) {
    final wayaTheme = Theme.of(context);
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: wayaTheme.colorScheme.primary50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                textAlign: TextAlign.center,
                style: WayaTextStyles.hintStyleBold),
            Gap(10),
            Text(value, style: WayaTextStyles.headlineMedium),
          ],
        ),
      ),
    );
  }

  InkWell _buildActionNav(
      {required BuildContext context,
      required VoidCallback onTap,
      required Widget asset,
      required String text,
      required bool isActive,
      required Color color}) {
    final wayaTheme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // asset,
          //const Gap(4),
          Text(
            text,
            style: WayaTextStyles.bodyMedium.copyWith(color: color),
          ),
          if (isActive)
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: wayaTheme
                    .primaryColor, // Background color for the checkmark
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard2(BuildContext context, String title, String value) {
    final wayaTheme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.primary50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title,
              textAlign: TextAlign.center, style: WayaTextStyles.hintStyleBold),
          Gap(5),
          Row(
            children: [
              Text(value, style: WayaTextStyles.headlineMedium),
              Text(".00",
                  style: WayaTextStyles.headlineMedium.copyWith(
                    color: wayaTheme.colorScheme.greyColor300,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title,
      {bool seeAll = false, seeStatistic = false}) {
    final wayaTheme = Theme.of(context);
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
                        color: wayaTheme.primaryColor,
                        fontWeight: FontWeight.bold)),
                Gap(10),
                Icon(Icons.arrow_forward_ios,
                    size: 18, color: wayaTheme.primaryColor)
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
                    size: 18, color: wayaTheme.primaryColor),
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
                          fontWeight: FontWeight.bold,
                          color: wayaTheme.primaryColor)),
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
                  fontSize: 16.sp)),
          Text(isprofile ? "View profile" : "View application",
              style: TextStyle(
                  color: wayaTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp)),
        ],
      ),
    );
  }

  void selectPresentTap(MyFilterModel e) {
    var list = filterList.map((user) {
      if (user == e) {
        return MyFilterModel(
            text: user.text, isActive: true); // Change isActive to false
      }
      return MyFilterModel(text: user.text, isActive: false);
    }).toList();
    setState(() {
      filterList = list;
    });
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

var filterList = [
  MyFilterModel(text: 'All', isActive: true),
  MyFilterModel(text: 'Weekly', isActive: false),
  MyFilterModel(text: 'Monthly', isActive: false),
];

class MyFilterModel {
  final String text;
  final bool isActive;

  MyFilterModel({required this.text, required this.isActive});
}

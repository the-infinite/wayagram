import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/ugt/contest_dashboard.dart/manage_state_single_contest.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';

import '../../../core/components/waya_scaffold.dart';

class AllStateContest extends StatefulHookConsumerWidget {
  static const route = '/all-state-contest';
  const AllStateContest({super.key});

  @override
  ConsumerState<AllStateContest> createState() => _ManageStateContestState();
}

class _ManageStateContestState extends ConsumerState<AllStateContest> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.read(votersContestNotifier);

    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Manage States",
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
            /*   Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                    context,
                    "Number of\nApplication\nsubmitted",
                    viewModel.myContestApplicantList.length.toString(),
                    Icon(
                      Icons.map_outlined,
                      color: Colors.white,
                    )),
                _buildStatCard(
                    context,
                    "Number of\nApproved\nApplication",
                    "${viewModel.myContestApplicantList.length - viewModel.myFilteredContestApplicantList.length}",
                    Icon(
                      Icons.map_outlined,
                      color: Colors.white,
                    )),
              ],
            ),

            SizedBox(height: 20), */

            // Manage States
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  ListView.builder(
                    // controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: viewModel.listState.length,
                    itemBuilder: (context, index) {
                      if (viewModel.isLoading!) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final post = viewModel.listState[index];
                      return GestureDetector(
                        onTap: () {
                          WayaNav.toNamed(ManageStateSingleContest.route);
                        },
                        child: _buildProfileItem2(
                          context,
                          post.state,
                          post.id,
                        ),
                      );
                    },
                  ),
                  /*   ListView.builder(
                    // controller: _scrollController,
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
                        child: _buildStateItem(
                            context, post.fullName ?? "", "View application"),
                      );
                    },
                  ), */
                  /* GestureDetector(
                    onTap: () {
                      WayaNav.toNamed('/view-contestant-single-data');
                    },
                    child: _buildStateItem(
                        context, "Obubra Inengite", "View application"),
                  ),
                  Gap(20),
                  _buildStateItem(context, "Oluchi Obiano", "View application"),
                  Gap(20),
                  _buildStateItem(context, "Sadiya Wakili", "View application"), */
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem2(
      BuildContext context, String name, String numberContestant) {
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
          Text("$numberContestant contestants",
              style: TextStyle(
                  color: wayaTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp)),
        ],
      ),
    );
  }

//   Widget _buildStatCard(
//       BuildContext context, String title, String value, Widget widget) {
//     final wayaTheme = Theme.of(context);
//     return Expanded(
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 4),
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.orange[50],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(title,
//                     textAlign: TextAlign.start,
//                     style: TextStyle(fontSize: 12.sp, color: Colors.grey[700])),
//                 Container(
//                     width: 50.w, // Must be equal to height for a perfect circle
//                     height: 50.w,
//                     decoration: BoxDecoration(
//                       color:
//                           wayaTheme.colorScheme.primary500, // Background color
//                       shape: BoxShape.circle, // Makes the container circular
//                       border: Border.all(
//                         color: Colors.white, // Optional: Border color
//                         width: 3.0, // Optional: Border width
//                       ),
//                     ),
//                     child: widget)
//               ],
//             ),
//             Gap(10),
//             Text(value,
//                 style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStateItem(BuildContext context, String state, String contestants) {
//     final wayaTheme = Theme.of(context);
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(state, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 16.sp)),
//         Row(
//           children: [
//             Text(contestants, style: TextStyle(color: wayaTheme.colorScheme.greyColor700, fontSize: 14.sp)),
//             Gap(10),
//             Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
//             Gap(10)
//           ],
//         ),
//       ],
//     );
//   }
}

Color getColor(bool isText, String text) {
  return isText ? Color(0xff9E0A05) : Color(0xffFEF6E7);
  /*  } else if (text == "rejected") {
      return isText ? Color(0xff9E0A05) : Color(0xffFBEAE9);
    } else {
      return isText ? Color(0xff865503) : Color(0xffFEF6E7);
    } */
}

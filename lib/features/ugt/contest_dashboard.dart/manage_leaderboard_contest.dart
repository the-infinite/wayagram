import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/ugt_leaderboard_card.dart';
import 'package:wayagram/features/ugt/vm/ugt_admin_dashboard_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';

import '../../../core/components/waya_scaffold.dart';

class ManageLeaderboardContest extends StatefulHookConsumerWidget {
  static const route = '/manage-leaderboard-page';
  const ManageLeaderboardContest({super.key});

  @override
  ConsumerState<ManageLeaderboardContest> createState() =>
      _ManageStateContestState();
}

class _ManageStateContestState extends ConsumerState<ManageLeaderboardContest> {
  @override
  Widget build(BuildContext context) {
    //final wayaTheme = Theme.of(context);
    final dashboardVm = ref.read(ugtAdminDashboardVm);
    final viewModel = ref.watch(votersContestNotifier);
    var model = ref.watch(selectedContestProvider);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Leaderboard",
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
                Text("Overview", style: WayaTextStyles.bodyExtraMedium),
              ],
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /*  _buildStatCard(
                    context,
                    "Number of\n States",
                    "10",
                    Icon(
                      Icons.map_outlined,
                      color: Colors.white,
                    )), */
                _buildStatCard(
                    context,
                    "Number of Contestants",
                    "${dashboardVm.totalContestants}",
                    Icon(
                      Icons.map_outlined,
                      color: Colors.white,
                    )),
              ],
            ),

            SizedBox(height: 20),

            if (viewModel.myContestList.isEmpty) emptyWidget(),

            if (viewModel.myContestList.isNotEmpty)
              ListView.builder(
                // controller: _scrollController,
                shrinkWrap: true,
                itemCount: viewModel.myContestList.length,
                itemBuilder: (context, index) {
                  final post = viewModel.myContestList[index];
                  return GestureDetector(
                    onTap: () {},
                    child: UgtLeaderboardCard(
                        model: model!,
                        position: index + 1,
                        contestantData: post),
                  );
                },
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
                    style: WayaTextStyles.hintStyleBold),
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
            const Gap(10),
            Text(value, style: WayaTextStyles.headlineMedium),
          ],
        ),
      ),
    );
  }

  Widget emptyWidget() {
    return UgtEmptyState(
        icon: WayaAssets.images.uEmptystate.image(),
        desc: "There are no contestant for this contes yet",
        title: "No Contestestant yet",
        buttonText: "Host a Contest",
        hideButton: true,
        onTap: () {});
  }

  Color getColor(bool isText, String text) {
    return isText ? Color(0xff9E0A05) : Color(0xffFEF6E7);
    /*  } else if (text == "rejected") {
      return isText ? Color(0xff9E0A05) : Color(0xffFBEAE9);
    } else {
      return isText ? Color(0xff865503) : Color(0xffFEF6E7);
    } */
  }
}

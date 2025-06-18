import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/ugt_history_card.dart';
import 'package:wayagram/features/ugt/vm/ugt_admin_dashboard_vm.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';

import '../../../core/components/waya_scaffold.dart';

class AdminTransactionHistory extends StatefulHookConsumerWidget {
  static const route = '/admin-transaction-page';
  const AdminTransactionHistory({super.key});

  @override
  ConsumerState<AdminTransactionHistory> createState() =>
      _ManageStateContestState();
}

class _ManageStateContestState extends ConsumerState<AdminTransactionHistory> {
  @override
  Widget build(BuildContext context) {
    //final wayaTheme = Theme.of(context);
    final dashboardVm = ref.read(ugtAdminDashboardVm);
    //final viewModel = ref.watch(votersContestNotifier);
    //var model = ref.watch(selectedContestProvider);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Transaction History",
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
                /*   GestureDetector(
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
                ), */
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
                    "Revenue Generated",
                    "₦${dashboardVm.revenueGenerated}",
                    Icon(
                      Icons.map_outlined,
                      color: Colors.white,
                    )),
              ],
            ),

            SizedBox(height: 20),

            if (dashboardVm.transactionList.isEmpty) emptyWidget(),

            if (dashboardVm.transactionList.isNotEmpty)
              ListView.builder(
                // controller: _scrollController,
                shrinkWrap: true,
                itemCount: dashboardVm.transactionList.length,
                itemBuilder: (context, index) {
                  final post = dashboardVm.transactionList[index];
                  return GestureDetector(
                    onTap: () {},
                    child: UgtHistoryCard(
                      model: post,
                      position: index + 1,
                    ),
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
            Gap(10),
            Text(value, style: WayaTextStyles.headlineMedium),
          ],
        ),
      ),
    );
  }

  Widget emptyWidget() {
    return UgtEmptyState(
        icon: WayaAssets.images.uEmptystate.image(),
        desc: "Transaction history is empty",
        title: "No Transaction History",
        buttonText: "Host a Contest",
        showButtonBusiness: true,
        hideButton: false,
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

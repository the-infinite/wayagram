// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/ugt_history_card.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/ugt_payout_history_card.dart';
import 'package:wayagram/features/ugt/vm/ugt_admin_dashboard_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';
import '../../../core/components/waya_scaffold.dart';

class UgtPayoutHistory extends StatefulHookConsumerWidget {
  static const route = '/ugt-payout-history-page';
  const UgtPayoutHistory({super.key});

  @override
  ConsumerState<UgtPayoutHistory> createState() => _ManageStateContestState();
}

class _ManageStateContestState extends ConsumerState<UgtPayoutHistory> {
  @override
  Widget build(BuildContext context) {
    //final wayaTheme = Theme.of(context);
    final walletViewModel = ref.watch(walletVmProvider);
    final notifier = ref.watch(walletVmProvider.notifier);
    //final viewModel = ref.watch(votersContestNotifier);
    var model = ref.watch(selectedContestProvider);
    useEffect(() {
      notifier.fetchUserPayoutTransaction(model?.id ?? "", "CONTEST");

      return null;
    }, []);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Payout History",
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
            /*   Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                    context,
                    "Revenue\nGenerated",
                    "₦${formatMoney(dashboardVm.revenueGenerated?.toString() ?? '0')}",
                    Icon(
                      Icons.map_outlined,
                      color: Colors.white,
                    )),
                _buildStatCard(
                    context,
                    "Total\nCommissions",
                    "₦${formatMoney(dashboardVm.totalCommission?.toString() ?? '0')}",
                    Icon(
                      Icons.map_outlined,
                      color: Colors.white,
                    )),
              ],
            ), */

            SizedBox(height: 20),

            if (walletViewModel.payoutHistoryList.isEmpty) emptyWidget(),

            if (walletViewModel.payoutHistoryList.isNotEmpty)
              ListView.builder(
                // controller: _scrollController,
                shrinkWrap: true,
                itemCount: walletViewModel.payoutHistoryList.length,
                itemBuilder: (context, index) {
                  final post = walletViewModel.payoutHistoryList[index];
                  return GestureDetector(
                    onTap: () {},
                    child: UgtPayoutHistoryCard(
                      model: post,
                      isPayout: true,
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
        desc: "Payout history is empty",
        title: "No Payout History",
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

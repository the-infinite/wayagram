import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/forgot_password/vm/credential_input_vm.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/polls_and_voting/data/model/payout_review_model.dart';
import 'package:wayagram/features/polls_and_voting/views/payout_verification.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/ugt_history_card.dart';
import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';
import 'package:wayagram/features/ugt/vm/ugt_admin_dashboard_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';
import 'package:wayagram/features/wallet/transactions/view/payout_history.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

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
    final wayaTheme = Theme.of(context);
    final dashboardVm = ref.watch(ugtAdminDashboardVm);
    final notifier = ref.read(ugtAdminDashboardVm.notifier);
    //final viewModel = ref.watch(votersContestNotifier);
    var model = ref.watch(selectedContestProvider);
    //? for commission
    final viewModel = ref.watch(createPollVotingProvider);
    final percentage = (double.parse('${viewModel.commission}') / 100) *
        num.parse(dashboardVm.revenueGenerated?.toString() ?? "0");
    useEffect(() {
      notifier.fetchUserTransaction(model?.id ?? "");
      ref.read(createPollVotingProvider.notifier).getPayoutCommission();

      return null;
    }, []);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Transaction History",
      backgroundColor: Colors.white,
      floatingActionButton: DateTime.now().isAfter(DateTime.parse(
                  model?.endDate ?? "2096-01-01T00:00:00.000Z")) &&
              dashboardVm.revenueGenerated != 0
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Gap(40),
                if (ConversationState.self.accountType ==
                    UserAccountType.business)
                  SizedBox(
                    width: context.width / 2.8,
                    child: WayaButton(
                        horizontalPadding: 10,
                        fontSize: 14.sp,
                        height: 45.h,
                        text: "Request Payout",
                        callback: () async {
                          final percentage =
                              (double.parse('${viewModel.commission}') / 100) *
                                  num.parse(dashboardVm.revenueGenerated
                                          ?.toString() ??
                                      "0");
                          final amountDue = double.parse(
                                  dashboardVm.revenueGenerated?.toString() ??
                                      '0') -
                              double.parse(percentage.toString());

                          ref
                              .read(credentialInputProvider.notifier)
                              .onSubmitPayoutPin(() => WayaNav.toNamed(
                                      '/payoutVerification',
                                      arguments: {
                                        "id": model?.id ?? "",
                                        "Module": PayoutModule.contest,
                                        "Model": PayoutReviewModel(
                                            comission: percentage.toString(),
                                            amountDue:
                                                amountDue.toString(),
                                            amount: dashboardVm.revenueGenerated
                                                    ?.toString() ??
                                                '0',
                                            endDate: model?.endDate ?? "")
                                      }));
                        }),
                  ),
                Gap(10),
                GestureDetector(
                  onTap: () {
                    // "ECOMMERCE" "CONTEST" "DONATION" "POLL & VOTE" "QUOTATION" "EVENT" "COMMISSION",
                    WayaNav.toNamed(PayoutHistory.route, arguments: {
                      "referenceId": model?.id ?? "",
                      "Module": 'CONTEST'
                    });
                  },
                  child: Container(
                    //  margin: EdgeInsets.only(right: 20.w),
                    width: 130.w,
                    height: 45.h,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /*   WayaAssets.icons.export.svg(
                          width: 18,
                          height: 18,
                          fit: BoxFit.scaleDown,
                          color: wayaTheme.colorScheme.primary600,
                        ),
                        Gap(8), */
                        Text(
                          'Payout History',
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
            )
          : Container(),
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
                    "₦${formatMoney(percentage.toString())}",
                    Icon(
                      Icons.map_outlined,
                      color: Colors.white,
                    )),
              ],
            ),

            SizedBox(height: 20),

            if (dashboardVm.contestTransactionHistoryList.isEmpty)
              emptyWidget(),

            if (dashboardVm.contestTransactionHistoryList.isNotEmpty)
              ListView.builder(
                // controller: _scrollController,
                shrinkWrap: true,
                itemCount: dashboardVm.contestTransactionHistoryList.length,
                itemBuilder: (context, index) {
                  final post = dashboardVm.contestTransactionHistoryList[index];
                  return GestureDetector(
                    onTap: () {},
                    child: UgtHistoryCard(
                      model: post,
                      position: index + 1,
                      isPayout: false,
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

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/referral/vm/referral_vm.dart';
import 'package:wayagram/features/referral/widget/referral_card.dart';
import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';

class ReferralHistoryPage extends ConsumerStatefulWidget {
  static const route = '/referral-history-page';
  const ReferralHistoryPage({super.key});

  @override
  ConsumerState<ReferralHistoryPage> createState() =>
      _ReferralHistoryPageState();
}

class _ReferralHistoryPageState extends ConsumerState<ReferralHistoryPage> {
  final ScrollController _scrollController = ScrollController();
  double _previousScrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_scrollListener);
      ref.watch(referralVm.notifier).getAllUserReferrals(true);
    });
  }

  void _scrollListener() {
    double currentOffset = _scrollController.position.pixels;

    // ✅ Fetch data only when scrolling **downward** and near the bottom
    if (currentOffset > _previousScrollOffset &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100) {
      ref.watch(referralVm.notifier).getAllUserReferrals(false);
    }
    _previousScrollOffset = currentOffset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener); // Remove listener safely
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(referralVm);

    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Referral History",
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Referral History"),
        leading: WayaBackButton(
            //onTap: onTapBackButton,
            ),
      ),
      body: SizedBox(
        height: context.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Stats Section
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _infoCard("Total Friends Referred",
                        viewModel.count?.toString() ?? ""),
                    _infoCard("Total Rewards Earned",
                        "₦${formatMoney(viewModel.earned?.toString() ?? "")}"),
                  ],
                ),
              ),
            ),

            Gap(20),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Referral List",
                textAlign: TextAlign.start,
                style: WayaTextStyles.hintStyleBold,
              ),
            ),
            Gap(20),

            if (viewModel.referralList.isEmpty) emptyWidget(),
            Expanded(
              // height: context.height - 200,
              child: ListView.builder(
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: viewModel.referralList.length,
                itemBuilder: (context, index) {
                  final user = viewModel.referralList[index];
                  return ReferralCard(model: user);
                },
              ),
            ),
            Gap(100)
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: WayaTextStyles.hintStyleBold,
        ),
        Gap(4),
        Text(
          value,
          style: WayaTextStyles.headlineLarge,
        ),
      ],
    );
  }

  Widget emptyWidget() {
    return UgtEmptyState(
        icon: Image.asset("assets/images/u-emptystate.png"),
        desc: "No user referred yet",
        title: "Referrals",
        buttonText: "",
        hideButton: false,
        onTap: () {});
  }
}

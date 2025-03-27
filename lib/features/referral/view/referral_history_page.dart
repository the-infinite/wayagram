import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/referral/widget/referral_card.dart';

class ReferralHistoryPage extends StatefulWidget {
  static const route = '/referral-history-page';
  const ReferralHistoryPage({super.key});

  @override
  State<ReferralHistoryPage> createState() => _ReferralHistoryPageState();
}

class _ReferralHistoryPageState extends State<ReferralHistoryPage> {
  final ScrollController _scrollController = ScrollController();
  double _previousScrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_scrollListener);
    });
  }

  void _scrollListener() {
    double currentOffset = _scrollController.position.pixels;

    // ✅ Fetch data only when scrolling **downward** and near the bottom
    if (currentOffset > _previousScrollOffset &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100) {
      // print("fetching .....${_scrollController.position.pixels}");
      // ref.read(roleAccessVm.notifier).getAllMembers(false);
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
      body: SingleChildScrollView(
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
                    _infoCard("Total Friends Referred", "20"),
                    _infoCard("Total Rewards Earned", "₦4,500"),
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
            ReferralCard(),
            /*   Expanded(
              // height: context.height - 200,
              child: ListView.builder(
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: viewModel.listMember.length,
                itemBuilder: (context, index) {
                  final user = viewModel.listMember[index];
                  return GestureDetector(
                      onTap: () {
                        ref.read(selectedRoleMemberProvider.notifier).state =
                            user;
                        WayaNav.toNamed(MemberDetailsPage.route);
                      },
                      child: RoleAccessCard(user: user));
                },
              ),
            ), */
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

  Widget _actionButton(BuildContext context, IconData icon, String label) {
    final wayaTheme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.primary50,
        borderRadius: BorderRadius.circular(4), // Rounded corners
      ),
      width: context.width / 3.5,
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: wayaTheme.colorScheme.primary500),
          Gap(4),
          Text(label,
              style: WayaTextStyles.bodyMedium
                  .copyWith(color: wayaTheme.colorScheme.primary500)),
        ],
      ),
    );
  }
}

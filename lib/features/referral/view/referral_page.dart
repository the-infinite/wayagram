import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/helpers/value.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_routes.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/event/bottom_sheets/share/share_provider.dart';
import 'package:wayagram/features/referral/view/referral_history_page.dart';
import 'package:wayagram/features/referral/vm/referral_vm.dart';
import 'package:wayagram/features/referral/widget/how_it_works.dart';
import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';

class ReferralPage extends ConsumerWidget {
  static const route = '/referral-page';
  const ReferralPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(referralVm);
    //final notifier = ref.watch(referralVm.notifier);
    final shareService = ref.watch(shareProvider);
    final wayaTheme = Theme.of(context);
    String url =
        WayaAppRoutes.getProfileRoute(ConversationState.profile.userId ?? "");
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Referral Program",
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Referral Program"),
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
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _infoCard("Total Friends Referred", viewModel.referralList.length.toString()),
                    _infoCard("Total Rewards Earned", "₦${formatMoney(viewModel.earned?.toString() ?? "")}"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            //?referral image
            WayaAssets.images.referralImage.image(),

            SizedBox(height: 16),

            // Title and Description
            Text(
              "Earn Rewards by Inviting Friends!",
              style: WayaTextStyles.headlineLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              "Share your link and earn rewards when your friends sign up and make their first transaction",
              textAlign: TextAlign.center,
              style: WayaTextStyles.hintStyleBold,
            ),

            SizedBox(height: 16),

            // Referral Link TextField
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Referral Code:  ${ConversationState.profile.referenceCode}",
                        overflow: TextOverflow.ellipsis,
                        style: WayaTextStyles.bodyMedium,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          shareService.copyLink(ConversationState.profile.referenceCode ?? "");
                          WayaSnackBar.showToast("Copied");
                        },
                        child: Icon(Icons.copy, color: wayaTheme.primaryColor)),
                  ],
                ),
              ),
            ),

            Gap(16),
            Text(
              "Invitation Link",
              textAlign: TextAlign.start,
              style: WayaTextStyles.hintStyleBold,
            ),
            Gap(16),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () async {
                      await Share.share(
                        WayaValueHelper.getShareableUrl(url),
                        //  ConversationState.profile.referenceCode ?? "",
                        subject: 'Share link',
                      );
                    },
                    child: _actionButton(context, Icons.share_outlined, "Share")),
                GestureDetector(
                    onTap: () {
                      shareService
                          .copyLink(WayaValueHelper.getShareableUrl(url));
                      WayaSnackBar.showToast("Copied");
                    },
                    child: _actionButton(context, Icons.copy, "Copy Link")),
                GestureDetector(
                    onTap: () {
                      WayaUtils.showModalSheetUgt(context, child: HowItWorks());
                    },
                    child: _actionButton(context, Icons.info, "Learn More")),
              ],
            ),

            Gap(20),

            // View Referral History Button
            WayaButton(
              callback: () {
                WayaNav.toNamed(ReferralHistoryPage.route);
              },
              text: "View Referral History",
            ),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: wayaTheme.colorScheme.primary500),
          Gap(4),
          Text(label, style: WayaTextStyles.bodyMedium.copyWith(color: wayaTheme.colorScheme.primary500)),
        ],
      ),
    );
  }
}

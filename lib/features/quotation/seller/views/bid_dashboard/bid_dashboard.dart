import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/quotation/seller/views/bid_dashboard/widgets/inventory_widget.dart';
import 'package:wayagram/features/quotation/seller/views/bids/all_seller_bids.dart';
import 'package:wayagram/features/quotation/seller/views/orders.dart';
import 'package:wayagram/features/quotation/widgets/single_bid_widget.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/widgets/quick_action_widget.dart';
import 'package:wayagram/features/shop/shop_dispute/views/seller_dispute.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';
import 'package:wayagram/shared/features/shop/resource/default.dart';

class BidDashboard extends ConsumerStatefulWidget {
  const BidDashboard({super.key});

  @override
  ConsumerState<BidDashboard> createState() => _BidDashboardState();
}

class _BidDashboardState extends ConsumerState<BidDashboard> {
  late final notifier = ref.read(userQuotationsProvider.notifier);
  final handler = WayaObservableScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.getBidsOverview(ShopResource.currentShop.id);
      notifier.getBids(ShopResource.currentShop.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(userQuotationsProvider);

    //? This is fine.
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //? Page title.
        Text(
          "Bid Dashboard",
          style: wayaTheme.textTheme.titleLarge,
        ),

        // Some space.
        const Gap(3),

        //? Page subtitle.
        Text(
          'Manage your bids and track settlements',
          style: wayaTheme.textTheme.hintStyle,
        ),

        // Some space.
        const Gap(15),

        //? Now, our grid for these things.
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 0,
          childAspectRatio: 1.2,
          crossAxisSpacing: 8,
          children: [
            //? First, the total number of settlements.
            InventoryWidget(
              title: "Total Settlement",
              metrics: WayaValueHelper.formatNumber(0, true),
              color: Color(0xFFFEF6E7),
            ),

            //? Second, the won  bids.
            InventoryWidget(
              title: "Won Bids",
              metrics: state.overview?.won.toString() ?? "0",
              color: Color(0xFFE7F6EC),
            ),

            //? Third, the opened bids.
            InventoryWidget(
              title: "Opened Bids",
              metrics: state.overview?.opened.toString() ?? "0",
              color: Color(0xFFE3EFFC),
            )
          ],
        ),

        // Some space.
        const Gap(15),

        //? Quick actions
        Text(
          "Quick Action",
          style: wayaTheme.textTheme.bodyMedium?.copyWith(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: wayaTheme.colorScheme.customBlack,
          ),
        ),

        // Some space.
        const Gap(15),

        //? Our section for all quick action widgets.
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.scaffoldColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //? Button to go to the seller bids.
                QuickActionWidget(
                  title: "Bids",
                  icon: WayaAssets.icons.bid.svg(
                    width: 28,
                    height: 28,
                  ),
                  color: Color(0xffE7F6EC),
                  onTap: () => WayaNav.toNamed(AllSellerBids.route),
                  metric: state.totalBids,
                  isStacked: true,
                ),

                // Some space.
                const Gap(5),

                //? Button to go to all orders.
                QuickActionWidget(
                  title: "Orders",
                  metric: state.totalOrders,
                  isStacked: true,
                  icon: WayaAssets.icons.orders.svg(
                    width: 28,
                    height: 28,
                  ),
                  color: Color(0xffFFF0EB),
                  onTap: () => WayaNav.toNamed(QuotationSellerOrders.route),
                ),

                // Some space.
                const Gap(5),

                //? Button to go to sales disputes.
                QuickActionWidget(
                  title: "Disputes",
                  icon: WayaAssets.icons.dispute.svg(
                    width: 28,
                    height: 28,
                  ),
                  color: Color(0xffE3EFFC),
                  onTap: () => WayaNav.toNamed(SellerDispute.route),
                ),

                // Some space.
                const Gap(5),

                //? Button to go to all settlements.
                QuickActionWidget(
                  title: "Settlements",
                  icon: WayaAssets.icons.settlement.svg(
                    width: 28,
                    height: 28,
                    colorFilter:
                        ColorFilter.mode(Color(0xffD42620), BlendMode.srcIn),
                  ),
                  color: Color(0xffFBEAE9),
                  onTap: () {
                    //? Show the coming soon modal.
                    if (WayaConstants.isProduction) {
                      WayaNavigationHelper.showComingSoonModal(true);
                      return;
                    }

                    //? Now, continue as needed in staging.
                    WayaNav.toNamed('/seller-settlement');
                  },
                ),
              ],
            ),
          ),
        ),

        // Some space.
        const Gap(15),

        Text(
          "Recent Bids",
          style: wayaTheme.textTheme.bodyMedium?.copyWith(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: wayaTheme.colorScheme.customBlack,
          ),
        ),

        // Some space.
        const Gap(15),

        //? The list of recent bids.
        if (state.hasLoadedBids && state.bids.isEmpty) ...[
          //? First, space that scales with the screen size.
          Gap(30.h),

          //? Second the actual component itself.
          Center(
            child: EmptyState(
              assetImage: WayaAssets.icons.emptyState.svg(),
              message: "Nothing to show yet",
            ),
          ),

          //? Finally, space that scales with the screen size.
          Gap(30.h),
        ] else
          ...List.generate(
            min(20, state.bids.length),
            (index) => SingleBidWidget(
              isSeller: true,
              bid: state.bids[index],
            ),
          ),
      ],
    );
  }
}

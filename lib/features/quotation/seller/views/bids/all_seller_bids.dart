import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/quotation/seller/views/bid_dashboard/widgets/inventory_widget.dart';
import 'package:wayagram/features/quotation/widgets/single_bid_widget.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';
import 'package:wayagram/shared/features/shop/resource/default.dart';

class AllSellerBids extends ConsumerStatefulWidget {
  static const route = '/seller-bids';
  const AllSellerBids({super.key});

  @override
  ConsumerState<AllSellerBids> createState() => _AllSellerBidsState();
}

class _AllSellerBidsState extends ConsumerState<AllSellerBids> {
  late final notifier = ref.read(userQuotationsProvider.notifier);
  final handler = WayaObservableScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.getBidsOverview(ShopResource.currentShop.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(userQuotationsProvider);

    //? This is fine.
    return WayaScaffold(
      isLoading: false,
      isScrollable: false,
      title: 'Bids',
      body: WayaObservableScrollView(
        handler: handler,
        shouldFetch: !state.isLoadingBids,
        isAtEnd: !state.hasNextBid,
        onReachEnd: () async => await notifier.getBids(ShopResource.currentShop.id),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bids",
              style: wayaTheme.textTheme.titleLarge,
            ),

            // Some space.
            const Gap(3),

            //? This is okay.
            Text(
              'View and Manage your bids',
              style: wayaTheme.textTheme.hintStyle,
            ),

            // Some space.
            const Gap(20),

            //? Filter
            FilterWidget(
              search: TextEditingController(),
              hintText: 'Search Bids',
            ),

            // Some space
            const Gap(15),

            //? Where we keep the inventory widget.
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 0,
              childAspectRatio: 1.22,
              crossAxisSpacing: 8,
              children: [
                //? First, the open bids.
                InventoryWidget(
                  title: "Open Bids",
                  metrics: state.overview?.opened.toString() ?? "0",
                  color: Color(0xFFFEF6E7),
                ),

                //? Second, the won  bids.
                InventoryWidget(
                  title: "Won Bids",
                  metrics: state.overview?.won.toString() ?? "0",
                  color: Color(0xFFE7F6EC),
                ),

                //? Third, the closed bids.
                InventoryWidget(
                  title: "Closed Bids",
                  metrics: state.overview?.closed.toString() ?? "0",
                  color: Color(0xFFE3EFFC),
                )
              ],
            ),

            // Some space.
            const Gap(10),

            //? The recent bids section.
            Text(
              "Recent Bids",
              style: wayaTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: wayaTheme.colorScheme.customBlack,
              ),
            ),

            // Some space.
            const Gap(10),

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
                state.bids.length,
                (index) => SingleBidWidget(
                  isSeller: true,
                  bid: state.bids[index],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

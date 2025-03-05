import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/quotation/seller/views/bid_dashboard/widgets/inventory_widget.dart';
import 'package:wayagram/features/quotation/vm/seller_bids_vm.dart';
import 'package:wayagram/features/quotation/widgets/single_bid_widget.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';

class AllSellerBids extends ConsumerStatefulWidget {
  static const route = '/seller-bids';
  const AllSellerBids({super.key});

  @override
  ConsumerState<AllSellerBids> createState() => _AllSellerBidsState();
}

class _AllSellerBidsState extends ConsumerState<AllSellerBids> {
  late final notifier = ref.read(userQuotationsProvider.notifier);
  late final shopsNotifier = ref.read(manageShopVmProvider.notifier);
  final handler = WayaObservableScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //? First, get all shops belonging to this individual.
      await shopsNotifier.getSellerShops();

      //? Now, read and update the current shop to this first shop.
      final shop = ref.read(manageShopVmProvider);
      shopsNotifier.getCurrentShop(shop.shop.first);

      //? Get the bid overview with that shop.
      await notifier.getBidsOverview(shop.shop.first.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(sellerBidsVmProvider);
    final state = ref.watch(userQuotationsProvider);
    final shopState = ref.watch(manageShopVmProvider);

    //? This is fine.
    return WayaScaffold(
      isLoading: false,
      isScrollable: false,
      title: 'Bids',
      appBarTrailing: bidIcon(context),
      body: WayaObservableScrollView(
        handler: handler,
        shouldFetch: !state.isLoadingBids,
        isAtEnd: !state.hasNextBid,
        onReachEnd: () async => await notifier.getBids(shopState.singleShop!.id),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bids", style: wayaTheme.textTheme.titleLarge),

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
            GridView.builder(
              itemCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: viewModel.orderMetrics.length,
                mainAxisSpacing: 0,
                childAspectRatio: 1.22,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return InventoryWidget(
                  metrics: viewModel.orderMetrics[index]["metrics"],
                  color: viewModel.orderMetrics[index]['color'],
                  title: viewModel.orderMetrics[index]['title'],
                );
              },
            ),

            // Some space.
            const Gap(10),

            //? The recent bids section.
            Text(
              "Recent Bids",
              style: wayaTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
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

  Widget bidIcon(ctx) {
    final wayaTheme = Theme.of(ctx);
    return GestureDetector(
      onTap: () {
        WayaNav.toNamed("/map");
      },
      child: Row(
        children: [
          Container(
            height: 35,
            padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
            decoration:
                BoxDecoration(color: wayaTheme.colorScheme.customPrimary, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/bid.svg',
                    color: wayaTheme.colorScheme.white,
                    height: 20,
                  ),

                  // Some space.
                  const Gap(5),

                  //? This is fine.
                  Text(
                    "See Bids",
                    style: TextStyle()
                        .wayaCopyWith(color: wayaTheme.colorScheme.white, fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // Some space.
          const Gap(15)
        ],
      ),
    );
  }
}

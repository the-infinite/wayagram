import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/quotation/widgets/order_widget.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';
import 'package:wayagram/shared/features/shop/resource/default.dart';

class QuotationSellerOrders extends ConsumerStatefulWidget {
  static const route = '/quotation/seller/orders';

  const QuotationSellerOrders({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AllSellerOrdersState();
}

class _AllSellerOrdersState extends ConsumerState<QuotationSellerOrders> {
  late final notifier = ref.read(userQuotationsProvider.notifier);
  final handler = WayaObservableScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.getOrders(ShopResource.currentShop.id);
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
      title: 'Orders',
      body: WayaObservableScrollView(
        handler: handler,
        shouldFetch: !state.isLoadingBids,
        isAtEnd: !state.hasNextBid,
        onReachEnd: () async =>
            await notifier.getOrders(ShopResource.currentShop.id),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Orders",
              style: wayaTheme.textTheme.titleLarge,
            ),

            // Some space.
            const Gap(3),

            //? This is okay.
            Text(
              'View and Manage your orders',
              style: wayaTheme.textTheme.hintStyle,
            ),

            // Some space.
            const Gap(20),

            //? Filter
            FilterWidget(
              search: TextEditingController(),
              hintText: 'Search Orders',
            ),

            // Some space
            const Gap(15),

            //? The list of recent bids.
            if (state.hasLoadedOrders && state.orders.isEmpty) ...[
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
                state.orders.length,
                (index) => QuotationOrderWidget(
                  isSeller: true,
                  order: state.orders[index],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/seller/data/model/manage_shop_state.dart';
import 'package:wayagram/features/shop/seller/data/model/shop_response_model.dart';
import 'package:wayagram/features/shop/seller/views/delivery_request/delivery_request.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/widgets/inventory_widget.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/widgets/quick_action_widget.dart';
import 'package:wayagram/features/shop/seller/views/orders/all_seller_orders.dart';
import 'package:wayagram/features/shop/seller/views/seller_dispute/views/seller_dispute.dart';
import 'package:wayagram/features/shop/seller/views/seller_products.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/waya_deal_ad.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/waya_gram_deals.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';
import 'package:wayagram/features/shop/order/widgets/single_order_widget.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

class ManageShop extends ConsumerStatefulWidget {
  static const route = '/manage-shop';
  const ManageShop({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManageShopState();
}

class _ManageShopState extends ConsumerState<ManageShop> {
  int totalOrders = 0;
  List<SalesMetric> sales = salesMetrics;

  int totalWayaDealProducts = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final shop = ModalRoute.of(context)!.settings.arguments as ShopData;
      ref.read(manageShopVmProvider.notifier).getCurrentShop(shop);
      ref.read(manageShopVmProvider.notifier).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(manageShopVmProvider);
    final shopState = ref.watch(shopVmProvider);

    if (shopState.sellerMetrics != null && !viewModel.isLoadingOrder) {
      // order
      totalOrders = shopState.sellerMetrics!.totalOrders.cancelled.count +
          shopState.sellerMetrics!.totalOrders.completed.count +
          shopState.sellerMetrics!.totalOrders.pending.count +
          shopState.sellerMetrics!.totalOrders.processing.count;
/**

 */
      // waya deals
      totalWayaDealProducts =
          shopState.sellerMetrics!.productMetrics.approvedProducts +
              shopState.sellerMetrics!.productMetrics.unapprovedProducts;

      int totalProducts = // products
          shopState.sellerMetrics!.productMetrics.totalProducts;

      int numberOfPendingOrders = // products
          shopState.sellerMetrics!.totalOrders.pending.count;

      int totalSales = // products
          shopState.sellerMetrics!.completedSales.both.totalAmount +
              shopState.sellerMetrics!.completedSales.delivered.totalAmount +
              shopState.sellerMetrics!.completedSales.pickup.totalAmount;

      sales = sales.map((value) {
        if (value.title == "Pending Orders") {
          return value.copyWith(metrics: "$numberOfPendingOrders");
        } else if (value.title == 'Total Sales') {
          return value.copyWith(metrics: WayaHelpers.formatPrice(totalSales));
        } else if (value.title == "Total Products") {
          return value.copyWith(metrics: "$totalProducts");
        }
        return value;
      }).toList();
    }

    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        title: viewModel.singleShop!.name.capitalizeFirst ?? '',
        isLoading: viewModel.isLoadingOrder,
        isScrollable: true,
        onRefresh: () async {
          ref.read(manageShopVmProvider.notifier).fetchData();
        },
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(viewModel.singleShop!.name.capitalizeFirst!,
                        style: wayaTheme.textTheme.titleLarge),
                    const Gap(3),
                    Text(
                      'Manage your shop activity',
                      style: wayaTheme.textTheme.hintStyle,
                    ),
                  ],
                ),
                // WayaButton(
                //   callback: () {},
                //   text: 'Shop Settings',
                //   textStyle: TextStyle().wayaCopyWith(
                //       color: wayaTheme.colorScheme.white,
                //       fontSize: 13,
                //       fontWeight: FontWeight.w500),
                //   height: 35,
                //   radius: 6,
                // )
              ],
            ),
            const Gap(30),
            WayaButton(
              callback: () {
                WayaNav.toNamed(
                  SellerProducts.route,
                  arguments: viewModel.singleShop!.id,
                );
              },
              color: wayaTheme.colorScheme.primary50,
              centerWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    WayaAssets.icons.buttonIcon.path,
                    colorFilter: ColorFilter.mode(
                        wayaTheme.colorScheme.customPrimary, BlendMode.srcIn),
                  ),
                  const Gap(6),
                  Text(
                    "View My Products",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.customPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            const Gap(15),
            GridView.builder(
                itemCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: sales.length,
                    mainAxisSpacing: 0,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 8),
                itemBuilder: (context, index) {
                  return InventoryWidget(
                      metrics: sales[index].metrics,
                      color: sales[index].color!,
                      title: sales[index].title);
                }),
            const Gap(15),
            Text("Quick Action",
                style: TextStyle().wayaCopyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: wayaTheme.colorScheme.customBlack)),
            const Gap(15),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: wayaTheme.colorScheme.scaffoldColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 0,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 8),
                children: [
                  QuickActionWidget(
                    title: "Orders",
                    icon: SvgPicture.asset(WayaAssets.icons.orders.path),
                    color: Color(0xffE7F6EC),
                    onTap: () {
                      WayaNav.toNamed(AllSellerOrders.route,
                          arguments: viewModel.singleShop!.id);
                    },
                    metric: totalOrders,
                    isStacked: true,
                  ),
                  QuickActionWidget(
                    title: "Wayagram Deals",
                    icon: SvgPicture.asset(WayaAssets.icons.dealIcon.path),
                    color: Color(0xffFFF0EB),
                    metric: totalWayaDealProducts,
                    isStacked: true,
                    onTap: () {
                      if (totalWayaDealProducts > 0) {
                        WayaNav.toNamed(WayaGramDeals.route);
                      } else {
                        WayaNav.toNamed(WayaDealAd.route);
                      }
                    },
                  ),
                  QuickActionWidget(
                    title: "Disputes",
                    icon: SvgPicture.asset(
                      WayaAssets.icons.buttonIcon.path,
                      width: 28,
                      height: 28,
                      colorFilter:
                          ColorFilter.mode(Color(0xffD42620), BlendMode.srcIn),
                    ),
                    color: Color(0xffFBEAE9),
                    onTap: () {
                      WayaNav.toNamed(SellerDispute.route);
                    },
                  ),
                  QuickActionWidget(
                    title: "Requests",
                    icon: SvgPicture.asset(WayaAssets.icons.requestIcon.path),
                    color: Color(0xffFBEAE9),
                    onTap: () {
                      WayaNav.toNamed(DeliveryRequest.route);
                    },
                    metric: viewModel.numberOfRequests,
                    isStacked: true,
                  ),
                ],
              ),
            ),
            const Gap(15),
            Text("Recent Orders",
                style: TextStyle().wayaCopyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: wayaTheme.colorScheme.customBlack)),
            const Gap(15),
            viewModel.orders.isEmpty
                ? Center(
                    child: EmptyState(
                        assetImage: WayaAssets.images.wallet.searchDocu
                            .image(scale: 1.5),
                        message: 'No Recent Order'),
                  )
                : ListView.builder(
                    itemCount: viewModel.orders.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return SingleOrderWidget(
                        isSeller: true,
                        order: viewModel.orders[index],
                      );
                    })
          ],
        ));
  }
}

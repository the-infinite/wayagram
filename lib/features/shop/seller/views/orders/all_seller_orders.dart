import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/seller/data/model/manage_shop_state.dart';
import 'package:wayagram/features/shop/views/favorites_product.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:wayagram/features/shop/order/widgets/single_order_widget.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/widgets/inventory_widget.dart';
import 'package:wayagram/features/shop/seller/vm/seller_orders_vm.dart';
import 'package:wayagram/features/shop/widgets/card_loading_state.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';
import 'package:flutter_screenutil/src/size_extension.dart';

class AllSellerOrders extends ConsumerStatefulWidget {
  static const route = '/seller-orders';
  const AllSellerOrders({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllSellerOrderState();
}

class _AllSellerOrderState extends ConsumerState<AllSellerOrders> {
  late TextEditingController searchController;
  List<SalesMetric> orders = orderMetrics;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final String shopId =
          ModalRoute.of(context)!.settings.arguments as String;
      ref.read(sellerOrdersVmProvider.notifier).getShopId(shopId);
    });
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final shopState = ref.watch(shopVmProvider);

    if (shopState.sellerMetrics != null) {
      int numberOfPendingOrders = // products
          shopState.sellerMetrics!.totalOrders.pending.count;

      int numberOfCancelledOrders = // products
          shopState.sellerMetrics!.totalOrders.cancelled.count;

      int numberOfCompletedOrders = // products
          shopState.sellerMetrics!.totalOrders.completed.count;

      //  int numberOfProcessingOrders = // products
      // shopState.sellerMetrics!.totalOrders.processing.count;

      orders = orders.map((metric) {
        if (metric.title == "Pending Orders") {
          return metric.copyWith(metrics: "$numberOfPendingOrders");
        } else if (metric.title == "Delivered Orders") {
          return metric.copyWith(metrics: "$numberOfCompletedOrders");
        } else if (metric.title == "Cancelled Orders") {
          return metric.copyWith(metrics: "$numberOfCancelledOrders");
        }

        return metric;
      }).toList();
    }

    final List<String> tabs = [
      "Pending Orders",
      "Completed Orders",
      "Cancelled Orders",
    ];

    return WayaScaffold(
        isLoading: false,
        isScrollable: false,
        title: 'Orders',
        appBarTrailing: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 3,
            children: [
              InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  WayaNav.toNamed(FavoritesProducts.route);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: wayaTheme.colorScheme.customPrimary,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(6),
                  child: SvgPicture.asset(
                    WayaAssets.icons.mSmallHeart.path,
                    fit: BoxFit.cover,
                    width: 18,
                    height: 18,
                    color: wayaTheme.colorScheme.white,
                  ),
                ),
              ),
              WayaCartIcon(),
            ]),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Orders", style: wayaTheme.textTheme.titleLarge),
            const Gap(3),
            Text(
              'View and Manage your orders',
              style: wayaTheme.textTheme.hintStyle,
            ),
            const Gap(20),

            GridView.builder(
                itemCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: orders.length,
                    mainAxisSpacing: 0,
                    childAspectRatio: 1.22,
                    crossAxisSpacing: 8),
                itemBuilder: (context, index) {
                  return InventoryWidget(
                      metrics: orders[index].metrics,
                      color: orders[index].color!,
                      title: orders[index].title);
                }),
            const Gap(10),
            //? filter orders
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(tabs.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: _selectedIndex == index
                            ? wayaTheme.colorScheme.primary50
                            : Colors.white,
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(
                          color: _selectedIndex == index
                              ? Colors.transparent
                              : wayaTheme.colorScheme.secondaryColor,
                        ),
                      ),
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                            color: _selectedIndex == index
                                ? wayaTheme.colorScheme.customPrimary
                                : Colors.black,
                            fontWeight: _selectedIndex == index
                                ? FontWeight.bold
                                : FontWeight.bold,
                            fontSize: 12.sp),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const Gap(15),
            FilterWidget(
              hintText: 'Search Order by ID, shop name, token etc',
              search: searchController,
            ),

            const Gap(15),
            Expanded(
                child: KeyedSubtree(
                    key: ValueKey(_selectedIndex),
                    child: PaginatedDataView<Order>(
                        uniqueKey: _selectedIndex == 0
                            ? 'seller-pending-orders'
                            : _selectedIndex == 1
                                ? 'seller-completed-orders'
                                : 'seller-cancelled-orders',
                        // trailingWidget:
                        //     _buildTrailing(context: context, orders: orders),
                        emptyState: EmptyState(
                            assetImage: WayaAssets.images.wallet.searchDocu
                                .image(scale: 1.5),
                            message: "No Order Yet"),
                        loadingState: CardLoadingState(
                          count: 6,
                        ),
                        fetchData: _selectedIndex == 0
                            ? ref
                                .read(sellerOrdersVmProvider.notifier)
                                .getPendingOrders
                            : _selectedIndex == 1
                                ? ref
                                    .read(sellerOrdersVmProvider.notifier)
                                    .getCompletedOrders
                                : ref
                                    .read(sellerOrdersVmProvider.notifier)
                                    .getCancelledOrders,
                        result: (data, s) {
                          final filteredOrder = WayaUtils.search<Order>(
                              data,
                              [
                                'id',
                                'pickupAddress',
                                'deliveryAddress',
                                'shopName',
                                'deliveryToken',
                                'deliveryType'
                              ],
                              searchController.text);
                          return ListView.builder(
                              itemCount: filteredOrder.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return SingleOrderWidget(
                                  isSeller: true,
                                  order: filteredOrder[index],
                                );
                              });
                        })))
          ],
        ));
  }
}

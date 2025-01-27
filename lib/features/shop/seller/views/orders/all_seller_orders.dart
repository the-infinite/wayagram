import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shared/paginated_data/paginated_data_view.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:wayagram/features/shop/order/widgets/single_order_widget.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/widgets/inventory_widget.dart';
import 'package:wayagram/features/shop/seller/vm/seller_orders_vm.dart';
import 'package:wayagram/features/shop/widgets/card_loading_state.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';

class AllSellerOrders extends ConsumerStatefulWidget {
  static const route = '/seller-orders';
  const AllSellerOrders({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllSellerOrderState();
}

class _AllSellerOrderState extends ConsumerState<AllSellerOrders> {
  late TextEditingController searchController;

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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(sellerOrdersVmProvider);
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: 'Orders',
        appBarTrailing: WayaCartIcon(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Orders", style: wayaTheme.textTheme.titleLarge),
            const Gap(3),
            Text(
              'View and Manage your orders',
              style: wayaTheme.textTheme.hintStyle,
            ),
            const Gap(20),
            FilterWidget(
              hintText: 'Search Order',
              search: searchController,
            ),
            const Gap(15),
            GridView.builder(
                itemCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: viewModel.salesMetric.length,
                    mainAxisSpacing: 0,
                    childAspectRatio: 1.22,
                    crossAxisSpacing: 8),
                itemBuilder: (context, index) {
                  return InventoryWidget(
                      metrics: viewModel.salesMetric[index].metrics,
                      color: viewModel.salesMetric[index].color!,
                      title: viewModel.salesMetric[index].title);
                }),
            // const Gap(6),
            // GridView.builder(
            //     itemCount: 2,
            //     physics: const NeverScrollableScrollPhysics(),
            //     shrinkWrap: true,
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: viewModel.otherMetrics.length,
            //         mainAxisSpacing: 0,
            //         childAspectRatio: 1.8,
            //         crossAxisSpacing: 8),
            //     itemBuilder: (context, index) {
            //       return InventoryWidget(
            //           metrics: viewModel.otherMetrics[index]["metrics"],
            //           color: viewModel.otherMetrics[index]['color'],
            //           title: viewModel.otherMetrics[index]['title']);
            //     }),
            const Gap(20),
            PaginatedDataView<Order>(
                uniqueKey: 'seller-orders',
                emptyState: EmptyState(
                    assetImage:
                        WayaAssets.images.wallet.searchDocu.image(scale: 1.5),
                    message: "No Order Yet"),
                loadingState: CardLoadingState(
                  count: 6,
                ),
                fetchData: ref.read(sellerOrdersVmProvider.notifier).getOrders,
                result: (data) {
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
                })
          ],
        ));
  }
}

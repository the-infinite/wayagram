import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/shop/data/model/model.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/widgets/inventory_widget.dart';
import 'package:wayagram/features/shop/seller/vm/seller_orders_vm.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/features/shop/widgets/single_order_widget.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';

class AllSellerOrders extends ConsumerWidget {
  static const route = '/seller-orders';
  const AllSellerOrders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            FilterWidget<Product>(allItems: []),
            const Gap(15),
            GridView.builder(
                itemCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: viewModel.orderMetrics.length,
                    mainAxisSpacing: 0,
                    childAspectRatio: 1.22,
                    crossAxisSpacing: 8),
                itemBuilder: (context, index) {
                  return InventoryWidget(
                      metrics: viewModel.orderMetrics[index]["metrics"],
                      color: viewModel.orderMetrics[index]['color'],
                      title: viewModel.orderMetrics[index]['title']);
                }),
            const Gap(6),
            GridView.builder(
                itemCount: 2,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: viewModel.otherMetrics.length,
                    mainAxisSpacing: 0,
                    childAspectRatio: 1.8,
                    crossAxisSpacing: 8),
                itemBuilder: (context, index) {
                  return InventoryWidget(
                      metrics: viewModel.otherMetrics[index]["metrics"],
                      color: viewModel.otherMetrics[index]['color'],
                      title: viewModel.otherMetrics[index]['title']);
                }),
            const Gap(20),
            ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return SingleOrderWidget(
                    isSeller: true,
                  );
                })
          ],
        ));
  }
}

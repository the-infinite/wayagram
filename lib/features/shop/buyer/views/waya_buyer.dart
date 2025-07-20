import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/order/views/all_orders.dart';
import 'package:wayagram/features/shop/buyer/views/all_products.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';

class WayaBuyer extends ConsumerStatefulWidget {
  const WayaBuyer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WayaBuyerState();
}

class _WayaBuyerState extends ConsumerState<WayaBuyer>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: 'Shop',
        appBarTrailing: WayaCartIcon(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Row(
              children: [
                WayaTabButton(
                  isSelected: _selectedIndex == 0,
                  text: 'All Products',
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                WayaTabButton(
                  isSelected: _selectedIndex == 1,
                  text: 'Orders',
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
              ],
            ),

            const Gap(25),
            // AllProducts()
            _selectedIndex == 0 ? AllProducts() : AllOrders()
          ],
        ));
  }
}

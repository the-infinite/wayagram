import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/shop/buyer/views/all_products.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/manage_shop.dart';
import 'package:wayagram/features/shop/seller/views/seller_products.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';
import 'package:wayagram/features/shop/widgets/waya_shop_tab_button.dart';
import 'package:gap/gap.dart';

class WayaSeller extends ConsumerStatefulWidget {
  const WayaSeller({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WayaSellerState();
}

class _WayaSellerState extends ConsumerState<WayaSeller>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: 'Shop',
        appBarTrailing: WayaCartIcon(),
        body: Column(
          children: [
            const Gap(10),
            Row(
              children: [
                WayaShopTabButton(
                  isSelected: _selectedIndex == 0,
                  text: 'All Products',
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                WayaShopTabButton(
                  isSelected: _selectedIndex == 1,
                  text: 'My Products',
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
                WayaShopTabButton(
                  isSelected: _selectedIndex == 2,
                  text: 'Manage Shop',
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
              ],
            ),
            const Gap(10),
            if (_selectedIndex == 0) AllProducts(),
            if (_selectedIndex == 1) SellerProducts(),
            if (_selectedIndex == 2) ManageShop()
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/shop/order/views/all_orders.dart';
import 'package:wayagram/features/shop/buyer/views/all_products.dart';
import 'package:wayagram/features/shop/seller/data/model/create_shop_state.dart';
import 'package:wayagram/features/shop/seller/views/create_shop/create_shop.dart';
import 'package:wayagram/features/shop/seller/views/create_shop/vm/create_shop_vm.dart';
import 'package:wayagram/features/shop/seller/views/seller_shop/seller_shop.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';
import 'package:gap/gap.dart';

class WayaShop extends ConsumerStatefulWidget {
  const WayaShop({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WayaShopState();
}

class _WayaShopState extends ConsumerState<WayaShop>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);

    return WayaScaffold(
        isLoading: ref.watch(createShopVmProvider).isLoading,
        isScrollable: false,
        progressIndicator: loadingState(context: context),
        onTapBackButton: () =>
            Navigator.pushNamed(context, BottomView.route, arguments: 0),
        title: 'Shop',
        appBarTrailing: WayaCartIcon(),
        body: Column(
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
                WayaTabButton(
                  isSelected: _selectedIndex == 2,
                  text: 'Manage Shop',
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
              ],
            ),
            const Gap(10),
            if (_selectedIndex == 0) AllProducts(),
            if (_selectedIndex == 1) AllOrders(),
            if (_selectedIndex == 2) SellerShop()
          ],
        ),
        floatingActionButton: Visibility(
          visible: ref.read(successfulSetupVmProvider).user!.user!.role!.name !=
                  'PERSONAL' &&
              _selectedIndex == 2,
          child: SizedBox(
            height: 50,
            width: 50,
            child: WayaButton(
              callback: () {
                WayaNav.toNamed(CreateShop.route,
                    arguments: CreateShopArg(uniqueKey: 'create-shop'));
              },
              height: 50,
              centerWidget: Center(
                child: Icon(
                  Icons.add,
                  color: wayaTheme.colorScheme.white,
                  size: 40,
                ),
              ),
            ),
          ),
        ));
  }

  Widget loadingState({required BuildContext context}) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 10),
        Text(
          "Creating your shop",
          style: wayaTheme.textTheme.bodyMedium?.copyWith(
              color: wayaTheme.colorScheme.customPrimary,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

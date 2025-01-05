import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/buyer/views/all_products.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/manage_shop.dart';
import 'package:wayagram/features/shop/seller/views/seller_products.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';
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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(manageShopVmProvider.notifier).getUserShop();
      
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(manageShopVmProvider);
    return  WayaScaffold(
      removeAppBar: true,
      body: Center(
      child: !viewModel.hasShop ? SellerShopEmptyState() : WayaScaffold(
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
        ))
    ));
  }
}




class SellerShopEmptyState extends StatelessWidget {
  const SellerShopEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Gap(40),
        SvgPicture.asset('assets/icons/empty-state.svg'),
       // const Gap(30),
        Text(
          "No Shop Created",
          textAlign: TextAlign.center,
          style: wayaTheme.textTheme.titleLarge,
        ),
        const Gap(25),
        Text(
          "Start adding creating a shop.",
            
          textAlign: TextAlign.center,
          style: wayaTheme.textTheme.descriptionStyle,
        ),
        const Gap(25),
        SizedBox(
          width: 250,
          child: WayaButton(
          callback: () {
            WayaNav.toNamed('/create-shop');
          },
          
          centerWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/button-icon.svg'),
              const Gap(6),
              Text(
                "Create Shop",
                style: TextStyle().wayaCopyWith(
                    color: wayaTheme.colorScheme.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        )
      ],
    );
  }
}

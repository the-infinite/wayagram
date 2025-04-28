import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';
import 'package:gap/gap.dart';

@Deprecated('Use WayaShop instead of WayaSeller for the new shop implementation')
class WayaSeller extends ConsumerStatefulWidget {
  const WayaSeller({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WayaSellerState();
}

class _WayaSellerState extends ConsumerState<WayaSeller> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      onTapBackButton: () => WayaNav.toNamed(BottomView.route, arguments: 0),
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
                text: 'My Products',
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              WayaTabButton(
                isSelected: _selectedIndex == 2,
                text: 'Manage Shops',
                onTap: () => setState(() => _selectedIndex = 2),
              ),
            ],
          ),
          const Gap(10),
          // if (_selectedIndex == 0) AllProducts(),
          // if (_selectedIndex == 1) SellerProducts(),
          // if (_selectedIndex == 2) ManageShop()
        ],
      ),
    );
  }
}

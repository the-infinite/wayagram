import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/deal_applications.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/listed_products.dart';
import 'package:wayagram/features/shop/widgets/waya_shop_tab_button.dart';

class WayaGramDeals extends ConsumerStatefulWidget {
  static const route = '/wayagram-deal';
  const WayaGramDeals({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WayaGramDealState();
}

class _WayaGramDealState extends ConsumerState<WayaGramDeals> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);

    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: 'Wayagram Deals',
        body: Column(
          children: [
            const Gap(10),
            Row(
              children: [
                WayaShopTabButton(
                  isSelected: _selectedIndex == 0,
                  text: 'Listed Products',
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                WayaShopTabButton(
                  isSelected: _selectedIndex == 1,
                  text: 'Applications',
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
              ],
            ),
            const Gap(10),
            if (_selectedIndex == 0) ListedProducts(),
            if (_selectedIndex == 1) DealApplications(),
          ],
        ));
  }
}

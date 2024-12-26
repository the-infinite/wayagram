import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/shop/buyer/views/all_products.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';

class WayaBuyer extends ConsumerStatefulWidget {
  const WayaBuyer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WayaBuyerState();
}

class _WayaBuyerState extends ConsumerState<WayaBuyer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: 'Shop',
        appBarTrailing: WayaCartIcon(count: 0),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
               TabBar(
                controller: _tabController,
                onTap: (value) {
                  _pageController.animateToPage(value, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                },
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(text: 'All Products'),
                  Tab(text: 'Orders'),
                ],
                dividerColor: wayaTheme.colorScheme.greyColor200,
                dividerHeight: 0.9,
                indicatorColor: wayaTheme.colorScheme.primary,
              ),
          const Gap(25),
          Visibility(
            visible: _tabController.index == 0,
            child: AllProducts())

          ],
        ));
  }
}

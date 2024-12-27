import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/shop/widgets/categories_filter_widget.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';

class AllProducts extends ConsumerWidget {
  const AllProducts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Column(
      children: [
        FilterWidget<Product>(allItems: []),
        const Gap(25),
        GroupedWidgetHeader(
            onTap: () {},
            subTitle: 'Explore Categories & Best Offers',
            title: 'Wayagram Deals'),
        const Gap(10),
        CategoriesFilterWidget<Product>(allItems: []),
        const Gap(25),
        GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                childAspectRatio: 0.52,
                crossAxisSpacing: 12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: products[index],
                isExplore: false,
                isWayaGramDeal: true,
                canbeAddedTocart: true,
              );
            }),
        const Gap(25),
        GroupedWidgetHeader(
            onTap: () {},
            subTitle: 'Explore Categories & Best Offers',
            title: 'Recommended Products'),
        const Gap(25),
        GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                childAspectRatio: 0.55,
                crossAxisSpacing: 12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: products[index],
                isExplore: false,
                canbeAddedTocart: true,
                
              );
            }),
      ],
    );
  }
}

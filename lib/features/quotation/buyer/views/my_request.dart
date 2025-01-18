import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/shop/data/model/model.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/shop/widgets/categories_filter_widget.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';

import '../../../../core/utils/waya_navigation.dart';
import '../../vm/bid_vm.dart';
import '../../widgets/quotation_card.dart';
import '../../widgets/request_card.dart';

class MyRequests extends ConsumerWidget {
  const MyRequests({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(bidVmProvider.notifier);
    return Column(
      children: [
        FilterWidget<Product>(allItems: [], hintText: 'Search Requests'),
        const Gap(25),
        GroupedWidgetHeader(
            onTap: () {},
            subTitle: 'Explore Categories & Best Offers',
            title: 'Wayagram Deals'),
        const Gap(10),
        CategoriesFilterWidget<Product>(allItems: [], ),
        const Gap(25),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: viewModel.quotations.length,
            itemBuilder: (context, index) {
              return RequestCard(quotation: viewModel.quotations[index],
              onTap: () {
                WayaNav.toNamed('/seeSeller-bids');
              },);
            }),
        const Gap(25),
        GroupedWidgetHeader(
            onTap: () {},
            subTitle: 'Explore Categories & Best Offers',
            title: 'Recommended Products'),
        const Gap(25),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: viewModel.quotations.length,
            itemBuilder: (context, index) {
              return RequestCard(quotation: viewModel.quotations[index],
              onTap: () {
                WayaNav.toNamed('/seeSeller-bids');
              },);
            }),
      ],
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return Column(
      children: [
        for (int i = 0; i < products.length; i += 2)
          Row(
            children: [
              Expanded(
                child: ProductCard(
                  product: products[i],
                  isExplore: false,
                  isWayaGramDeal: true,
                  canbeAddedTocart: true,
                ),
              ),
              if (i + 1 < products.length) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ProductCard(
                    product: products[i + 1],
                    isExplore: false,
                    isWayaGramDeal: true,
                    canbeAddedTocart: true,
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }

  Widget _wayagramDealProductLoadingState({required BuildContext context}) {
    return Column(
      children: [
        for (int i = 0; i < 6; i += 2)
          Row(
            children: [
              Expanded(
                child: ProductCardSekeleton(
                  isExplore: false,
                  isWayaGramDeal: true,
                  canbeAddedTocart: true,
                ),
              ),
              if (i + 1 < 6) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ProductCardSekeleton(
                    isExplore: false,
                    isWayaGramDeal: true,
                    canbeAddedTocart: true,
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }

  Widget _recommendedProductLoadingState({required BuildContext context}) {
    return Column(
      children: [
        for (int i = 0; i < 4; i += 2)
          Row(
            children: [
              Expanded(
                child: ProductCardSekeleton(
                  isExplore: false,
                  canbeAddedTocart: true,
                ),
              ),
              if (i + 1 < 4) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ProductCardSekeleton(
                    isExplore: false,
                    canbeAddedTocart: true,
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }
}
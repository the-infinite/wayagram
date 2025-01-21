import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/shop/widgets/categories_filter_widget.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';

class AllProducts extends ConsumerWidget {
  const AllProducts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(shopVmProvider.notifier);
    final state = ref.watch(shopVmProvider);

    return RefreshIndicator(
        onRefresh: () => ref.read(shopVmProvider.notifier).getAllProducts(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterWidget<Product>(allItems: []),
              const Gap(25),
              GroupedWidgetHeader(
                onTap: () {},
                subTitle: 'Explore Categories & Best Offers',
                title: 'Wayagram Deals',
              ),
              const Gap(10),
              CategoriesFilterWidget(
                setCategory: (value) => {},
                uniqueKey: 'all-product',
              ),
              const Gap(25),
              state.isLoading
                  ? _wayagramDealProductLoadingState(context: context)
                  : const SizedBox.shrink(),
              const Gap(25),
              GroupedWidgetHeader(
                onTap: () {},
                subTitle: 'Explore Categories & Best Offers',
                title: 'Recommended Products',
              ),
              const Gap(25),
              state.isLoading
                  ? _recommendedProductLoadingState(context: context)
                  : _buildProductGrid(notifier.filteredProducts),
            ],
          ),
        ));
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

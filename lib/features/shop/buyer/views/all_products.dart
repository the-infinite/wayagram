import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/shop/data/model/product_detail_type.dart';
import 'package:wayagram/features/shop/views/products_view_page.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/shop/widgets/categories_filter_widget.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';
import 'package:wayagram/features/shop/widgets/products_grid.dart';

class AllProducts extends ConsumerWidget {
  const AllProducts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(shopVmProvider.notifier);
    final state = ref.watch(shopVmProvider);

    return Expanded(
        child: RefreshIndicator(
            onRefresh: () =>
                ref.read(shopVmProvider.notifier).getAllProducts(1),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilterWidget(
                    search: TextEditingController(),
                  ),
                  const Gap(5),
                  GroupedWidgetHeader(
                    onTap: () {
                      WayaNav.toNamed(ProductsViewPage.route,
                          arguments: ProductDetailType.wayagramdeal);
                    },
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
                      : ProductsGrid(
                          products: notifier.filteredWayagramDealProducts),
                  const Gap(25),
                  GroupedWidgetHeader(
                    onTap: () {
                      WayaNav.toNamed(ProductsViewPage.route,
                          arguments: ProductDetailType.recommended);
                    },
                    subTitle: 'Explore Categories & Best Offers',
                    title: 'Recommended Products',
                  ),
                  const Gap(25),
                  state.isLoading
                      ? _recommendedProductLoadingState(context: context)
                      : ProductsGrid(products: notifier.filteredProducts),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            )));
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

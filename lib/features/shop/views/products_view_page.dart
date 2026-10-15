import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';
import 'package:wayagram/features/shop/data/model/product_detail_type.dart';
import 'package:wayagram/features/shop/mixin/product_mixin.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';
import 'package:wayagram/features/shop/widgets/products_grid.dart';

class ProductsViewPage extends ConsumerStatefulWidget {
  static const route = '/products-view-page';
  const ProductsViewPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductsViewPageState();
}

class _ProductsViewPageState extends ConsumerState<ProductsViewPage>
    with ProductMixin {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProductDetailType? arg =
        ModalRoute.of(context)?.settings.arguments as ProductDetailType?;

    final productDetail = getProduct(type: arg!, ref: ref);
    return WayaScaffold(
      isLoading: false,
      isScrollable: false,
      title: productDetail.title,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterWidget(
            hintText: 'Search Product',
            search: searchController,
          ),
          const Gap(25),
          Expanded(
            child: PaginatedDataView<Product>(
              uniqueKey: 'product',
              emptyState: EmptyState(
                  assetImage:
                      WayaAssets.images.wallet.searchDocu.image(scale: 1.5),
                  message: "No Product Yet"),
              loadingState: _recommendedProductLoadingState(context: context),
              fetchData: productDetail.fetchData,
              result: (data, s) {
                final filteredProducts = WayaUtils.search<Product>(
                    data,
                    [
                      'id',
                      'categoryId',
                      'deliveryAddress',
                      'name',
                      'options',
                      'condition',
                      'materialType',
                      'description'
                    ],
                    searchController.text);

                return ProductsGrid(
                  isWayaGramDeal:
                      arg == ProductDetailType.wayagramdeal ? true : false,
                  products: filteredProducts,
                );
              },
            ),
          ),
        ],
      ),
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

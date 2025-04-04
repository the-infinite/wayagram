import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/widgets/products_grid.dart';

class ProductSearchResult extends ConsumerStatefulWidget {
  static const route = "/product-search-result";
  const ProductSearchResult({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductSearchResultState();
}

class _ProductSearchResultState extends ConsumerState<ProductSearchResult> {
  @override
  Widget build(BuildContext context) {
    final List<Product> products =
        ModalRoute.of(context)?.settings.arguments as List<Product>;
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        appBar: AppBar(
          leading: WayaBackButton(onTap: () => WayaNav.goBack()),
          title: Text(
            "${products.length} Search Results",
            style: wayaTheme.textTheme.bodyMedium,
          ),
        ),
        body: ProductsGrid(products: products));
  }
}

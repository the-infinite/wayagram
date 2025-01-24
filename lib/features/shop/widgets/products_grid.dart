import 'package:flutter/material.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';

class ProductsGrid extends StatelessWidget {
  final List<Product> products;
  const ProductsGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 3 / 6,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(
          product: products[index],
          isExplore: false,
          isWayaGramDeal: true,
          canbeAddedTocart: true,
        );
      },
    );
  }
}

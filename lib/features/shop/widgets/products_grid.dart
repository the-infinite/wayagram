import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';

class ProductsGrid extends StatelessWidget {
  final List<Product> products;
  final double childAspectRatio;
  const ProductsGrid({super.key, required this.products, this.childAspectRatio = 3/5});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: context.height * 0.03,
        childAspectRatio: childAspectRatio,
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

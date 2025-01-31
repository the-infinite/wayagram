import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';

class ProductsGrid extends StatelessWidget {
  final List<Product> products;

  const ProductsGrid({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spacing = context.height * 0.04;

    return Column(
      children: List.generate(
        (products.length / 2).ceil(),
        (rowIndex) {
          final items = products.skip(rowIndex * 2).take(2).toList();

          return Padding(
            padding: EdgeInsets.only(
                bottom:
                    rowIndex < (products.length / 2).ceil() - 1 ? spacing : 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                items.length,
                (itemIndex) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.0), // Add horizontal spacing
                      child: ProductCard(
                        product: items[itemIndex],
                        isExplore: false,
                        isWayaGramDeal: true,
                        canbeAddedTocart: true,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

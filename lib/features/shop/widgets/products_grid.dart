import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
//import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_product_response_model.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';

class ProductsGrid extends StatelessWidget {
  final List<Product> products;
  final bool isWayaGramDeal;

  const ProductsGrid(
      {super.key, required this.products, this.isWayaGramDeal = false});

  @override
  Widget build(BuildContext context) {
    final userId = ConversationState.self.id;

    return Column(
      children: [
        for (int i = 0; i < products.length; i += 2)
          Row(
            children: [
              Expanded(
                child: userId == products[i].vendorId
                    ? SellerProductCard(
                        product: SellerProduct.fromJson(products[i].toJson()),
                        isExplore: false,
                        sellerProduct: true,
                      )
                    : ProductCard(
                        product: products[i],
                        isExplore: false,
                        canbeAddedTocart: true,
                        isWayaGramDeal: isWayaGramDeal,
                      ),
              ),
              if (i + 1 < products.length) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: userId == products[i + 1].vendorId
                      ? SellerProductCard(
                          product:
                              SellerProduct.fromJson(products[i + 1].toJson()),
                          isExplore: false,
                          sellerProduct: true,
                        )
                      : ProductCard(
                          product: products[i + 1],
                          isExplore: false,
                          canbeAddedTocart: true,
                          isWayaGramDeal: isWayaGramDeal,
                        ),
                ),
              ] else ...[
                const SizedBox(width: 12),
                Expanded(child: SizedBox()),
              ],
            ],
          ),
      ],
    );
  }
}

class SellerProductGrid extends StatelessWidget {
  final List<SellerProduct> products;

  const SellerProductGrid({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    //final spacing = context.height * 0.02;
    final wayaTheme = Theme.of(context);

    if (products.isEmpty) {
      return Align(
        alignment: Alignment.center,
        child: Text(
          "No Product",
          style: wayaTheme.textTheme.descriptionStyle
              .copyWith(color: wayaTheme.colorScheme.greyColor400),
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < products.length; i += 2)
          Row(
            children: [
              Expanded(
                child: SellerProductCard(
                  product: products[i],
                  isExplore: false,
                  sellerProduct: true,
                ),
              ),
              if (i + 1 < products.length) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: SellerProductCard(
                    product: products[i + 1],
                    isExplore: false,
                    sellerProduct: true,
                  ),
                ),
              ] else ...[
                const SizedBox(width: 12),
                Expanded(child: SizedBox()),
              ],
            ],
          ),
      ],
    );
  }
}

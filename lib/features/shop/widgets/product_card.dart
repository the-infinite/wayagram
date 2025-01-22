import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/routes.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';


import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/cart/vm/cart_vm.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final bool isWayaGramDeal;
  final bool canbeAddedTocart;
  final bool isExplore;
  final bool sellerProduct;
  const ProductCard(
      {super.key,
      required this.product,
      this.canbeAddedTocart = false,
      this.isExplore = true,
      this.sellerProduct = false,
      this.isWayaGramDeal = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final String image = product.images.isEmpty ? "" : product.images[0];

    return GestureDetector(
      onTap: () {
        WayaNav.toNamed(ProductDetail.route, arguments: product);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          product.images.isEmpty
              ? Container(
                  height: 180,
                  decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.scaffoldColor,
                      borderRadius: BorderRadius.circular(8)),
                )
              : WayaImage(
                  imageUrl: image,
                  height: 180,
                  fit: BoxFit.contain,
                  radius: BorderRadius.circular(8),
                  color: wayaTheme.colorScheme.transparent,
                ),
          Visibility(
              visible: product.wayagramDeal,
              child: Column(
                children: [
                  const Gap(3),
                  Container(
                    width: 110,
                    padding: EdgeInsets.fromLTRB(3, 3, 3, 3),
                    decoration: BoxDecoration(
                        color: wayaTheme.colorScheme.customPrimary,
                        borderRadius: BorderRadius.circular(6)),
                    child: Center(
                      child: Text("WAYAGRAM DEAL",
                          style: TextStyle().wayaCopyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 10)),
                    ),
                  )
                ],
              )),
          Visibility(
              visible: isExplore,
              child: Column(
                children: [
                  const Gap(3),
                  Text(product.category!.label,
                      style: wayaTheme.textTheme.hintStyle),
                ],
              )),
          const Gap(3),
          Text(product.name, style: wayaTheme.textTheme.bodyXtraMedium),
          Visibility(
              visible: !isExplore && product.rating != null,
              child: Column(
                children: [
                  const Gap(3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: wayaTheme.colorScheme.customPrimary,
                        size: 18,
                      ),
                      const Gap(3),
                      Text(
                        product.rating ?? '0',
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.greyColor400,
                            fontSize: 11),
                      )
                    ],
                  )
                ],
              )),
          Visibility(
              visible: true,
              child: Column(
                children: [
                  const Gap(3),
                  Text(
                    "₦${product.price}",
                    style: TextStyle().wayaCopyWith(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: wayaTheme.colorScheme.greyColor400,
                        fontSize: 14,
                        color: wayaTheme.colorScheme.greyColor400),
                  ),
                ],
              )),
          const Gap(3),
          Text(
              product.discountPercentage > 0
                  ? WayaHelpers.calculatedDiscountPrice(
                      product.price, product.discountPercentage)
                  : "₦${product.price}",
              style: TextStyle().wayaCopyWith(
                  color: isExplore
                      ? wayaTheme.colorScheme.customPrimary
                      : wayaTheme.colorScheme.customBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          Visibility(
              visible: canbeAddedTocart,
              child: Column(
                children: [
                  const Gap(3),
                  WayaButton(
                    callback: () {
                  ref.read(cartVmProvider.notifier).addToCart(product, 1);
                    },
                    height: 38,
                    radius: 6,
                    color: wayaTheme.colorScheme.greyColor300,
                    centerWidget: Text(
                      'Add To Cart',
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.customBlack,
                          fontSize: 14),
                    ),
                    textColor: wayaTheme.colorScheme.customBlack,
                  )
                ],
              )),
          Visibility(
              visible: sellerProduct,
              child: Column(
                children: [
                  const Gap(3),
                  WayaButton(
                    callback: () {
                      // ref.read(cartProvider.notifier).addToCart(product, 1);
                    },
                    height: 38,
                    radius: 6,
                    color: wayaTheme.colorScheme.greyColor300,
                    centerWidget: Text(
                      'Manage Product',
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.customBlack,
                          fontSize: 14),
                    ),
                    textColor: wayaTheme.colorScheme.customBlack,
                  )
                ],
              ))
        ],
      ),
    );
  }
}

class ProductCardSekeleton extends StatelessWidget {
  final bool isWayaGramDeal;
  final bool canbeAddedTocart;
  final bool isExplore;
  final bool sellerProduct;
  const ProductCardSekeleton(
      {super.key,
      this.canbeAddedTocart = false,
      this.isExplore = true,
      this.sellerProduct = false,
      this.isWayaGramDeal = false});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 180,
          decoration: BoxDecoration(
              color: wayaTheme.colorScheme.greyColor100,
              borderRadius: BorderRadius.circular(8)),
        ),
        Visibility(
            visible: isWayaGramDeal,
            child: Column(
              children: [
                const Gap(3),
                Container(
                  width: 120,
                  height: 24,
                  padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                  decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.greyColor100,
                      borderRadius: BorderRadius.circular(6)),
                )
              ],
            )),
        Visibility(
            visible: isExplore,
            child: Column(
              children: [
                const Gap(3),
                Container(
                  width: 80,
                  height: 24,
                  padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                  decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.greyColor100,
                      borderRadius: BorderRadius.circular(6)),
                )
              ],
            )),
        const Gap(3),
        Container(
          width: 140,
          height: 24,
          padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
          decoration: BoxDecoration(
              color: wayaTheme.colorScheme.greyColor100,
              borderRadius: BorderRadius.circular(6)),
        ),
        Visibility(
            visible: !isExplore,
            child: Column(
              children: [
                const Gap(3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 24,
                      padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                      decoration: BoxDecoration(
                          color: wayaTheme.colorScheme.greyColor100,
                          borderRadius: BorderRadius.circular(6)),
                    )
                  ],
                )
              ],
            )),
        Visibility(
            visible: !isExplore,
            child: Column(
              children: [
                const Gap(3),
                Container(
                  width: 60,
                  height: 24,
                  padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                  decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.greyColor100,
                      borderRadius: BorderRadius.circular(6)),
                )
              ],
            )),
        const Gap(3),
        Container(
          width: 60,
          height: 24,
          padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
          decoration: BoxDecoration(
              color: wayaTheme.colorScheme.greyColor100,
              borderRadius: BorderRadius.circular(6)),
        ),
        Visibility(
            visible: canbeAddedTocart,
            child: Column(
              children: [
                const Gap(3),
                Container(
                  width: 120,
                  height: 24,
                  padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                  decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.greyColor100,
                      borderRadius: BorderRadius.circular(6)),
                )
              ],
            )),
        Visibility(
            visible: sellerProduct,
            child: Column(
              children: [
                const Gap(3),
                Container(
                  width: 120,
                  height: 24,
                  padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                  decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.greyColor100,
                      borderRadius: BorderRadius.circular(6)),
                )
              ],
            ))
      ],
    );
  }
}

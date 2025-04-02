import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_routes.dart';
import 'package:wayagram/features/shop/seller/data/model/add_product_state.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_product_response_model.dart';
import 'package:wayagram/features/shop/cart/vm/cart_vm.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/seller/views/add_product/add_product.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final bool isWayaGramDeal;
  final bool canbeAddedTocart;
  final bool isExplore;
  final bool sellerProduct;
  const ProductCard({
    super.key,
    required this.product,
    this.canbeAddedTocart = false,
    this.isExplore = true,
    this.sellerProduct = false,
    this.isWayaGramDeal = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final String image = product.images.isEmpty ? "" : product.images[0];

    return GestureDetector(
      onTap: () {
        WayaNav.toNamed(WayaAppRoutes.getProductDetailScreen(product.id));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              WayaImage(
                imageUrl: image,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                radius: BorderRadius.circular(8),
                color: wayaTheme.colorScheme.transparent,
              ),
            ],
          ),
          if (product.discountPercentage == 0)
            SizedBox(
              height: 22,
            ),
          Visibility(
              visible: isWayaGramDeal,
              child: Column(
                children: [
                  SizedBox(height: 3),
                  Container(
                    width: 110,
                    padding: EdgeInsets.fromLTRB(3, 3, 3, 3),
                    decoration: BoxDecoration(
                        color: wayaTheme.colorScheme.customPrimary,
                        borderRadius: BorderRadius.circular(6)),
                    child: Center(
                      child: Text("WAYAGRAM DEAL",
                          style: wayaTheme.textTheme.descriptionStyle.wayaCopyWith(
                              color: wayaTheme.colorScheme.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp)),
                    ),
                  )
                ],
              )),
          Visibility(
              visible: isExplore,
              child: Column(
                children: [
                  SizedBox(height: 3),
                  Text(product.categoryName,
                      style: wayaTheme.textTheme.hintStyle),
                ],
              )),
          SizedBox(height: 3),
          Text(product.name.capitalizeFirst!,
              style: wayaTheme.textTheme.bodyXtraMedium),
          Visibility(
              visible: !isExplore,
              child: Column(
                children: [
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: wayaTheme.colorScheme.customPrimary,
                        size: 18,
                      ),
                      SizedBox(height: 3),
                      Text(
                        "${product.rating ?? 0}",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.customBlack,
                            fontSize: 12.sp),
                      )
                    ],
                  )
                ],
              )),
          Visibility(
              visible: product.discountPercentage > 0,
              child: Column(
                children: [
                  SizedBox(height: 3),
                  Text(
                    WayaHelpers.formatPrice(
                        double.parse(product.price).toInt()),
                    style: wayaTheme.textTheme.descriptionStyle.wayaCopyWith(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: wayaTheme.colorScheme.greyColor400,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: wayaTheme.colorScheme.greyColor400),
                  ),
                ],
              )),
          SizedBox(height: 3),
          Text(
              product.discountPercentage > 0
                  ? 
                          WayaHelpers.calculatedDiscountPrice(
                              product.price, product.discountPercentage)
                  : WayaHelpers.formatPrice(
                      double.parse(product.price).toInt()),
              style: wayaTheme.textTheme.descriptionStyle.wayaCopyWith(
                  color: isExplore
                      ? wayaTheme.colorScheme.customPrimary
                      : wayaTheme.colorScheme.customBlack,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600)),
          Visibility(
              visible: canbeAddedTocart,
              child: Column(
                children: [
                  SizedBox(height: 3),
                  WayaButton(
                    callback: () async {
                      int intPrice = double.parse(product.price).toInt();
                      int price = product.discountPercentage > 0
                          ? (intPrice -
                                  (intPrice * product.discountPercentage / 100))
                              .toInt()
                          : intPrice;
                      ref.read(cartVmProvider.notifier).addToCart(
                          count: 1,
                          productId: product.id,
                          productImage: image,
                          productName: product.name,
                          price: price,
                          shopId: product.shopId);
                      WayaSnackBar.showToast("Item added to cart");
                    },
                    height: 38,
                    radius: 6,
                    color: wayaTheme.colorScheme.primary50,
                    centerWidget: Text(
                      'Add To Cart',
                      style: wayaTheme.textTheme.descriptionStyle.wayaCopyWith(
                          color: wayaTheme.colorScheme.customPrimary,
                          fontSize: 14.sp),
                    ),
                    textColor: wayaTheme.colorScheme.customPrimary,
                  )
                ],
              )),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

class SellerProductCard extends ConsumerWidget {
  final SellerProduct product;
  final bool isWayaGramDeal;
  final bool canbeAddedTocart;
  final bool isExplore;
  final bool sellerProduct;
  const SellerProductCard(
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
        WayaNav.toNamed(WayaAppRoutes.getProductDetailScreen(product.id));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WayaImage(
            imageUrl: image,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            radius: BorderRadius.circular(8),
            color: wayaTheme.colorScheme.transparent,
          ),
          Visibility(
              visible: product.wayagramDeal != null,
              child: Column(
                children: [
                  SizedBox(height: 3),
                  Container(
                    width: 110,
                    padding: EdgeInsets.fromLTRB(3, 3, 3, 3),
                    decoration: BoxDecoration(
                        color: wayaTheme.colorScheme.customPrimary,
                        borderRadius: BorderRadius.circular(6)),
                    child: Center(
                      child: Text("WAYAGRAM DEAL",
                          style: wayaTheme.textTheme.descriptionStyle.wayaCopyWith(
                              color: wayaTheme.colorScheme.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp)),
                    ),
                  )
                ],
              )),
          Visibility(
              visible: isExplore,
              child: Column(
                children: [
                  SizedBox(height: 3),
                  Text(product.categoryName,
                      style: wayaTheme.textTheme.hintStyle),
                ],
              )),
          SizedBox(height: 3),
          Text(product.name.capitalizeFirst!,
              style: wayaTheme.textTheme.bodyXtraMedium),
          Visibility(
              visible: !isExplore,
              child: Column(
                children: [
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: wayaTheme.colorScheme.customPrimary,
                        size: 18,
                      ),
                      SizedBox(height: 3),
                      Text(
                        "${product.rating ?? 0}",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.customBlack,
                            fontSize: 12.sp),
                      )
                    ],
                  )
                ],
              )),
          Visibility(
              visible: product.discountPercentage > 0,
              child: Column(
                children: [
                  SizedBox(height: 3),
                  Text(
                    WayaHelpers.formatPrice(double.parse(product.price).toInt()),
                    style: wayaTheme.textTheme.descriptionStyle.wayaCopyWith(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: wayaTheme.colorScheme.greyColor400,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: wayaTheme.colorScheme.greyColor400),
                  ),
                ],
              )),
          SizedBox(height: 3),
          Text(
              product.discountPercentage > 0
                  ? WayaHelpers.calculatedDiscountPrice(
                      product.price, product.discountPercentage.toInt())
                  : WayaHelpers.formatPrice(double.parse(product.price).toInt()),
              style: TextStyle().wayaCopyWith(
                  color: isExplore
                      ? wayaTheme.colorScheme.customPrimary
                      : wayaTheme.colorScheme.customBlack,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600)),
          Visibility(
              visible: sellerProduct,
              child: Column(
                children: [
                  SizedBox(height: 3),
                  WayaButton(
                    callback: () {
                      WayaNav.toNamed(AddProduct.route,
                          arguments: UpdateProductArg(
                              uniqueKey: Uuid().v4(), product: product));
                    },
                    height: 38,
                    radius: 6,
                    color: wayaTheme.colorScheme.primary50,
                    centerWidget: Text(
                      'Manage Product',
                      style: wayaTheme.textTheme.descriptionStyle.wayaCopyWith(
                          color: wayaTheme.colorScheme.customPrimary,
                          fontSize: 14.sp),
                    ),
                    textColor: wayaTheme.colorScheme.customBlack,
                  )
                ],
              )),
          SizedBox(
            height: 10,
          )
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
                SizedBox(height: 3),
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
                SizedBox(height: 3),
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
        SizedBox(height: 3),
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
                SizedBox(height: 3),
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
                SizedBox(height: 3),
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
        SizedBox(height: 3),
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
                SizedBox(height: 3),
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
                SizedBox(height: 3),
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

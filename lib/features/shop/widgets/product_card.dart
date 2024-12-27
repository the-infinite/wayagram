import 'package:flutter/material.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:gap/gap.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  bool isWayaGramDeal;
  bool canbeAddedTocart;
  bool isExplore;
  ProductCard(
      {super.key,
      required this.product,
      this.canbeAddedTocart = false,
      this.isExplore = true,
      this.isWayaGramDeal = false});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        WayaNav.toNamed('/product-detail', arguments: 'id');
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          product.images.isEmpty
              ? Container(
                  height: 180,
                  decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.greyColor100,
                      borderRadius: BorderRadius.circular(8)),
                )
              : Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: wayaTheme.colorScheme.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    product.images[0],
                    fit: BoxFit.contain,
                  ),
                ),
          Visibility(
              visible: isWayaGramDeal,
              child: Column(
                children: [
                  const Gap(3),
                  Container(
                    width: 120,
                    padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                    decoration: BoxDecoration(
                        color: wayaTheme.colorScheme.customPrimary,
                        borderRadius: BorderRadius.circular(6)),
                    child: Center(
                      child: Text("WAYAGRAM DEAL",
                          style: TextStyle().wayaCopyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ),
                  )
                ],
              )),
          Visibility(
              visible: isExplore,
              child: Column(
                children: [
                  const Gap(3),
                  Text(product.category, style: wayaTheme.textTheme.hintStyle),
                ],
              )),
          const Gap(3),
          Text(product.name, style: wayaTheme.textTheme.bodyXtraMedium),
          Visibility(
              visible: !isExplore,
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
                        "4.6",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.greyColor400,
                            fontSize: 11),
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
                  Text(
                    product.discountPrice,
                    style: TextStyle().wayaCopyWith(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: wayaTheme.colorScheme.greyColor400,
                        fontSize: 14,
                        color: wayaTheme.colorScheme.greyColor400),
                  ),
                ],
              )),
          const Gap(3),
          Text(product.price,
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
                    callback: () {},
                    height: 38,
                    radius: 6,
                    color: wayaTheme.colorScheme.greyColor300,
                    centerWidget: Text('Add To Cart', style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.customBlack, fontSize: 14),),
                    textColor: wayaTheme.colorScheme.customBlack,
                  )
                ],
              ))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:gap/gap.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
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
        const Gap(3),
        Text(product.category, style: wayaTheme.textTheme.hintStyle),
        const Gap(3),
        Text(product.name, style: wayaTheme.textTheme.bodyXtraMedium),
        const Gap(3),
        Text(product.price,
            style: TextStyle().wayaCopyWith(
                color: wayaTheme.colorScheme.customPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}

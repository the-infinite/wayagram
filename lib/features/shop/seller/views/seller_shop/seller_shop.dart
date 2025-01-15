import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/shop/seller/views/seller_shop/widgets/single_shop_card.dart';

class SellerShop extends ConsumerWidget {
  const SellerShop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Manage Shop", style: wayaTheme.textTheme.titleLarge),
        const Gap(3),
        Text(
          'Manage your shop activities here',
          style: wayaTheme.textTheme.hintStyle,
        ),
        const Gap(30),
        Text("My Shops", style: wayaTheme.textTheme.titleSmall),
        const Gap(10),
        ListView.builder(
          itemCount: 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
          return SingleShopCard();
        }),
        const Gap(20),
        Text("Shared Shop", style: wayaTheme.textTheme.titleSmall),
           const Gap(10),
        ListView.builder(
          itemCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
          return SingleShopCard();
        })

      ],
    );
  }
}

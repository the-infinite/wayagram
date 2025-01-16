import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/shop/seller/views/seller_shop/widgets/single_shop_card.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';

class SellerShop extends ConsumerStatefulWidget {
  const SellerShop({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SellerShopState();
}

class _SellerShopState extends ConsumerState<SellerShop> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(manageShopVmProvider.notifier).getSellerShops();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final manageShop = ref.watch(manageShopVmProvider);

    final wayaTheme = Theme.of(context);

    if (manageShop.isLoading) {
      return buildSellerShopSkeleton(context: context);
    }

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
            itemCount: manageShop.shop.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return SingleShopCard(shop: manageShop.shop[index]);
            }),
        const Gap(20),
        // Text("Shared Shop", style: wayaTheme.textTheme.titleSmall),
        // const Gap(10),
        // ListView.builder(
        //     itemCount: 4,
        //     shrinkWrap: true,
        //     physics: const NeverScrollableScrollPhysics(),
        //     itemBuilder: (context, index) {
        //       return SingleShopCard();
        //     })
      ],
    );
  }
}

Widget buildSellerShopSkeleton({required BuildContext context}) {
  final wayaTheme = Theme.of(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 80,
        height: 24,
        decoration: BoxDecoration(
            color: wayaTheme.colorScheme.greyColor100,
            borderRadius: BorderRadius.circular(8)),
      ),
      const Gap(3),
      Container(
        height: 24,
        width: 120,
        decoration: BoxDecoration(
            color: wayaTheme.colorScheme.greyColor100,
            borderRadius: BorderRadius.circular(8)),
      ),
      const Gap(20),
      Container(
        height: 20,
        width: 50,
        decoration: BoxDecoration(
            color: wayaTheme.colorScheme.greyColor100,
            borderRadius: BorderRadius.circular(8)),
      ),
      const Gap(3),
      buildShopCardLoadingState(context: context),
      const Gap(20),
      Container(
        height: 20,
        width: 50,
        decoration: BoxDecoration(
            color: wayaTheme.colorScheme.greyColor100,
            borderRadius: BorderRadius.circular(8)),
      ),
      const Gap(3),
      buildShopCardLoadingState(context: context),
    ],
  );
}

Widget buildShopCardLoadingState({required BuildContext context}) {
  final wayaTheme = Theme.of(context);
  return ListView.builder(
      shrinkWrap: true,
      itemCount: 2,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              height: 90,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: wayaTheme.colorScheme.scaffoldColor,
                  border: Border.all(color: wayaTheme.colorScheme.greyColor100),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: wayaTheme.colorScheme.greyColor100,
                    ),
                  ),
                  const Gap(10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 20,
                        decoration: BoxDecoration(
                            color: wayaTheme.colorScheme.greyColor100,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      const Gap(3),
                      Container(
                        width: 200,
                        height: 20,
                        decoration: BoxDecoration(
                            color: wayaTheme.colorScheme.greyColor100,
                            borderRadius: BorderRadius.circular(8)),
                      )
                    ],
                  )
                ],
              ),
            ),
            const Gap(10)
          ],
        );
      });
}

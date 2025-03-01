import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/upgrade_to_business/views/upgrade_to_business.dart';
import 'package:wayagram/features/shop/seller/views/seller_shop/widgets/single_shop_card.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';
import 'package:wayagram/features/shop/widgets/card_loading_state.dart';

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

    if (ref.read(manageShopVmProvider).isPersonalNotUpgradedToBusiness) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/cp-shop.png'),
            const Gap(20),
            Text(
              "You don't Have a Shop Yet",
               textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(10),
            Text(
              "Please upgrade to a business account to create a shop",
              textAlign: TextAlign.center,
              style: WayaTextStyles.descriptionStyle,
            ),
            const Gap(40),
            WayaButton(
              callback: () {
                WayaNav.toNamed(UpgradeToBusiness.route);
              },
              text: "Upgrade to Business",
            ),
            const Gap(10),
           
          ],
        ),
      );
    }

    if (manageShop.isLoading) {
      return buildSellerShopSkeleton(context: context);
    }

    return RefreshIndicator(
        onRefresh: () async {
          ref.read(manageShopVmProvider.notifier).getSellerShops();
        },
        child: SingleChildScrollView(
          child: Column(
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
                  return SingleShopCard(
                    shop: manageShop.shop[index],
                  );
                },
              ),
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
          ),
        ));
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
      CardLoadingState(),
      const Gap(20),
      Container(
        height: 20,
        width: 50,
        decoration: BoxDecoration(
            color: wayaTheme.colorScheme.greyColor100,
            borderRadius: BorderRadius.circular(8)),
      ),
      const Gap(3),
      CardLoadingState(),
    ],
  );
}

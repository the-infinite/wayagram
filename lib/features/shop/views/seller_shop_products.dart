import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_product_response_model.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';
import 'package:wayagram/features/shop/seller/vm/seller_products_vm.dart';
import 'package:wayagram/features/shop/widgets/products_grid.dart';
import 'package:wayagram/shared/features/shop/model/default.dart';

class SellerShopProducts extends ConsumerStatefulWidget {
  static const route = "/seller-shop-products";
  final String vendorId;
  final String shopId;
  const SellerShopProducts(
      {super.key, required this.vendorId, required this.shopId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SellerShopProducts();
}

class _SellerShopProducts extends ConsumerState<SellerShopProducts> {
  late final shopNotifier = ref.read(manageShopVmProvider.notifier);
  bool isLoading = false;
  ShopDetailsModel? sellerShop;
  List<SellerProduct> sellerProducts = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        try {
          setState(() => isLoading = true);
          //? get shop by vendor Id
          final shop = await shopNotifier.getShopDetails(id: widget.shopId);
          if (shop != null) {
            setState(() {
              sellerShop = shop;
            });
          }

          //> get shop products by shop id
          final products = await ref
              .read(sellerProductsVmProvider.notifier)
              .sellerProducts(shopId: widget.shopId);

          if (products != null) {
            setState(() {
             
              sellerProducts = products;
            });
          }
        } catch (_) {}
        setState(() => isLoading = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    if (sellerShop == null) {
      return Container(
        color: wayaTheme.colorScheme.white,
        width: context.width,
        height: context.height,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return WayaScaffold(
        isLoading: isLoading,
        isScrollable: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 4,
              children: [
                WayaImage(
                  imageUrl: sellerShop?.shop.logo ?? WayaConstants.shopLogo,
                  height: 50,
                  width: 50,
                  radius: BorderRadius.circular(50),
                ),
                Text(
                  sellerShop?.shop.name ?? 'Waya User Shop',
                  style: wayaTheme.textTheme.bodyMedium,
                )
              ],
            ),
            Gap(6.h),
            Text(
              sellerShop?.shop.address ?? '',
              style: wayaTheme.textTheme.descriptionStyle,
            ),
            Gap(6.h),

           if (sellerShop?.shop.description.isNotEmpty == true) ...[
 //? Content.
            Text(
              "Description",
              style: wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                  color: wayaTheme.colorScheme.customBlack,
                  fontSize: context.width * 0.040,
                  fontWeight: FontWeight.w500),
            ),
            //? Section title.

            // Some space.
            const Gap(5),
            Text(
              sellerShop?.shop.description ?? '',
              style: wayaTheme.textTheme.descriptionStyle.copyWith(
                fontSize: context.width * 0.040,
                color: wayaTheme.colorScheme.greyColor400,
              ),
            ),
           ],
                Gap(20.h),
    //? Content.
            Text(
              "Products",
              style: wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                  color: wayaTheme.colorScheme.customBlack,
                  fontSize: context.width * 0.040,
                  fontWeight: FontWeight.w500),
            ),
             // Some space.
            const Gap(10),
            //> Seller Products
            SellerProductGrid(products: sellerProducts ?? [])
          ],
        ));
  }
}

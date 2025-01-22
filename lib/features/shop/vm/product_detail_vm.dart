import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/shop_response_model.dart';
import 'package:wayagram/features/shop/seller/vm/add_product_vm.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';

class ProductDetailState {
  final Product? product;
  final bool isProductOwner;

  ProductDetailState({this.product, this.isProductOwner = false});

  ProductDetailState copyWith({Product? product, bool? isProductOwner}) {
    return ProductDetailState(
        product: product ?? this.product,
        isProductOwner: isProductOwner ?? this.isProductOwner);
  }
}

class ProductDetailVm extends StateNotifier<ProductDetailState> {
  final Ref ref;
  ProductDetailVm(this.ref) : super(ProductDetailState());

  void getCurrentProduct({required Product product}) {
    state = state.copyWith(product: product);

    final ShopData? shop = ref.watch(manageShopVmProvider).singleShop;
    if (shop != null) {
      bool isOwner = shop.id == product.shopId;
      state = state.copyWith(isProductOwner: isOwner);
    }
  }

  void initiateDelete(BuildContext context, Product product) async {
    WayaUtils.showNotice(
        context: context,
        title: "Confirm Your Action",
        message:
            "Please confirm if you would like to delete this product. This will \n update the product availability on the shop.",
        onPress: () {
          ref
              .read(addProductProvider.notifier)
              .deleteProduct(shopId: product.shopId, productId: product.id);
        },
        icon: Image.asset(WayaAssets.images.deleteImg.path),
        buttonText: 'Delete Product',
        secondButtonText: 'Cancel');
  }
}

final productDetailVmProvider =
    StateNotifierProvider<ProductDetailVm, ProductDetailState>(
        (ref) => ProductDetailVm(ref));

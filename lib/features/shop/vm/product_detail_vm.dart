import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/shop_response_model.dart';
import 'package:wayagram/features/shop/seller/vm/add_product_vm.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';

class ProductDetailState {
  final Product? product;
  final bool isProductOwner;
  final List<Product>? similarProduct;
  final bool isLoading;

  ProductDetailState(
      {this.product,
      this.isProductOwner = false,
      this.isLoading = false,
      this.similarProduct = const []});

  ProductDetailState copyWith(
      {Product? product,
      bool? isProductOwner,
      bool? isLoading,
      List<Product>? similarProduct}) {
    return ProductDetailState(
        product: product ?? this.product,
        similarProduct: similarProduct ?? this.similarProduct,
        isLoading: isLoading ?? this.isLoading,
        isProductOwner: isProductOwner ?? this.isProductOwner);
  }
}

class ProductDetailVm extends StateNotifier<ProductDetailState> {
  final Ref ref;
  ProductDetailVm(this.ref) : super(ProductDetailState());

  void getCurrentProduct({required Product product}) async {
    state = state.copyWith(product: product);

    final ShopData? shop = ref.watch(manageShopVmProvider).singleShop;
    if (shop != null) {
      bool isOwner = shop.id == product.shopId;
      state = state.copyWith(isProductOwner: isOwner);
    }
    //getSimilarProduct(categoryId: product.categoryId, productId: product.id);
  }

  // add the api to get similar product when it is made available
  // void getSimilarProduct({required String categoryId, required String productId}) async {
  //   state = state.copyWith(isLoading: true);
  //   final PaginatedResult<Product>? products =
  //       await ref.read(shopVmProvider.notifier).getAllProducts(1);

  //   if (products != null) {
  //     final similar =
  //         products.items.where((prod) => prod.categoryId == categoryId && prod.id != productId).toList();

  //     state = state.copyWith(similarProduct: similar);
  //   }
  //   state = state.copyWith(isLoading: false);
  // }

  void initiateDelete(BuildContext context, Product product) async {
    if (context.mounted) {
      WayaUtils.showNotice(
          context: context,
          title: "Confirm Your Action",
          message:
              "Please confirm if you would like to delete this product. This will \n update the product availability on the shop.",
          onPress: () {
            ref
                .read(addProductProvider('add-product').notifier)
                .deleteProduct(shopId: product.shopId, productId: product.id);
          },
          icon: Image.asset(WayaAssets.images.deleteImg.path),
          buttonText: 'Delete Product',
          secondButtonText: 'Cancel');
    }
  }
}

final productDetailVmProvider =
    StateNotifierProvider<ProductDetailVm, ProductDetailState>(
        (ref) => ProductDetailVm(ref));

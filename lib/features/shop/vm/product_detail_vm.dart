import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/favorites_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/seller/vm/add_product_vm.dart';

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
  final ShopRepository _shopRepository;
  ProductDetailVm(this._shopRepository, this.ref) : super(ProductDetailState());

  Future<Product?> getCurrentProduct({required String id}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _shopRepository.getProductById(id: id);
      Product? singleProduct;
      if (response.success) {
        final ProductResponse data = ProductResponse.fromJson(response.data);
        final Product product = data.data.data[0];
        state = state.copyWith(product: product);
        singleProduct = product;
        if (product.vendorId == ConversationState.self.id) {
          state = state.copyWith(isProductOwner: true);
        } else {
          state = state.copyWith(isProductOwner: false);
        }
      }

      return singleProduct;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    } finally {
      state.copyWith(isLoading: false);
    }

    //getSimilarProduct(categoryId: product.categoryId, productId: product.id);
  }

  Future<void> likeProduct() async {
    try {
      final response = await _shopRepository.addToFavorite(
          productId: state.product!.id, userId: ConversationState.self.id);
      if (response.success) {
        WayaSnackBar.showToast("Added to your favorites");
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<List<FavoriteItem>?> getFavorites() async {
    try {
      final response = await _shopRepository.fetchFavorites();
      List<FavoriteItem> favorites = [];
      if (response.success) {
        FavoritesResponse favoritesResponse =
            FavoritesResponse.fromJson(response.data);

        if (favoritesResponse.data.favorites.isNotEmpty) {
          favorites = favoritesResponse.data.favorites;
        }
      }

      return favorites;
    } catch (e) {
      debugPrint(e.toString());

      return null;
    }
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
        (ref) => ProductDetailVm(ShopRepository.instance, ref));

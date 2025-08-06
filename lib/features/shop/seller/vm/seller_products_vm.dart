import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_product_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_products_state.dart';

class SellerProductsVm extends StateNotifier<SellerProductState> {
  final Ref ref;
  final ShopRepository _shopRepository;

  SellerProductsVm(this._shopRepository, this.ref)
      : super(SellerProductState());

  Future<List<SellerProduct>?> sellerProducts({required String shopId}) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _shopRepository.getSellerProducts(
          shopId: shopId, page: state.page);
      List<SellerProduct> sellerProducts = [];
      if (response.success) {
        SellerProductResponseModel responseModel =
            SellerProductResponseModel.fromJson(response.data);
        sellerProducts = responseModel.data.products;
        state = state.copyWith(products: sellerProducts);
      }
      return sellerProducts;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void setCategory(List<String>? categoryIds) {
    state = state.copyWith(selectedCategoryId: categoryIds);
  }

  List<SellerProduct> get filteredProducts {
    if (state.products.isEmpty) return [];

    return state.products.where((product) {
      // category filter
      if (state.selectedCategoryId.isNotEmpty &&
          !state.selectedCategoryId.contains(product.categoryId)) {
        return false;
      }

      // search filter
      if (state.search.text.isNotEmpty) {
        final query = state.search.text.toLowerCase();
        if (!product.name.toLowerCase().contains(query) &&
            !product.description.toLowerCase().contains(query)) {
          return false;
        }
      }

      return product.wayagramDeal == null;
    }).toList();
  }

  // main function to get se
}

final sellerProductsVmProvider =
    StateNotifierProvider<SellerProductsVm, SellerProductState>((ref) {
  return SellerProductsVm(ShopRepository.instance, ref);
});

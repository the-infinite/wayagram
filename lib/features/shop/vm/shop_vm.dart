import 'package:flutter/widgets.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/bottom_view/bottom_view.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/category_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/review_repsonse_model.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_metrics_response_model.dart';

class ShopVm extends StateNotifier<ShopState> {
  final ShopRepository _repository;
  final Ref ref;
  ShopVm(this._repository, this.ref) : super(ShopState());

  Future<SelectTypePaginatedResult?> allCategories(int page) async {
    try {
      final response = await _repository.getAllCategories(page);

      List<Select> selectCategories = [];

      if (response.success) {
        CategoryResponseModel responseModel =
            CategoryResponseModel.fromJson(response.data);

        final List<CategoryData?> categories = responseModel.data.categories;
        selectCategories = categories.map((val) {
          return Select(label: val!.name, value: val.id, image: val.image);
        }).toList();

        state = state.copyWith(
            totalNoOfCategoryPages: responseModel.data.pagination.totalPages);

        state = state.copyWith(categories: selectCategories);
        // if (selectCategories.isNotEmpty) {
        //   //state = state.copyWith(selectedCategoryId: selectCategories[0].value);
        // }
      }
      return SelectTypePaginatedResult(
          items: selectCategories, totalPages: state.totalNoOfCategoryPages);
    } catch (e) {
      print(e);
      return null;
    }
  }

  void setCategory(List<String>? categoryIds) {
    state = state.copyWith(selectedCategoryId: categoryIds);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<bool?> reviewProduct(
      {required String raterId,
      String? productId,
      String? shopId,
      required int score,
      required String review,
      required BuildContext context}) async {
    try {
      print(productId);

      state = state.copyWith(isReviewing: true);
      final response = await _repository.createRating(
          raterId: raterId,
          score: score,
          productId: productId,
          review: review,
          type: "Shop");

      bool isSuccess = false;
      if (response.success) {
        print(response.data);
        isSuccess = true;
      } else {
        isSuccess = false;
      }

      return isSuccess;
    } catch (error) {
      print(error);
      return null;
    } finally {
      state = state.copyWith(isReviewing: false);
    }
  }

  Future<void> getProductViews({required String productId}) async {
    try {
      final response = await _repository.getProductRating(productId: productId);

      if (response.success) {
        ReviewRepsonseModel responseModel =
            ReviewRepsonseModel.fromJson(response.data);
        state = state.copyWith(reviews: responseModel.data);
        print(response.data);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<PaginatedResult<Product>?> getAllProducts(
      {required int page, int limit = 20}) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _repository.getProducts(page: page, limit: limit);
      List<Product> allProducts = [];
      bool hasNextPage = false;
      if (response.success) {
        ProductResponse productResponse =
            ProductResponse.fromJson(response.data);
        allProducts = productResponse.data.data;
        hasNextPage = productResponse.data.pagination.hasNextPage;
        state = state.copyWith(products: allProducts);
      }
      return PaginatedResult(hasNextPage: hasNextPage, items: allProducts);
    } catch (e) {
      print(e);
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getShopMetrics({required String shopId}) async {
    try {
      final response = await _repository.getShopMetrics(shopId: shopId);

      if (response.success) {
        ShopMetricsResponse shopMetricResponse =
            ShopMetricsResponse.fromJson(response.data);
        state = state.copyWith(sellerMetrics: shopMetricResponse.data);
        print(response.data);
      }
    } catch (error) {
      print(error);
    }
  }

  List<Product> get filteredProducts {
    if (state.products.isEmpty) return [];
    return state.products.where((product) {
      // category filter
      if (state.selectedCategoryId != null &&
          state.selectedCategoryId!.isNotEmpty &&
          !state.selectedCategoryId!.contains(product.categoryId)) {
        return false;
      }

      // search filter
      if (state.searchQuery.isNotEmpty) {
        final query = state.searchQuery.toLowerCase();
        return product.name.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query);
      }

      return product.wayagramDeal == null || product.wayagramDeal == false;
    }).toList();
  }

  List<Product> get filteredWayagramDealProducts {
    if (state.products.isEmpty) return [];
    return state.products.where((product) {
      // category filter
      if (state.selectedCategoryId != null &&
          state.selectedCategoryId!.isNotEmpty &&
          !state.selectedCategoryId!.contains(product.categoryId)) {
        return false;
      }

      // search filter
      if (state.searchQuery.isNotEmpty) {
        final query = state.searchQuery.toLowerCase();
        return product.name.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query);
      }

      return product.wayagramDeal == true;
    }).toList();
  }
}

final shopVmProvider = StateNotifierProvider<ShopVm, ShopState>((ref) {
  return ShopVm(ShopRepository.instance, ref);
});

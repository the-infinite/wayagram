import 'package:flutter/widgets.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/category_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/review_repsonse_model.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_metrics_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/shop_banner_response.dart';
import 'package:wayagram/features/shop/seller/data/model/shop_setting_response.dart';

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
      debugPrint(e.toString());
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
      debugPrint(productId);

      state = state.copyWith(isReviewing: true);
      final response = await _repository.createRating(
          raterId: raterId,
          score: score,
          productId: productId,
          review: review,
          type: "Shop");

      bool isSuccess = false;
      if (response.success) {
        debugPrint(response.data.toString());
        isSuccess = true;
      } else {
        isSuccess = false;
      }

      return isSuccess;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    } finally {
      state = state.copyWith(isReviewing: false);
    }
  }

  Future<void> getProductReviews({required String productId}) async {
    try {
      final response = await _repository.getProductRating(productId: productId);

      if (response.success) {
        ReviewRepsonseModel responseModel =
            ReviewRepsonseModel.fromJson(response.data);
        state = state.copyWith(reviews: responseModel.data);
        debugPrint(response.data.toString());
      }
    } catch (error) {
      debugPrint(error.toString());
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
      debugPrint(e.toString());
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<PaginatedResult<Product>?> getAllWayaDealProducts(
      {required int page, int limit = 20}) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _repository.getOngoingWayaDealProducts(
          page: page, limit: limit);
      List<Product> allProducts = [];
      bool hasNextPage = false;
      if (response.success) {
        ProductResponse productResponse =
            ProductResponse.fromJson(response.data);
        allProducts = productResponse.data.data;
        hasNextPage = productResponse.data.pagination.hasNextPage;
        state = state.copyWith(wayaDealProducts: allProducts);
      }
      return PaginatedResult(hasNextPage: hasNextPage, items: allProducts);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<List<BannerDoc>?> getShopBanner() async {
    try {
      final response = await _repository.getBanner();

      List<BannerDoc> banners = [];
      if (response.success) {
        BannerResponse bannerResponse = BannerResponse.fromJson(response.data);

        banners = bannerResponse.data.docs;

        return banners;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> getShopMetrics({required String shopId}) async {
    try {
      final response = await _repository.getShopMetrics(shopId: shopId);

      if (response.success) {
        ShopMetricsResponse shopMetricResponse =
            ShopMetricsResponse.fromJson(response.data);
        state = state.copyWith(sellerMetrics: shopMetricResponse.data);
        debugPrint(response.data.toString());
      }
    } catch (error) {
      debugPrint(error.toString());
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

      return product.wayagramDeal == null;
    }).toList();
  }

  Future<bool?> updateShopSettings(
      {bool notifyFriendsAboutProductPosts = false,
      bool makeProductPostsPublic = false}) async {
    try {
      // debugPrint(productId);

      //  state = state.copyWith(isReviewing: true);
      final response = await _repository.updateShopSettings(
          notifyFriendsAboutProductPosts, makeProductPostsPublic);

      bool isSuccess = false;
      if (response.success) {
        debugPrint(response.data.toString());
        isSuccess = true;
      } else {
        isSuccess = false;
      }

      return isSuccess;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    } finally {
      // state = state.copyWith(isReviewing: false);
    }
  }

  Future<bool?> updateQuotationSettings({
    bool? receiveQuotationRequests,
    bool? makeRequestsPublic,
    bool? displayQuotationRequestsInFeed,
  }) async {
    try {
      // debugPrint(productId);

      //  state = state.copyWith(isReviewing: true);
      final response = await _repository.updateQuotationSettings(
          receiveQuotationRequests!,
          makeRequestsPublic!,
          displayQuotationRequestsInFeed!);

      bool isSuccess = false;
      if (response.success) {
        debugPrint(response.data.toString());
        isSuccess = true;
      } else {
        isSuccess = false;
      }

      return isSuccess;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    } finally {
      // state = state.copyWith(isReviewing: false);
    }
  }

  Future<ShopSettingsModel?> getShopSettings() async {
    try {
      final response = await _repository.getShopSettings();

      if (response.success) {
        ShopSettingsModel shopMetricResponse =
            ShopSettingsModel.fromJson(response.data);

        debugPrint(response.data.toString());
        return shopMetricResponse;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    return null;
  }

  // List<Product> get filteredWayagramDealProducts {
  //   if (state.products.isEmpty) return [];
  //   return state.products.where((product) {
  //     // category filter
  //     if (state.selectedCategoryId != null &&
  //         state.selectedCategoryId!.isNotEmpty &&
  //         !state.selectedCategoryId!.contains(product.categoryId)) {
  //       return false;
  //     }

  //     // search filter
  //     if (state.searchQuery.isNotEmpty) {
  //       final query = state.searchQuery.toLowerCase();
  //       return product.name.toLowerCase().contains(query) ||
  //           product.description.toLowerCase().contains(query);
  //     }

  //     return product.wayagramDeal == true;
  //   }).toList();
  // }
}

final shopVmProvider = StateNotifierProvider<ShopVm, ShopState>((ref) {
  return ShopVm(ShopRepository.instance, ref);
});

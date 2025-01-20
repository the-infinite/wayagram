import 'package:wayagram/core/data/model/model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/category_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';

class ShopVm extends StateNotifier<ShopState> {
  final ShopRepository _repository;
  final Ref ref;
  ShopVm(this._repository, this.ref) : super(ShopState());

  Future<PaginatedResult?> allCategories(int page) async {
    try {
      final response = await _repository.getAllCategories(page);

      List<Select> selectCategories = [];

      if (response.success) {
        CategoryResponseModel responseModel =
            CategoryResponseModel.fromJson(response.data);

        final List<CategoryData?> categories = responseModel.data.categories;
        selectCategories = categories.map((val) {
          return Select(label: val!.name, value: val.id);
        }).toList();

        state = state.copyWith(
            totalNoOfCategoryPages: responseModel.data.pagination.totalPages);

        state = state.copyWith(categories: selectCategories);
        // if (selectCategories.isNotEmpty) {
        //   //state = state.copyWith(selectedCategoryId: selectCategories[0].value);
        // }
      }
      return PaginatedResult(
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

  Future<void> getAllProducts() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _repository.getProducts();

      if (response.success) {
        ProductResponse productResponse =
            ProductResponse.fromJson(response.data);
        List<Product>? products = productResponse.data.data.map((product) {
          return product.copyWith(
              category: state.categories?.firstWhere(
            (cat) => cat.value == product.categoryId,
          ));
        }).toList();
        state = state.copyWith(products: products);
      }
    } catch (e) {
      print(e);
    } finally {
      state = state.copyWith(isLoading: false);
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

      return true;
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

      return product.wayagramDeal;
    }).toList();
  }
}

final shopVmProvider = StateNotifierProvider<ShopVm, ShopState>((ref) {
  return ShopVm(ShopRepository(), ref);
});

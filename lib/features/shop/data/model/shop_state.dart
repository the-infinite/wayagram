import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';

class ShopState {
  final bool isLoading;
  final List<Select>? categories;
  final List<String>? selectedCategoryId;
  final int totalNoOfCategoryPages;
  final String searchQuery;
  final bool isReviewing;
  final List<Product> products;
  

  ShopState(
      {this.categories = const [],
      this.isLoading = false,
      this.selectedCategoryId = const [],
      this.products = const [],
      this.searchQuery = '',
      this.isReviewing = false,
      this.totalNoOfCategoryPages = 1});

  ShopState copyWith(
      {bool? isLoading,
      List<Select>? categories,
      List<String>? selectedCategoryId,
      List<Product>? products,
      String? searchQuery,
      bool? isReviewing,
      int? totalNoOfCategoryPages}) {
    return ShopState(
        categories: categories ?? this.categories,
        isReviewing: isReviewing ?? this.isReviewing,
        selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
        totalNoOfCategoryPages:
            totalNoOfCategoryPages ?? this.totalNoOfCategoryPages,
        searchQuery: searchQuery ?? this.searchQuery,
        products: products ?? this.products,
        isLoading: isLoading ?? this.isLoading);
  }
}

class PaginatedResult<T> {
  final List<T> items;
  final bool hasNextPage;

  PaginatedResult({required this.hasNextPage, required this.items});
}

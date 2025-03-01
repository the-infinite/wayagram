import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_metrics_response_model.dart';

class ShopState {
  final bool isLoading;
  final List<Select>? categories;
  final List<String>? selectedCategoryId;
  final int totalNoOfCategoryPages;
  final String searchQuery;
  final bool isReviewing;
  final List<Product> products;
  final ShopMetricsData? sellerMetrics;

  ShopState(
      {this.categories = const [],
      this.isLoading = false,
      this.selectedCategoryId = const [],
      this.products = const [],
      this.searchQuery = '',
      this.sellerMetrics,
      this.isReviewing = false,
      this.totalNoOfCategoryPages = 1});

  ShopState copyWith(
      {bool? isLoading,
      List<Select>? categories,
      List<String>? selectedCategoryId,
      List<Product>? products,
      String? searchQuery,
      ShopMetricsData? sellerMetrics,
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
        sellerMetrics: sellerMetrics ?? this.sellerMetrics,
        isLoading: isLoading ?? this.isLoading);
  }
}

class PaginatedResult<T> {
  final List<T> items;
  final bool hasNextPage;

  PaginatedResult({required this.hasNextPage, required this.items});
}

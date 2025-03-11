
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';

class ProductsState {
  final bool hasLoaded;
  final bool isLoading;
  final int totalSize;
  final int limit;
  final int page;
  final int? nextPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final List<Product> products;

  // Construct.
  ProductsState({
    required this.hasLoaded,
    required this.isLoading,
    required this.totalSize,
    required this.limit,
    required this.page,
    required this.nextPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.products,
  });

  ProductsState copyWith({
    bool? hasLoaded,
    bool? isLoading,
    int? totalSize,
    int? limit,
    int? page,
    int? nextPage,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
    List<Product>? products,
  }) {
    return ProductsState(
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      totalSize: totalSize ?? this.totalSize,
      limit: limit ?? this.limit,
      page: page ?? this.page,
      nextPage: nextPage ?? this.nextPage,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      products: products ?? this.products,
    );
  }

  static final initial = ProductsState(
    hasLoaded: false,
    isLoading: false,
    totalSize: 0,
    limit: 15,
    page: 0,
    nextPage: 1,
    totalPages: 0,
    hasNextPage: true,
    hasPreviousPage: false,
    products: [],
  );
}

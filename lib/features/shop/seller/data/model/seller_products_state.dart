import 'package:flutter/material.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_product_response_model.dart';

class SellerProductState {
  final bool isLoading;
  final List<SellerProduct> products;
  final TextEditingController search;
  final int page;
  final List<String> selectedCategoryId;

  SellerProductState({
    this.isLoading = false,
    this.products = const [],
    this.selectedCategoryId = const [],
    this.page = 1,
    TextEditingController? search,
  }) : search = search ?? TextEditingController();

  SellerProductState copyWith(
      {bool? isLoading,
      List<SellerProduct>? products,
      List<String>? selectedCategoryId,
      TextEditingController? search,
      int? page}) {
    return SellerProductState(
        isLoading: isLoading ?? this.isLoading,
        products: products ?? this.products,
        search: search ?? this.search,
        selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
        page: page ?? this.page);
  }
}

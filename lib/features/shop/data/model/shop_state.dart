import 'package:wayagram/core/data/model/model.dart';

class ShopState {
  final bool isLoading;
  final List<Select>? categories;
  final String? selectedCategoryId;

  ShopState(
      {this.categories, this.isLoading = false, this.selectedCategoryId = ''});

  ShopState copyWith(
      {bool? isLoading, List<Select>? categories, String? selectedCategoryId}) {
    return ShopState(
        categories: categories ?? this.categories,
        selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
        isLoading: isLoading ?? this.isLoading);
  }
}

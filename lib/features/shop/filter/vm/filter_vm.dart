import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterState {
  final String selectedCategory;
  final String minPrice;
  final String maxPrice;
  final String deliveryType;
  final String discountType;
  final String height;
  final String depth;
  final String location;

  const FilterState({
    this.selectedCategory = 'All Category',
    this.minPrice = '',
    this.maxPrice = '',
    this.deliveryType = 'Both',
    this.discountType = '',
    this.height = 'Less than 30m',
    this.depth = 'Less than 6ft',
    this.location = 'Less than 6ft',
  });

  FilterState copyWith({
    String? selectedCategory,
    String? minPrice,
    String? maxPrice,
    String? deliveryType,
    String? discountType,
    String? height,
    String? depth,
    String? location,
  }) {
    return FilterState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      deliveryType: deliveryType ?? this.deliveryType,
      discountType: discountType ?? this.discountType,
      height: height ?? this.height,
      depth: depth ?? this.depth,
      location: location ?? this.location,
    );
  }
}

final filterVmProvider = StateNotifierProvider<FilterVm, FilterState>((ref) {
  return FilterVm(ref);
});

class FilterVm extends StateNotifier<FilterState> {
  final Ref ref;
  FilterVm(this.ref) : super(const FilterState());

  void updateCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void updatePriceRange(String min, String max) {
    state = state.copyWith(minPrice: min, maxPrice: max);
  }

  void updateDeliveryType(String type) {
    state = state.copyWith(deliveryType: type);
  }

  void updateDiscountType(String type) {
    state = state.copyWith(discountType: type);
  }

  void updateHeight(String height) {
    state = state.copyWith(height: height);
  }

  void updateDepth(String depth) {
    state = state.copyWith(depth: depth);
  }

  void updateLocation(String location) {
    state = state.copyWith(location: location);
  }

  void reset() {
    state = const FilterState();
  }

  void applyFilters() {
    print('Applying filters: $state');
  }
}

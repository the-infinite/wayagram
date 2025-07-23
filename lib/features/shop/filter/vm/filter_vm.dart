import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterState {
  final List<String> selectedCategory;
  final String minPrice;
  final String maxPrice;
  final List<String> deliveryType;
  final List<String> discountType;
  final int minHeight;
  final int maxHeight;
  final int minWidth;
  final int maxWidth;
  final int minDepth;
  final int maxDepth;
  final String location;
  final List<String> condition;
  final List<String> colors;
  final List<String> chosenStates;

  const FilterState(
      {this.selectedCategory = const [],
      this.minPrice = '',
      this.maxPrice = '',
      this.deliveryType = const [],
      this.discountType = const [],
      this.condition = const [],
      this.chosenStates = const [],
      this.minHeight = 0,
      this.maxHeight = 100,
      this.minWidth = 0,
      this.maxWidth = 100,
      this.minDepth = 0,
      this.maxDepth = 100,
      this.location = '',
      this.colors = const []});

  FilterState copyWith(
      {List<String>? selectedCategory,
      String? minPrice,
      String? maxPrice,
      List<String>? deliveryType,
      List<String>? discountType,
      int? minHeight,
      int? maxHeight,
      int? minWidth,
      int? maxWidth,
      int? minDepth,
      int? maxDepth,
      String? location,
      List<String>? colors,
      List<String>? chosenStates,
      List<String>? condition}) {
    return FilterState(
        selectedCategory: selectedCategory ?? this.selectedCategory,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        deliveryType: deliveryType ?? this.deliveryType,
        discountType: discountType ?? this.discountType,
        minHeight: minHeight ?? this.minHeight,
        maxHeight: maxHeight ?? this.maxHeight,
        minWidth: minWidth ?? this.minWidth,
        maxWidth: maxWidth ?? this.maxWidth,
        minDepth: minDepth ?? this.minDepth,
        maxDepth: maxDepth ?? this.maxDepth,
        location: location ?? this.location,
        colors: colors ?? this.colors,
        chosenStates: chosenStates ?? this.chosenStates,
        condition: condition ?? this.condition);
  }
}

final filterVmProvider = StateNotifierProvider<FilterVm, FilterState>((ref) {
  return FilterVm(ref);
});

class FilterVm extends StateNotifier<FilterState> {
  final Ref ref;
  FilterVm(this.ref) : super(const FilterState());

  void updateCategory(String category) {
    List<String> c = List.from(state.selectedCategory);
    if (c.contains(category)) {
      c.remove(category);
    } else {
      c.add(category);
    }

    state = state.copyWith(selectedCategory: c);
  }

  void updateStates(String chosenState) {
    List<String> c = List.from(state.chosenStates);
    if (c.contains(chosenState)) {
      c.remove(chosenState);
    } else {
      c.add(chosenState);
    }

    state = state.copyWith(chosenStates: c);
  }

  void updatePriceRange(String min, String max) {
    state = state.copyWith(minPrice: min, maxPrice: max);
  }

  void updateDeliveryType(String type) {
    List<String> c = List.from(state.deliveryType);
    if (c.contains(type)) {
      c.remove(type);
    } else {
      c.add(type);
    }
    state = state.copyWith(deliveryType: c);
  }

  void updateCondition(String cond) {
    List<String> c = List.from(state.condition);
    if (c.contains(cond)) {
      c.remove(cond);
    } else {
      c.add(cond);
    }
    state = state.copyWith(condition: c);
  }

  void updateDiscountType(String type) {
    List<String> c = List.from(state.discountType);
    if (c.contains(type)) {
      c.remove(type);
    } else {
      c.add(type);
    }
    state = state.copyWith(discountType: c);
  }

  void updateHeight(int min, int max) {
    state = state.copyWith(minHeight: min, maxHeight: max);
  }

  void updateColors(String color) {
    List<String> c = List.from(state.colors);
    if (c.contains(color)) {
      c.remove(color);
    } else {
      c.add(color);
    }

    state = state.copyWith(colors: c);
  }

  void updateDepth(int min, int max) {
    state = state.copyWith(minDepth: min, maxDepth: max);
  }

  void updateWidth(int min, int max) {
    state = state.copyWith(minWidth: min, maxWidth: max);
  }

  void updateLocation(String location) {
    state = state.copyWith(location: location);
  }

  void reset() {
    state = const FilterState();
  }
}

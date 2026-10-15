import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/model/model.dart';

class CategoryFilterState {
  final List<String> selected;

  CategoryFilterState({this.selected = const []});

  CategoryFilterState copyWith({List<String>? selected}) {
    return CategoryFilterState(selected: selected ?? this.selected);
  }
}

class CategoriesFilterWidgetVm extends StateNotifier<CategoryFilterState> {
  final Ref ref;
  CategoriesFilterWidgetVm(this.ref) : super(CategoryFilterState());

  List<String> updateSelectedCategory(Select cat) {
    if (state.selected.any((i) => i == cat.value)) {
      List<String> selectedList = List.from(state.selected);
      final filtered = selectedList.where((c) => c != cat.value).toList();

      state = state.copyWith(selected: filtered);
    } else {
      List<String> selectedList = List.from(state.selected);
      selectedList.add(cat.value);
      state = state.copyWith(selected: selectedList);
    }
    return state.selected;
  }

  void selectAll() {
    state = state.copyWith(selected: []);
  }
}

final categoriesFilterWidgetVmProvider = StateNotifierProvider.family<
    CategoriesFilterWidgetVm, CategoryFilterState, String>(
  (ref, uniqueKey) => CategoriesFilterWidgetVm(ref),
);


import 'package:flutter_riverpod/flutter_riverpod.dart';


final selectedCategoryProvider = StateProvider<List<int>>((ref) => []);

class CategoriesFilterWidgetVm extends StateNotifier<void> {
  final Ref ref;
  CategoriesFilterWidgetVm(this.ref) : super(null);


  void updateSelectedCategory(int catId) {
    final selected = ref.read(selectedCategoryProvider);
    if (selected.any((i) => i == catId)) {
      ref.read(selectedCategoryProvider.notifier).state =
          selected.where((c) => c != catId).toList();
    } else {
      ref.read(selectedCategoryProvider.notifier).state = [...selected, catId];
    }
  }
}

final categoriesFilterWidgetVmProvider =
    StateNotifierProvider<CategoriesFilterWidgetVm, void>((ref) => CategoriesFilterWidgetVm(ref));

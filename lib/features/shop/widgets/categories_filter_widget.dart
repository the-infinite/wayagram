import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/shop/data/model/model.dart';
import 'package:wayagram/features/shop/widgets/widgets_vm/categories_filter_widget_vm.dart';
import 'package:gap/gap.dart';

class CategoriesFilterWidget<T> extends ConsumerStatefulWidget {
  final List<T> allItems;
  const CategoriesFilterWidget({super.key, required this.allItems});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoriesFilterWidgetState();
}

class _CategoriesFilterWidgetState
    extends ConsumerState<CategoriesFilterWidget> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(categoriesFilterWidgetVmProvider.notifier);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    // TODO: implement build
    return SizedBox(
      height: 45,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                const Gap(6),
                WayaButton(
                  callback: () {
                    viewModel.updateSelectedCategory(categories[index].id);
                  },
                  border: Border.all(
                      color: selectedCategory.contains(categories[index].id)
                          ? wayaTheme.colorScheme.customPrimary
                          : wayaTheme.colorScheme.greyColor300),
                  horizontalPadding: 8,
                  color: selectedCategory.contains(categories[index].id)
                      ? wayaTheme.colorScheme.primaryBrown50
                      : wayaTheme.colorScheme.transparent,
                  radius: 10,
                  height: 40,
                  centerWidget: Text(categories[index].category,
                      style: WayaTextStyles.hintStyle),
                ),
                const Gap(6),
              ],
            );
          }),
    );
  }
}

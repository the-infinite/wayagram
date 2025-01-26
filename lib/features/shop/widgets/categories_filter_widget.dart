import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/shop/widgets/widgets_vm/categories_filter_widget_vm.dart';
import 'package:gap/gap.dart';

class CategoriesFilterWidget extends ConsumerStatefulWidget {
  final Function(List<String> value) setCategory;
  final String uniqueKey;
  const CategoriesFilterWidget(
      {super.key, required this.setCategory, this.uniqueKey = ''});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoriesFilterWidgetState();
}

class _CategoriesFilterWidgetState
    extends ConsumerState<CategoriesFilterWidget> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel =
        ref.watch(categoriesFilterWidgetVmProvider(widget.uniqueKey));

    final categories = ref.watch(shopVmProvider).categories;

    // TODO: implement build
    return SizedBox(
      height: 45,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories!.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                const Gap(6),
                WayaButton(
                  callback: () {
                    final selected = ref
                        .read(categoriesFilterWidgetVmProvider(widget.uniqueKey)
                            .notifier)
                        .updateSelectedCategory(categories[index]);

                    widget.setCategory(selected);
                  },
                  border: Border.all(
                      color:
                          viewModel.selected.contains(categories[index].value)
                              ? wayaTheme.colorScheme.customPrimary
                              : wayaTheme.colorScheme.greyColor300),
                  horizontalPadding: 8,
                  color: viewModel.selected.contains(categories[index].value)
                      ? wayaTheme.colorScheme.primaryBrown50
                      : wayaTheme.colorScheme.transparent,
                  radius: 10,
                  height: 40,
                  centerWidget: Text(categories[index].label,
                      style: WayaTextStyles.hintStyle),
                ),
                const Gap(6),
              ],
            );
          }),
    );
  }
}

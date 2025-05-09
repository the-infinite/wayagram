import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final notifier =
        ref.read(categoriesFilterWidgetVmProvider(widget.uniqueKey).notifier);

    final categories = ref.watch(shopVmProvider).categories;

    if (categories == null) {
      return SizedBox.shrink();
    }

    return SizedBox(
      height: 45,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 1 + categories.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Row(
                children: [
                  const Gap(6),
                  WayaButton(
                      callback: () {
                        debugPrint("eveve");
                        notifier.selectAll();
                        //  widget.setCategory(['All']);
                      },
                      border: Border.all(
                          color: viewModel.selected.isEmpty ||
                                  viewModel.selected.contains('All')
                              ? wayaTheme.colorScheme.customPrimary
                              : wayaTheme.colorScheme.greyColor300),
                      horizontalPadding: 8,
                      color: viewModel.selected.isEmpty ||
                              viewModel.selected.contains('All')
                          ? wayaTheme.colorScheme.primaryBrown50
                          : wayaTheme.colorScheme.transparent,
                      radius: 10,
                      height: 40,
                      centerWidget: Text("All Categories",
                          style: WayaTextStyles.hintStyle)),
                  const Gap(6),
                ],
              );
            } else {
              return Row(
                children: [
                  WayaButton(
                    callback: () {
                      final selected = notifier
                          .updateSelectedCategory(categories[index - 1]);

                      widget.setCategory(selected);
                    },
                    border: Border.all(
                        color: viewModel.selected
                                .contains(categories[index - 1].value)
                            ? wayaTheme.colorScheme.customPrimary
                            : wayaTheme.colorScheme.greyColor300),
                    horizontalPadding: 8,
                    color:
                        viewModel.selected.contains(categories[index - 1].value)
                            ? wayaTheme.colorScheme.primaryBrown50
                            : wayaTheme.colorScheme.transparent,
                    radius: 10,
                    height: 40,
                    centerWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        WayaDp(
                          radius: 10,
                          image: categories[index - 1].image,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(categories[index - 1].label,
                            style: WayaTextStyles.hintStyle)
                      ],
                    ),
                  ),
                  const Gap(6),
                ],
              );
            }
          }),
    );
  }
}

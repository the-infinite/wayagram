import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_text_form_field.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/widgets/widgets_vm/filter_widget_vm.dart';

class FilterWidget<T> extends ConsumerStatefulWidget {
  final List<T> allItems;
  const FilterWidget({super.key, required this.allItems});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends ConsumerState<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(filterWidgetVmProvider);
    // TODO: implement build
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: context.width * 0.78,
            child: WayaTextFormField(
                padding: EdgeInsets.all(1),
                prefixIcon: Icon(
                  Icons.search,
                  color: wayaTheme.colorScheme.greyColor400,
                ),
                controller: viewModel.search,
                hintText: 'Search Shop'),
          ),
          const Gap(2),
          WayaButton(
            callback: () {
              WayaNav.toNamed('/filter');
            },
            centerWidget: Center(
              child: Icon(
                Icons.filter_list,
                size: 28,
                color: wayaTheme.colorScheme.customBlack,
              ),
            ),
            color: wayaTheme.colorScheme.transparent,
            height: 50,
            horizontalPadding: 8,
            border:
                Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
          )
        ],
      ),
    );
  }
}

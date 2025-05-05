import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_text_form_field.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/filter/views/filter_view.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';

//********* */
// NB: This filter shop is for shop use only.
//********* */
class FilterWidget extends ConsumerStatefulWidget {
  final String? hintText;
  final bool isPopFilter;
  final TextEditingController search;
  final void Function(String)? onTextChanged;
  final List<Product> products;

  // This is fine.
  const FilterWidget(
      {super.key,
      this.hintText = 'Search Shop',
      required this.search,
      this.isPopFilter = false,
      this.onTextChanged,
      this.products = const []});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends ConsumerState<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    // This one.
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //? If this is a popup filter.
          SizedBox(
            width:
                widget.isPopFilter ? context.width * 0.76 : context.width * 0.9,
            child: WayaTextFormField(
              padding: EdgeInsets.all(1),
              prefixIcon: Icon(
                Icons.search,
                color: wayaTheme.colorScheme.greyColor400,
              ),
              onChanged: widget.onTextChanged,
              controller: widget.search,
              hintText: widget.hintText!,
            ),
          ),

          //? This is hidden when  it is a popup filter.
          Visibility(
            visible: widget.isPopFilter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(2),
                WayaButton(
                  callback: () {
                    WayaNav.toNamed(FilterView.route,
                        arguments: widget.products);
                  },
                  centerWidget: Center(
                    child: Icon(
                      Icons.filter_list,
                      size: 28,
                      color: wayaTheme.colorScheme.customBlack,
                    ),
                  ),
                  color: wayaTheme.colorScheme.transparent,
                  height: 46,
                  horizontalPadding: 8,
                  border: Border.all(
                    width: 1,
                    color: wayaTheme.colorScheme.greyColor300,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

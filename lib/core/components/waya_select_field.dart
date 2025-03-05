import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/waya_dummy_input.dart';
import 'package:wayagram/core/components/waya_input_decorator.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

class WayaSelectField<T> extends ConsumerWidget {
  final String? label;
  final T? value;
  final double? height;
  final String hintText;
  final BorderRadius? radius;
  final List<Select> items;
  final Function(List<Select>) onSelected;
  final String uniqueKey;
  final bool multi;

  const WayaSelectField({
    super.key,
    required this.hintText,
    this.label,
    this.height = 48,
    required this.items,
    required this.onSelected,
    this.value,
    this.radius,
    this.uniqueKey = '',
    this.multi = false,
  });

  Select? _getPair(String value) {
    return items.where((item) => item.value == value).firstOrNull;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(wayaSelectFieldViewModelProvider(uniqueKey));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              label!,
              style: wayaTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: wayaTheme.colorScheme.greyColor900,
              ),
            ),
          ),
        AppTextField(
          textFieldType: TextFieldType.NAME,
          onTap: () => viewModel.selectValue(context, hintText, items, onSelected, multi),
          readOnly: true,
          decoration: inputDecoration(
            wayaTheme: wayaTheme,
            hintText: (value == null ||
                    value.toString().isEmpty ||
                    (value is List<Select> && (value as List<Select>).isEmpty))
                ? hintText
                : value is List<Select>
                    ? (value as List<Select>).map((e) => e.label).join(',')
                    : _getPair(value.toString())?.label ?? value as String,
            hintStyle: wayaTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: (value == null ||
                      value.toString().isEmpty ||
                      (value is List<Select> && (value as List<Select>).isEmpty))
                  ? wayaTheme.colorScheme.greyColor300
                  : wayaTheme.colorScheme.customBlack,
            ),
          ),
          suffix: Icon(
            Icons.arrow_drop_down,
            color: wayaTheme.colorScheme.greyColor300,
          ),
        ),
      ],
    );
  }
}

class WayaSelectFieldViewModel extends ChangeNotifier {
  final Ref ref;
  List<Select> selectedItems = [];

  WayaSelectFieldViewModel(this.ref);

  Future<void> selectValue(
      BuildContext context, String title, List<Select> items, Function(List<Select>) onSelected, bool multi) async {
    final result = await WayaUtils.showSelectModal(
      context: context,
      title: title,
      items: items,
      selectedItems: selectedItems,
      multi: multi,
    );

    selectedItems = result;

    onSelected(selectedItems);
    notifyListeners();
  }
}

final wayaSelectFieldViewModelProvider =
    ChangeNotifierProvider.family<WayaSelectFieldViewModel, String>((ref, uniqueKey) {
  return WayaSelectFieldViewModel(ref);
});

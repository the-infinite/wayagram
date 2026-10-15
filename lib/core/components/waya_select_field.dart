import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';
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
    final viewModel = ref.watch(wayaSelectFieldViewModelProvider(Uuid().v4()));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              label!,
              style: wayaTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                color: wayaTheme.colorScheme.greyColor900,
              ),
            ),
          ),
        AppTextField(
          textFieldType: TextFieldType.name,
          onTap: () => viewModel.selectValue(
              context, hintText, items, onSelected, multi),
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
              fontSize: 14.sp,
              color: (value == null ||
                      value.toString().isEmpty ||
                      (value is List<Select> &&
                          (value as List<Select>).isEmpty))
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

  Future<T> selectValue<T>(
    BuildContext context,
    String title,
    List<Select> items,
    FutureOr<T> Function(List<Select>) onSelected,
    bool multi, {
    String? subTitle,
    double? contextHeight,
  }) {
    final completer = Completer<T>();

    //? Then we do it like this.
    WayaUtils.showSelectModal(
      context: context,
      title: title,
      items: items,
      subTitle: subTitle,
      contextHeight: contextHeight,
      selectedItems: selectedItems,
      multi: multi,
    ).then(
      (result) async {
        selectedItems = result;
        final response = await onSelected(selectedItems);
        notifyListeners();
        completer.complete(response);
      },
    );

    //? Then send this one.
    return completer.future;
  }
}

final wayaSelectFieldViewModelProvider =
    ChangeNotifierProvider.family<WayaSelectFieldViewModel, String>(
  (ref, uniqueKey) => WayaSelectFieldViewModel(ref),
);

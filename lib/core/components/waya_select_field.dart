import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

class WayaSelectField extends ConsumerWidget {
  final String? label;
  final double? height;
  final String hintText;
  final BorderRadius? radius;
  final List<Select> items;
  final Function(Select value) onSelected;
  final String uniqueKey;

  const WayaSelectField(
      {super.key,
      required this.hintText,
      this.label,
      this.height = 48,
      required this.items,
      required this.onSelected,
      this.radius,
       this.uniqueKey = ''});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(wayaSelectFieldViewModelProvider(uniqueKey));
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(label!,
                style: Theme.of(context).textTheme.bodyMedium?.wayaCopyWith(
                      fontSize: 14,
                      color: wayaTheme.colorScheme.greyColor900,
                    )),
          ),
        WayaButton(
          callback: () {
            viewModel.selectValue(context, hintText, items, onSelected);
          },
          horizontalPadding: 0,
          color: wayaTheme.colorScheme.transparent,
          centerWidget: Focus(
              onFocusChange: (hasFocus) {
                viewModel.focusChange(hasFocus);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(viewModel.label.isEmpty ? hintText : viewModel.label,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.wayaCopyWith(
                              fontSize: 14,
                              color: viewModel.label.isEmpty
                                  ? wayaTheme.colorScheme.greyColor300
                                  : wayaTheme.colorScheme.customBlack,
                            )),
                    Icon(
                      Icons.arrow_drop_down,
                      color: wayaTheme.colorScheme.greyColor300,
                    )
                  ],
                ),
              )),
          border: Border.all(
              width: 1,
              color: viewModel.isFocused
                  ? wayaTheme.colorScheme.customPrimary
                  : wayaTheme.colorScheme.greyColor300),
        )
      ],
    );
  }
}

class WayaSelectFieldViewModel extends ChangeNotifier {
  final FocusNode _focusNode = FocusNode();
  final Ref ref;

  WayaSelectFieldViewModel(this.ref);
  String _label = '';

  bool _isFocused = false;

  bool get isFocused => _isFocused;
  String get label => _label;

  void focusChange(bool hasFocus) {
    _isFocused = hasFocus;
    notifyListeners();
  }

  Future<void> selectValue(BuildContext context, String title,
      List<Select> items, Function(Select value) onSelected) async {
    final result = await WayaUtils.showSelectModal(
        context: context, title: title, items: items);
    _label = result.label;
    onSelected(result);

    notifyListeners();
  }
}

final wayaSelectFieldViewModelProvider = ChangeNotifierProvider.family<WayaSelectFieldViewModel, String>((ref, uniqueKey) {
  return WayaSelectFieldViewModel(ref);
});

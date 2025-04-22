import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class WayaBottomSheetContent extends StatefulWidget {
  final double? contextHeight;
  final String title;
  final String? subTitle;
  final List<Select> items;
  final bool multi;
  final List<Select>? selectedItems;

  const WayaBottomSheetContent({
    super.key,
    this.contextHeight = 0.3,
    required this.items,
    required this.title,
    this.subTitle,
    this.selectedItems,
    this.multi = false,
  });

  @override
  State<StatefulWidget> createState() => _WayaBottomSheetContentState();
}

class _WayaBottomSheetContentState extends State<WayaBottomSheetContent> {
  late List<Select> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = widget.selectedItems ?? [];
  }

  void _toggleSelection(Select item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Container(
      height: widget.contextHeight ??
          context.height * (widget.contextHeight ?? 0.3),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.title, style: wayaTheme.textTheme.titleLarge),
                  if (widget.subTitle != null)
                    SizedBox(
                      width: context.width - 50,
                      child: Text(widget.subTitle ?? "",
                          style: wayaTheme.textTheme.hintStyleBold),
                    ),
                ],
              ),
              if (widget.multi)
                IconButton(
                  onPressed: () => WayaNav.goBack(result: _selectedItems),
                  icon: Icon(
                    Icons.close,
                    color: wayaTheme.colorScheme.greyColor400,
                    size: 20,
                  ),
                )
            ],
          ),
          const Gap(20),
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = _selectedItems.contains(item);

                return GestureDetector(
                  onTap: () {
                    if (widget.multi) {
                      _toggleSelection(item);
                    } else {
                      final isSelected = _selectedItems.contains(item);
                      WayaNav.goBack(
                          result: isSelected
                              ? [Select(label: '', value: '')]
                              : [item]);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.label,
                            style: wayaTheme.textTheme.labelMedium),
                        if (isSelected)
                          Icon(Icons.check,
                              color: wayaTheme.colorScheme.customBlack,
                              size: 18),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

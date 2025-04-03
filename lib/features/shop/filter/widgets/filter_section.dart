import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import '../widgets/filter_chip_item.dart';
import 'package:gap/gap.dart';

class FilterSection extends ConsumerStatefulWidget {
  final String title;
  final List<Select> options;
  final List<String> selectedOption;
  final Function(String) onOptionSelected;

  const FilterSection({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FilterSectionState();
}

class _FilterSectionState extends ConsumerState<FilterSection> {
  bool _showCollpase = true;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Gap(3),
            Expanded(
              child: Divider(
                color: wayaTheme.colorScheme.greyColor200,
                thickness: 1,
              ),
            ),
            if (_showCollpase)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showCollpase = !_showCollpase;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: wayaTheme.colorScheme.greyColor300, width: 1)),
                  child: Row(
                    children: [
                      Icon(Icons.keyboard_arrow_up),
                      const Gap(5),
                      Text(
                        "Collapse",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.customBlack,
                            fontSize: 14.sp),
                      )
                    ],
                  ),
                ),
              ),
            if (!_showCollpase)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showCollpase = !_showCollpase;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: wayaTheme.colorScheme.greyColor300, width: 1)),
                  child: Row(
                    children: [
                      Icon(Icons.keyboard_arrow_down),
                      const Gap(5),
                      Text("Enlarge",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.customBlack,
                              fontSize: 14.sp))
                    ],
                  ),
                ),
              )
          ],
        ),
        const Gap(12),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _showCollpase
              ? Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: widget.options.map((option) {
                    return FilterChipItem(
                      label: option.label,
                      isSelected: widget.selectedOption.contains(option.value),
                      onSelected: () => widget.onOptionSelected(option.value),
                    );
                  }).toList(),
                )
              : SizedBox.shrink(),
        )
      ],
    );
  }
}

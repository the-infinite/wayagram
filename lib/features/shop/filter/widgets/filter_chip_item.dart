import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';

class FilterChipItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const FilterChipItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    return FilterChip(
      label: Text(label),
      labelStyle: wayaTheme.textTheme.descriptionStyle,
      selected: isSelected,
      onSelected: (_) => onSelected(),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: wayaTheme.colorScheme.transparent,
      selectedColor: wayaTheme.colorScheme.primary50,
      showCheckmark: false,
      padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        
        side: BorderSide(
          color: isSelected
              ? wayaTheme.colorScheme.customPrimary
              : wayaTheme.colorScheme.greyColor300,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

class WayaShopTabButton extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback onTap;

  const WayaShopTabButton({
    super.key,
    required this.isSelected,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.greyColor300,
                width: isSelected ? 2 : 0.9,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.greyColor500,
            ),
          ),
        ),
      ),
    );
  }
}
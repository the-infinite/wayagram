import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

class WayaCustomIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const WayaCustomIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(pageCount, (index) {
        return Container(
          width: currentPage == index ? 28 : 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: currentPage == index ? wayaTheme.colorScheme.customPrimary : wayaTheme.colorScheme.primary75,
          ),
        );
      }),
    );
  }
}

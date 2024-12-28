import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

class WayaCustomIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;
  final double? height;
  final double? width;
  final double? currentWidth;

 const WayaCustomIndicator(
      {super.key,
      required this.currentPage,
      required this.pageCount,
      this.height = 6,
      this.currentWidth = 28,
      this.width = 6});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(pageCount, (index) {
        return Container(
          width: currentPage == index ? currentWidth : width,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: currentPage == index
                ? wayaTheme.colorScheme.customPrimary
                : wayaTheme.colorScheme.primary75,
          ),
        );
      }),
    );
  }
}

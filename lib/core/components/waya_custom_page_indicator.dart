import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/theme.dart';


class WayaCustomIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const WayaCustomIndicator({
    Key? key,
    required this.currentPage,
    required this.pageCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(pageCount, (index) {
        return Container(
          width:  currentPage == index ? 28 :6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color:
                currentPage == index ? WayaColors.customPrimary : WayaColors.primary75,
          ),
        );
      }),
    );
  }
}

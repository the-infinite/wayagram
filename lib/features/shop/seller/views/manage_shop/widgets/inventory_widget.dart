import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class InventoryWidget extends StatelessWidget {
  final String title;
  final Color color;
  final String metrics;

  const InventoryWidget({super.key, required this.metrics, required this.color, required this.title});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final screenWidth = context.width;

    final titlefontSize = screenWidth * 0.030;
    final metricFontSize = screenWidth * 0.050;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle().wayaCopyWith(
              color: wayaTheme.colorScheme.greyColor400,
              fontSize: titlefontSize,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Gap(10),
          Text(
            metrics,
            style: TextStyle().wayaCopyWith(
                color: wayaTheme.colorScheme.customBlack, fontWeight: FontWeight.w600, fontSize: metricFontSize),
          ),
        ],
      ),
    );
  }
}

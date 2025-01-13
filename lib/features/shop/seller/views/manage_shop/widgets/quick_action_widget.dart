import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class QuickActionWidget extends StatelessWidget {
  final String title;
  final Widget icon;
  final Color color;
  final VoidCallback onTap;
  final bool isStacked;
  final int? metric;

  const QuickActionWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.color,
      this.isStacked = false,
      this.metric = 0,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
        final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.030;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: 70,
                  width: 80,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(10)),
                  child: Center(child: icon),
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: Visibility(
                        visible: isStacked,
                        child: Container(
                            height: 18,
                            width: 18,
                            decoration: BoxDecoration(
                                color: wayaTheme.colorScheme.customPrimary,
                                shape: BoxShape.circle),
                            child: Center(
                              child: Text(
                                "$metric",
                                style: TextStyle().wayaCopyWith(
                                    color: wayaTheme.colorScheme.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                              ),
                            ))))
              ],
            ),
            const Gap(10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle().wayaCopyWith(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: wayaTheme.colorScheme.customBlack),
            )
          ],
        ),
      ),
    );
  }
}

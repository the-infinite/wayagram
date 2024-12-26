import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:gap/gap.dart';

class WayaCartIcon extends StatelessWidget {
  final int count;
  const WayaCartIcon({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Row(
      children: [
        Container(
          height: 35,
          padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
          decoration: BoxDecoration(
              color: wayaTheme.colorScheme.customPrimary,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart,
                    size: 22, color: wayaTheme.colorScheme.white),
                const Gap(5),
                Text(
                  "$count",
                  style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                )
              ],
            ),
          ),
        ),
        const Gap(15)
      ],
    );
  }
}

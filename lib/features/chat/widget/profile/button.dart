import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';

class ProfileActionButton extends StatelessWidget {
  final FutureOr<void> Function() onTap;
  final String icon;
  final String text;
  final bool isBad;

  //? This is fine.
  const ProfileActionButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text,
    this.isBad = false,
  });

  @override
  Widget build(BuildContext context) {
    //? First, our theme.
    final theme = Theme.of(context);

    //? Our component.
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          //? First, the icon.
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: isBad ? theme.colorScheme.error50 : theme.colorScheme.scaffoldColor,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(
                isBad ? theme.colorScheme.error : theme.colorScheme.customBlack,
                BlendMode.srcIn,
              ),
            ),
          ),
      
          // Some space.
          Gap(2.dg),
      
          //? Next, the title.
          Text(
            text,
            style: theme.textTheme.bodyXtraMedium.copyWith(
              color: isBad ? theme.colorScheme.error : theme.colorScheme.customBlack,
            ),
          ),
        ],
      ),
    );
  }
}

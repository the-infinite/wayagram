import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class EmptyState extends StatelessWidget {
  final Widget assetImage;
  final bool hasButton;
  final String message;
  final String? buttontext;
  final Widget? buttonTrailingIcon;
  final VoidCallback? onTap;
  const EmptyState(
      {super.key,
      required this.assetImage,
      this.onTap,
      this.buttonTrailingIcon,
      this.buttontext = '',
      this.hasButton = false,
      required this.message});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Gap(40),
        assetImage,
       
        const Gap(20),
        Text(
          message,
          textAlign: TextAlign.center,
          style: wayaTheme.textTheme.titleLarge,
        ),
        const Gap(25),
        if (hasButton)
          WayaButton(
            callback: onTap,
            color: wayaTheme.colorScheme.customPrimary,
            centerWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(buttonTrailingIcon != null) buttonTrailingIcon!,
                const Gap(6),
                Text(
                 buttontext!,
                  style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          )
      ],
    );
  }
}

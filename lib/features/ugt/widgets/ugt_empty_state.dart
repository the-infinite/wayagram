import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class UgtEmptyState extends StatelessWidget {
  final Widget icon;
  final String title;
  final String desc;
  final bool hideButton;
  final Widget? leadingButtonIcon;
  final VoidCallback onTap;
  final String buttonText;
  const UgtEmptyState(
      {super.key,
      required this.icon,
      required this.desc,
      required this.title,
      this.hideButton = false,
      required this.buttonText,
      required this.onTap,
      this.leadingButtonIcon});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return SizedBox(
      width: context.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const Gap(40),
          icon,
          const Gap(20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: wayaTheme.textTheme.titleLarge,
          ),
          const Gap(25),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: wayaTheme.textTheme.descriptionStyle,
          ),
          const Gap(25),
          if (hideButton)
            WayaButton(
              callback: onTap,
              centerWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                      visible: leadingButtonIcon != null,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          leadingButtonIcon ?? SizedBox.shrink(),
                          const Gap(6),
                        ],
                      )),
                  Text(
                    buttonText,
                    textAlign: TextAlign.center,
                    style: wayaTheme.textTheme.bodyMedium,
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}

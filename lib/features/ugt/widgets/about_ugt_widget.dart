import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';

class AboutUgtWidget extends StatelessWidget {
  final String title;
  final String content;
  const AboutUgtWidget({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: WayaTextStyles.bodySmall.wayaCopyWith(
                color: WayaColors.greyColor500, fontWeight: FontWeight.w400)),
        const Gap(5),
        SizedBox(
          width: context.width * 0.2,
          child: Text(content,
              style: wayaTheme.textTheme.bodySmall!
                  .copyWith(fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}

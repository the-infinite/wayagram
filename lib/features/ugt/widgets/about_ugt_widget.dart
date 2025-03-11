import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

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
            style:wayaTheme.textTheme.bodyMedium),
        const Gap(5),
        Text(content,
            style:wayaTheme.textTheme.bodyMedium),
      ],
    );
  }
}

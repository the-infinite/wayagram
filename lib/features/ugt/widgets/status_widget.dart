import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';

class StatusWidget extends StatelessWidget {
  final String title;
  final String content;
  const StatusWidget({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: WayaTextStyles.hintStyleBold),
        const Gap(5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.pendingColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(content, style: wayaTheme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}

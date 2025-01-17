import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class StatusWidget extends StatelessWidget {
  final String title;
  final String content;
  const  StatusWidget({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle().wayaCopyWith(
              color: Theme.of(context).colorScheme.greyColor300,
              fontSize: 13,
            )),
        const Gap(5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.pendingColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(content,
              style: TextStyle().wayaCopyWith(
                color: Theme.of(context).colorScheme.primary200,
                fontSize: 12,
              )),
        ),

      ],
    );
  }
}
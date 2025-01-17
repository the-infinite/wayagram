import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class StatusOngoing extends StatelessWidget {
  final String title;
  final String content;
  const  StatusOngoing({super.key, required this.title, required this.content});

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
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(content,
              style: TextStyle().wayaCopyWith(
                color: Theme.of(context).colorScheme.success700,
                fontSize: 12,
              )),
        ),

      ],
    );
  }
}
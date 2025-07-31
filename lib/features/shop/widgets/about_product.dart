import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class AboutProduct extends StatelessWidget {
  final String title;
  final String content;

  // Construct.
  const AboutProduct({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //? Section title.
        Text(
          title,
          style: wayaTheme.textTheme.descriptionStyle.copyWith(
            fontSize: context.width * 0.040,
            color: wayaTheme.colorScheme.greyColor400,
          ),
        ),

        // Some space.
        const Gap(5),

        //? Content.
        Text(
          content,
          style: wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
              color: wayaTheme.colorScheme.customBlack, fontSize: context.width * 0.040, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class AboutProductStatus extends StatelessWidget {
  final String title;
  final String content;
  final Color backgroundColor;
  final Color textColor;

  // Construct.
  const AboutProductStatus({
    super.key,
    required this.title,
    required this.content,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //? Section title.
        Text(
          title,
          style: wayaTheme.textTheme.descriptionStyle.copyWith(
            fontSize: context.width * 0.040,
            color: wayaTheme.colorScheme.greyColor400,
          ),
        ),

        // Some space.
        const Gap(5),

        //? Content.
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            content,
            style: wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
              color: textColor,
              fontSize: context.width * 0.035,
            ),
          ),
        ),
      ],
    );
  }
}

class AboutProductImage extends StatelessWidget {
  final String title;
  final List<File> content;

  // Construct.
  const AboutProductImage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //? Section title.
        Text(
          title,
          style: wayaTheme.textTheme.descriptionStyle.copyWith(
            fontSize: context.width * 0.040,
            color: wayaTheme.colorScheme.greyColor400,
          ),
        ),

        // Some space.
        const Gap(5),

        //? Content.
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: content.length,
          itemBuilder: (context, index) => ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: ColoredBox(
              color: Colors.black,
              child: Image.file(
                content[index],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutEvent extends StatelessWidget {
  final String title;
  final String content;
  final bool? isLink;

  const AboutEvent(
      {super.key, required this.title, required this.content, this.isLink});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: wayaTheme.textTheme.descriptionStyle.wayaCopyWith(
                fontSize: context.width * 0.040,
                color: wayaTheme.colorScheme.greyColor400)),
        const Gap(5),
        if (isLink == true) ...[
          GestureDetector(
            onTap: () async {
              final Uri url = Uri.parse(content);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text(content,
                style: TextStyle().wayaCopyWith(
                  color: wayaTheme.colorScheme.customPrimary,
                  fontSize: context.width * 0.035,
                )),
          ),
        ] else ...[
          Text(content,
              style: TextStyle().wayaCopyWith(
                color: wayaTheme.colorScheme.customBlack,
                fontSize: context.width * 0.035,
              )),
        ]
      ],
    );
  }
}

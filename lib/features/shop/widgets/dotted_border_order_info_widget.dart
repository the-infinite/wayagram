import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:gap/gap.dart';
class DottedBorderOrderInfoWidget extends StatelessWidget {
  final String title;
  final String description;

  const DottedBorderOrderInfoWidget(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return        DottedBorder(
            borderType: BorderType.RRect,
            color: wayaTheme.colorScheme.greyColor300,
            radius: Radius.circular(8),
            padding: EdgeInsets.all(14),
            dashPattern: [5, 5],
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.greyColor400,
                          fontSize: 13),
                    ),
                    const Gap(6),
                    Text(
                      description,
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.customBlack,
                          fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}

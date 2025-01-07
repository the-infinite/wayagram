import 'package:flutter/material.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class DisputeBuyerInfo extends StatelessWidget {
  const DisputeBuyerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Container(
      padding:  const EdgeInsets.fromLTRB(0,6, 0, 12),
      decoration:  BoxDecoration(
        border: Border(
          bottom: BorderSide(color: wayaTheme.colorScheme.greyColor300, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          WayaDp(
            radius: 20,
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fasas Oyewunmi',
                  style: wayaTheme.textTheme.bodyMedium,
                ),
                Text(
                  'Last seen today',
                  style: wayaTheme.textTheme.hintStyle,
                ),
              ],
            ),
          ),
          WayaButton(
            callback: () {},
            text: 'Mark As Resolved',
            height: 35,
            textStyle: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.white, fontSize: 12),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';

class DisputeBuyerInfo extends StatelessWidget {
  const DisputeBuyerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? The widget itself.
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: wayaTheme.colorScheme.greyColor300, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          //? The profile picture of the person you are talking to.
          WayaDp(
            radius: 20,
          ),

          // Some space.
          const Gap(12),

          //? The buyer details.
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

          //? Mark this dispute as resolved.
          WayaButton(
            callback: () {},
            text: 'Mark As Resolved',
            height: null,
            horizontalPadding: 10,
            verticalPadding: 4,
            textStyle: wayaTheme.textTheme.labelSmall?.copyWith(
              color: wayaTheme.colorScheme.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

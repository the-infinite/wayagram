import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class ContactSeller extends StatelessWidget {
  const ContactSeller({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
            left: Radius.circular(16), right: Radius.circular(16)),
      ),
      child: Column(
      
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Contact Seller",
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(12),
          Text(
            "To resolve this issue faster, we recommend contacting the seller first",
            textAlign: TextAlign.start,
            style: WayaTextStyles.descriptionStyle,
          ),
          const Gap(24),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.success,
                borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 2),
            child: Text(
              "Would you like to continue to chat with the seller?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: wayaTheme.colorScheme.primary600,
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const Gap(10),
          WayaButton(callback: () {}, text: "Yes, Contact Seller"),
          const Gap(10),
          WayaButton(
              callback: () {
                WayaNav.goBack();
              },
              textColor: wayaTheme.colorScheme.greyColor500,
              color: wayaTheme.colorScheme.transparent,
              border: Border.all(
                  color: wayaTheme.colorScheme.greyColor500, width: 1),
              text: 'Cancel')
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:wayagram/features/shop/shop_dispute/views/init_dispute.dart';

class ContactSeller extends StatelessWidget {
  final Order order;
  const ContactSeller({super.key, required this.order});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Contact Seller",
              textAlign: TextAlign.start,
              style: wayaTheme.textTheme.headlineMedium),
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
                color: wayaTheme.colorScheme.greyColor100,
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              "Most issues are resolved directly between buyers and sellers",
              style: wayaTheme.textTheme.hintStyle
                  .copyWith(color: wayaTheme.colorScheme.greyColor600),
            ),
          ),
          const Gap(10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.greyColor100,
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              "You have 14 days to resolve the issue before escalation",
              style: wayaTheme.textTheme.hintStyle
                  .copyWith(color: wayaTheme.colorScheme.greyColor600),
            ),
          ),
          const Gap(10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.greyColor100,
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              "If unresolved, you can escalate this to a dispute to our mediators",
              style: wayaTheme.textTheme.hintStyle
                  .copyWith(color: wayaTheme.colorScheme.greyColor600),
            ),
          ),
          const Gap(24),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.primary75.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            child: Text(
              "Would you like to continue to chat with the seller?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: wayaTheme.colorScheme.primary600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const Gap(10),
          WayaButton(
              callback: () {
                 WayaNav.goBack();
                WayaNav.toNamed(InitDispute.route, arguments: order);
               
              },
              text: "Yes, Contact Seller"),
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

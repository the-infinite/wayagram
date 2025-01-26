import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/shop/data/model/model.dart';
import 'package:wayagram/features/shop/order/widgets/order_info_widget.dart';

class DeliveryCostUpdate extends StatelessWidget {
  final List<Product> orders;
  final VoidCallback onPress;

  const DeliveryCostUpdate(
      {super.key, required this.onPress, required this.orders});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
          width: context.width,
          height: context.height * 0.8,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Delivery Cost Update",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(12),
                Text(
                  "Review the updated delivery cost and timeline provided by the seller.",
                  textAlign: TextAlign.start,
                  style: WayaTextStyles.descriptionStyle,
                ),
                const Gap(24),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.greyColor100,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/avatars.png",
                        width: 26,
                        height: 26,
                      ),
                      const Gap(6),
                      Text(
                        "Maleek Ventures",
                        style: wayaTheme.textTheme.labelMedium,
                      )
                    ],
                  ),
                ),
                const Gap(24),
                // ListView.builder(
                //     shrinkWrap: true,
                //     physics: const NeverScrollableScrollPhysics(),
                //     itemCount: 2,
                //     itemBuilder: (context, index) {
                //       return OrderedProductCard(order: orders[index]);
                //     }),
                const Gap(24),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: wayaTheme.colorScheme.greyColor200,
                        thickness: 1,
                      ),
                    ),
                    Gap(10),
                    Text(
                      "Delivery Price & Timeline",
                      style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                        color: wayaTheme.colorScheme.greyColor600,
                      ),
                    ),
                    Gap(10),
                    Expanded(
                      child: Divider(
                        color: wayaTheme.colorScheme.greyColor200,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const Gap(24),
                OrderInfoWidget(
                    title: 'Delivery Price', description: 'N 5,000'),
                const Gap(10),
                OrderInfoWidget(
                    title: 'Delivery Date', description: 'Jan 30th, 2024'),
                const Gap(10),
                OrderInfoWidget(
                    title: 'Delivery Address', description: 'Lekki, Lagos'),
                const Gap(24),
                WayaButton(
                    callback: () {
                      // Navigator.of(context).pop();
                      onPress();
                    },
                    text: "Accept Cost"),
                const Gap(10),
                WayaButton(
                    callback: () {
                      Navigator.of(context).pop();
                    },
                    textColor: wayaTheme.colorScheme.greyColor500,
                    color: wayaTheme.colorScheme.transparent,
                    border: Border.all(
                        color: wayaTheme.colorScheme.greyColor500, width: 1),
                    text: 'Decline Cost')
              ],
            ),
          )),
    );
  }
}

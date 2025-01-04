import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/widgets/order_info_widget.dart';

class DealApplicationStatus extends ConsumerStatefulWidget {
  const DealApplicationStatus({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DealApplicationStatusState();
}

class _DealApplicationStatusState extends ConsumerState<DealApplicationStatus> {
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
          height: context.height * 0.7,
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
                  "Application Status",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(12),
                Text(
                  "Stay updated with the progress of your Wayagram Deals \n application. Below are the details and current status of \n your submission",
                  textAlign: TextAlign.start,
                  style: WayaTextStyles.descriptionStyle,
                ),
                const Gap(24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AboutProductApplication(
                          title: 'Product Name', content: 'Itel Powerbank'),
                    ),
                    Expanded(
                      child: AboutProductApplication(
                          title: 'Product Category', content: 'Skin Care'),
                    ),
                    Expanded(
                      child: AboutProductApplication(
                          title: 'PickUp Type', content: 'Cosmetics'),
                    )
                  ],
                ),
                const Gap(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AboutProductApplication(
                          title: 'Price Per Unit', content: 'N 24,000'),
                    ),
                    Expanded(
                      child: AboutProductApplication(
                          title: 'SUbmission Date',
                          content: 'October 14, 2024'),
                    ),
                    Expanded(
                      child: AboutProductApplication(
                          title: 'Application Status', content: 'pending'),
                    )
                  ],
                ),
                const Gap(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AboutProductApplication(
                          title: 'Pickup Address',
                          content: '62 Lekki Expressway, Lagos'),
                    ),
                    Expanded(
                      child: AboutProductApplication(
                          title: 'Warehouse Address',
                          content: '62 Lekki Expressway, Lagos'),
                    ),
                    Expanded(
                      child: AboutProductApplication(
                          title: 'Shop Address',
                          content: '62 Lekki Expressway, Lagos'),
                    )
                  ],
                ),
                const Gap(40),
                WayaButton(
                    callback: () {
                      WayaNav.toNamed('/waya-application-product-detail');
                    },
                    text: "View Product Details"),
                const Gap(10),
                WayaButton(
                    callback: () {
                      Navigator.of(context).pop();
                    },
                    color: wayaTheme.colorScheme.greyColor300,
                    text: 'Go Back')
              ],
            ),
          )),
    );
  }
}

class AboutProductApplication extends StatelessWidget {
  final String title;
  final String content;

  const AboutProductApplication(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.descriptionStyle),
        const Gap(5),
        Text(content,
            style: TextStyle().wayaCopyWith(
              color: Theme.of(context).colorScheme.customBlack,
              fontSize: 15,
            )),
      ],
    );
  }
}

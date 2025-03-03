import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:uuid/uuid.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/seller/data/model/add_product_state.dart';
import 'package:wayagram/features/shop/seller/views/add_product/add_product.dart';

class WayaDealAd extends ConsumerWidget {
  static const route = '/waya-deal-ad';
  const WayaDealAd({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: 'WayaGram Deals',
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("WayaGram Deals", style: wayaTheme.textTheme.titleLarge),
            const Gap(3),
            Text(
              'List your products at a 50% discount and receive \n 100% of the full price from WayaGram!',
              style: wayaTheme.textTheme.hintStyle,
            ),
            const Gap(30),
            Image.asset('assets/images/waya_deal_ad.png'),
            const Gap(10),
            Text(
              "How it Works?",
              style: TextStyle().wayaCopyWith(
                  color: wayaTheme.colorScheme.customBlack,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
            const Gap(10),
            AdList(
              icon: SvgPicture.asset(
                'assets/icons/deal-icon.svg',
                width: 22,
              ),
              title: 'List at 50% discount',
              desc:
                  'Offer your products at half the price to attract more buyers \n and increase visibility in the exclusive WayaGram Deal.',
            ),
            const Gap(10),
            AdList(
              icon: SvgPicture.asset(
                'assets/icons/check-icon.svg',
                width: 22,
              ),
              title: 'Submit for Admin Approval',
              desc:
                  "Fill out the deal form, and we'll review your submission \n to ensure it meets the deal criteria.",
            ),
            const Gap(10),
            AdList(
              icon: SvgPicture.asset(
                'assets/icons/money-icon.svg',
                width: 22,
              ),
              title: 'Get paid full price',
              desc:
                  "Once your product sells, you'll receive the full original price, \n even though buyers pay only 50%.",
            ),
            const Gap(30),
            WayaButton(
              callback: () {
                WayaNav.toNamed(AddProduct.route,
                    arguments: AddWayagramArg(
                        uniqueKey: Uuid().v4(), isWayagram: true));
              },
              text: 'Participate',
            )
          ],
        ));
  }
}

class AdList extends StatelessWidget {
  final String desc;
  final String title;
  final Widget icon;
  const AdList(
      {super.key, required this.desc, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            const Gap(6),
            Text(
              title,
              style: TextStyle().wayaCopyWith(
                  color: wayaTheme.colorScheme.customBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const Gap(6),
        Text(
          desc,
          style: wayaTheme.textTheme.hintStyle,
        ),
      ],
    );
  }
}

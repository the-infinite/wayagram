import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/quotation/vm/quotation_vm.dart';

class RequestCard extends StatelessWidget {
  final Quotation quotation;
  const RequestCard({super.key, required this.quotation});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.white,
            borderRadius: BorderRadius.circular(16),
            border:
            Border.all(color: wayaTheme.colorScheme.greyColor200, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 110,
                    decoration: BoxDecoration(
                        color: wayaTheme.colorScheme.success50,
                        borderRadius: BorderRadius.circular(40)),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/b-bid.svg',
                          colorFilter: ColorFilter.mode(
                              wayaTheme.colorScheme.success, BlendMode.srcIn),
                        ),
                        const Gap(5),
                        Text(
                          "Open Bid",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.success,
                              fontSize: 14),
                        )
                      ],
                    ),
                  ),
                  const Gap(10),
                  Text(quotation.category, style: wayaTheme.textTheme.hintStyle)
                ],
              ),
              const Gap(20),
              Text(
                quotation.name,
                style: wayaTheme.textTheme.titleLarge,
              ),
              const Gap(20),
              Text(
                quotation.description,
                style: wayaTheme.textTheme.descriptionStyle,
              ),
              const Gap(20),
              RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Time Remaining | ',
                        style: wayaTheme.textTheme.hintStyle),
                    TextSpan(
                        text: quotation.timeLeft,
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.customPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400)),
                  ])),
              const Gap(10),
              RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Starting Price : ',
                        style: wayaTheme.textTheme.hintStyle),
                    TextSpan(
                        text: '₦ 1,500,000.00',
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  ])),
              const Gap(20),
              WayaButton(
                centerWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Place Bid",
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.customPrimary, fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ],
                ),
                callback: () {
                  WayaNav.toNamed('/seeSeller-bids');
                },
                color: wayaTheme.colorScheme.primar50,
              ),

            ],
          ),
        ),
        const Gap(30)
      ],
    );
  }
}

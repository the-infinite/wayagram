import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/quotation/vm/quotation_vm.dart';

class QuotationCard extends StatelessWidget {
  final Quotation quotation;
  const QuotationCard({super.key, required this.quotation});

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
            border: Border.all(color: wayaTheme.colorScheme.greyColor200, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              quotation.images.isEmpty
                  ? Container(
                      height: 140,
                      decoration: BoxDecoration(
                          color: wayaTheme.colorScheme.greyColor100, borderRadius: BorderRadius.circular(8)),
                    )
                  : quotation.images.length == 1
                      ? Container(
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage(quotation.images[0]),
                              scale: 2,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1.3,
                          children: [
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(quotation.images[0]),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(quotation.images[1]),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Text(
                                  "+${quotation.images.length - 1}",
                                  style: TextStyle().wayaCopyWith(
                                      color: wayaTheme.colorScheme.white, fontSize: 50, fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: wayaTheme.colorScheme.success50, borderRadius: BorderRadius.circular(40)),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/b-bid.svg',
                              colorFilter: ColorFilter.mode(wayaTheme.colorScheme.success, BlendMode.srcIn),
                            ),
                            const Gap(5),
                            Text(
                              "Open Bid",
                              style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.success, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                      const Gap(10),
                      Text(quotation.category, style: wayaTheme.textTheme.hintStyle)
                    ],
                  ),
                  WayaButton(
                    callback: () {},
                    height: 60,
                    centerWidget: Center(
                      child: Icon(
                        Icons.add,
                        color: wayaTheme.colorScheme.white,
                        size: 50,
                      ),
                    ),
                  )
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
                TextSpan(text: 'Time Remaining | ', style: wayaTheme.textTheme.hintStyle),
                TextSpan(
                    text: quotation.timeLeft,
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.customPrimary, fontSize: 14, fontWeight: FontWeight.w400)),
              ])),
              const Gap(20),
              WayaButton(
                callback: () {},
                text: 'Place Bid',
                height: 48,
              )
            ],
          ),
        ),
        const Gap(30)
      ],
    );
  }
}

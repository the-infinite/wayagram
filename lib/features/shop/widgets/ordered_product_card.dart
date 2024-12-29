import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/shop/cart/data/model.dart';

import 'package:wayagram/features/shop/data/model/model.dart';


class OrderedProductCard extends StatelessWidget {
  final Cart order;
  const OrderedProductCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(8,2,8,2),
          decoration: BoxDecoration(
              border: Border.all(
                  color: wayaTheme.colorScheme.greyColor300, width: 1),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  order.images.isEmpty
                      ? Container(
                          height: 70,
                          width: 50,
                          decoration: BoxDecoration(
                              color: wayaTheme.colorScheme.greyColor100,
                              borderRadius: BorderRadius.circular(8)),
                        )
                      : WayaImage(imageUrl: order.images[0], height: 70, width: 
                      50, fit: BoxFit.contain, radius: BorderRadius.circular(8),),
                  const Gap(5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    SizedBox(
                      width: context.width * 0.3,
                      child:   Text(
                        "Itel Powerbank 60,000mah Fast charging",
                        style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.customBlack, fontWeight: FontWeight.w500, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                      const Gap(5),
                      Text(
                        "Quantity: 1 x N5,000",
                        style: wayaTheme.textTheme.hintStyle,
                      )
                    ],
                  )
                ],
              ),
              Text(
                "N 3,000",
                style: wayaTheme.textTheme.bodyXtraMedium,
              )
            ],
          ),
        ),
        const Gap(10),
      ],
    );
  }
}

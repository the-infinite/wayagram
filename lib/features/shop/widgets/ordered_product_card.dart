import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/cart/data/model/cart_product.dart';

class OrderedProductCard extends StatelessWidget {
  final CartProduct orders;
  const OrderedProductCard({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
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
                  WayaImage(
                    imageUrl: orders.productImage ?? '',
                    height: 70,
                    width: 50,
                    fit: BoxFit.contain,
                    radius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  const Gap(5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.3,
                        child: Text(
                          orders.productName,
                          style: TextStyle(
                              color: wayaTheme.colorScheme.customBlack,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Gap(5),
                      SizedBox(
                        width: width * 0.4,
                        child: Text(
                          "Quantity: ${orders.quantity} x ${WayaHelpers.formatPrice(double.parse(orders.unitPrice ?? '').toInt())}",
                          style: wayaTheme.textTheme.hintStyle,
                        ),
                      )
                    ],
                  )
                ],
              ),
              Text(
                WayaHelpers.formatPrice(orders.price),
                style: wayaTheme.textTheme.bodyXtraMedium
                    .copyWith(fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        const Gap(10),
      ],
    );
  }
}

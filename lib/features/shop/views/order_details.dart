import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/buyer/views/all_orders.dart';
import 'package:wayagram/features/shop/cart/vm/cart_vm.dart';
import 'package:wayagram/features/shop/widgets/copy_code.dart';
import 'package:wayagram/features/shop/widgets/order_tracking.dart';
import 'package:wayagram/features/shop/widgets/ordered_product_card.dart';

class OrderDetails extends ConsumerWidget {
  const OrderDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: "Order Details",
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Details", style: wayaTheme.textTheme.bodyMedium),
            const Gap(10),
            CopyCode(code: "#423523232", title: "Order Details"),
            const Gap(25),
            Text("Product Ordered", style: wayaTheme.textTheme.bodyMedium),
            const Gap(10),
            // ListView.builder(
            //     shrinkWrap: true,
            //     physics: const NeverScrollableScrollPhysics(),
            //     itemCount: 2,
            //     itemBuilder: (context, index) {
            //       return OrderedProductCard(order: orders[index]);
            //     }),
            const Gap(25),
            Container(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: wayaTheme.colorScheme.greyColor300, width: 1),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/icons/map.svg'),
                  const Gap(5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pickup Address",
                          style: wayaTheme.textTheme.bodyMedium),
                      const Gap(5),
                      SizedBox(
                        width: context.width * 0.8,
                        child: Text(
                          "62, Lekki - Epe Express way, off Ita opo building, Lagos State",
                          style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.greyColor500,
                            fontSize: 13,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            const Gap(25),
            Text("Token", style: wayaTheme.textTheme.bodyMedium),
            const Gap(10),
            CopyCode(code: "232-343-353", title: "Delivery Confirmation Token"),
            const Gap(25),
            Text("Delivery Progress", style: wayaTheme.textTheme.bodyMedium),
            const Gap(10),
            OrderTracking(),
            const Gap(25),
            WayaButton(
              callback: () {
                WayaNav.toNamed('/confirm-order-delivery');
              },
              text: "Confirm Order Delivery",
            )
          ],
        ));
  }
}

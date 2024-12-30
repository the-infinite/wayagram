import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/shop/buyer/views/all_orders.dart';
import 'package:wayagram/features/shop/cart/vm/checkout_vm.dart';
import 'package:wayagram/features/shop/widgets/ordered_product_card.dart';

class Checkout extends ConsumerWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(checkoutVmProvider);
    return WayaScaffold(
      title: "Checkout",
      isLoading: false,
      isScrollable: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
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
          Text("Product Ordered", style: wayaTheme.textTheme.bodyMedium),
          const Gap(10),
          // ListView.builder(
          //     shrinkWrap: true,
          //     physics: const NeverScrollableScrollPhysics(),
          //     itemCount: 2,
          //     itemBuilder: (context, index) {
          //       return OrderedProductCard(order: orders[index]);
          //     }),
          //const Gap(25),
          Text("Cost Breakdown", style: wayaTheme.textTheme.bodyMedium),
          const Gap(10),
          DottedBorder(
            borderType: BorderType.RRect,
            color: wayaTheme.colorScheme.greyColor300,
            radius: Radius.circular(8),
            padding: EdgeInsets.all(14),
            dashPattern: [5, 5],
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: SizedBox(
                width: double.infinity,
             
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Sub Total",
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.greyColor400,
                          fontSize: 13),
                    ),
                    const Gap(6),
                    Text(
                      "N 175,000",
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.customBlack,
                          fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Gap(10),
          DottedBorder(
            borderType: BorderType.RRect,
            color: wayaTheme.colorScheme.greyColor300,
            radius: Radius.circular(8),
            padding: EdgeInsets.all(14),
            dashPattern: [5, 5],
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Delivery Charges",
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.greyColor400,
                          fontSize: 13),
                    ),
                    const Gap(6),
                    Text(
                      "N 5,000",
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.customBlack,
                          fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Gap(10),
          DottedBorder(
            borderType: BorderType.RRect,
            color: wayaTheme.colorScheme.greyColor300,
            radius: Radius.circular(8),
            padding: EdgeInsets.all(14),
            dashPattern: [5, 5],
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.greyColor400,
                          fontSize: 13),
                    ),
                    const Gap(6),
                    Text(
                      "N 180,000",
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.customBlack,
                          fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Gap(25),
          Text("Payment Method", style: wayaTheme.textTheme.bodyMedium),
          const Gap(10),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.scaffoldColor,
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/wallet-icon.svg'),
                    const Gap(8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Wayagram Wallet",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.customBlack,
                              fontSize: 16),
                        ),
                        const Gap(6),
                        Text(
                          "This transaction will be deducted from \n your wallet  balance",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.greyColor400,
                              fontSize: 14),
                        )
                      ],
                    )
                  ],
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          width: 1,
                          color: wayaTheme.colorScheme.customPrimary)),
                  child: Center(
                      child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.customPrimary,
                      shape: BoxShape.circle,
                    ),
                  )),
                )
              ],
            ),
          )
        ],
      ),
      /**

       */
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: context.width * 0.35,
                height: 50,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Positioned(
                      top: 8,
                      child: Text(
                        "Total",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.greyColor500,
                            fontWeight: FontWeight.normal,
                            fontSize: 14),
                      ),
                    ),
                    Positioned(
                        top: 25,
                        child: Text(
                          "N 180,000",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.customBlack,
                              fontSize: 18),
                        ))
                  ],
                )),
            SizedBox(
              width: context.width * 0.45,
              child: WayaButton(
                callback: () {
                  viewModel.checkout(context);
                },
                text: 'CheckOut',
              ),
            )
          ],
        ),
      ),
    );
  }
}

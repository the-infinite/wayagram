import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/quotation/buyer/vm/buyer_checkout_vm.dart';
import 'package:wayagram/features/shop/widgets/about_product.dart';

class BuyerCheckout extends ConsumerStatefulWidget {
  static const route = '/buyer-checkout';
  const BuyerCheckout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BuyerCheckoutState();
}

class _BuyerCheckoutState extends ConsumerState<BuyerCheckout> {
  bool payWithWallet = false;
  bool payWithWayaQuick = false;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(buyerCheckoutVmProvider);
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
                border: Border.all(color: wayaTheme.colorScheme.greyColor300, width: 1),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaAssets.icons.map.svg(),

                // Some space.
                const Gap(5),

                //? The delivery address
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Delivery Address", style: wayaTheme.textTheme.bodyMedium),
                    const Gap(5),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "62, Lekki - Epe Express way, off Ita opo building,\nLagos State",
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
          const Gap(30),
          AboutProduct(title: 'Product Name', content: 'Samsung S24 Ultra'),
          const Gap(15),
          AboutProduct(title: 'Brand Name', content: 'Samsung'),
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AboutProduct(title: 'Product Category', content: 'Technology'),
              ),
              Expanded(
                child: AboutProduct(title: 'Product Condition', content: 'Fairly Used'),
              )
            ],
          ),
          const Gap(15),
          AboutProduct(
              title: 'Product Description', content: 'Samsung S22 Ultra 5G Fairly Used in good condition. Graphite'),
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AboutProduct(title: 'Quantity', content: '1'),
              ),
              Expanded(
                flex: 2,
                child: AboutProduct(title: 'State of Purchase', content: 'Lagos State'),
              ),
              Expanded(
                child: AboutProduct(title: 'LGA', content: 'Alimosho'),
              )
            ],
          ),
          const Gap(15),
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
                      "Bid Amount",
                      style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.greyColor400, fontSize: 13),
                    ),
                    const Gap(6),
                    Text(
                      "N 175,000.00",
                      style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.customBlack, fontSize: 14),
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
                      style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.greyColor400, fontSize: 13),
                    ),
                    const Gap(6),
                    Text(
                      "N 5,000.00",
                      style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.customBlack, fontSize: 14),
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
                      style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.greyColor400, fontSize: 13),
                    ),
                    const Gap(6),
                    Text(
                      "N 180,000.00",
                      style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.customBlack, fontSize: 18),
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
            decoration:
                BoxDecoration(color: wayaTheme.colorScheme.scaffoldColor, borderRadius: BorderRadius.circular(8)),
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
                          style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.customBlack, fontSize: 16),
                        ),
                        const Gap(6),
                        Text(
                          "This transaction will be deducted from \n your wallet  balance",
                          style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.greyColor400, fontSize: 14),
                        )
                      ],
                    )
                  ],
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        payWithWallet = true;
                        payWithWayaQuick = false;
                      });
                    },
                    child: payWithWallet
                        ? Image.asset(
                            'assets/images/polls/check.png',
                            height: 20.h,
                          )
                        : Image.asset(
                            'assets/images/polls/uncheck.png',
                            height: 20.h,
                          ))
                /* Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, border: Border.all(width: 1, color: wayaTheme.colorScheme.customPrimary)),
                  child: Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: wayaTheme.colorScheme.customPrimary,
                          shape: BoxShape.circle,
                        ),
                      )),
                )*/
              ],
            ),
          ),
          const Gap(10),
          Container(
            padding: EdgeInsets.all(10),
            decoration:
                BoxDecoration(color: wayaTheme.colorScheme.scaffoldColor, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/quick-icon.svg'),
                    const Gap(8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pay With Wayaquick",
                          style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.customBlack, fontSize: 16),
                        ),
                        const Gap(6),
                        Text(
                          "Pay with waya’s payment gateway",
                          style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.greyColor400, fontSize: 14),
                        )
                      ],
                    )
                  ],
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        payWithWallet = false;
                        payWithWayaQuick = true;
                      });
                    },
                    child: payWithWayaQuick
                        ? Image.asset(
                            'assets/images/polls/check.png',
                            height: 20.h,
                          )
                        : Image.asset(
                            'assets/images/polls/uncheck.png',
                            height: 20.h,
                          ))
                /* Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300)),
                )*/
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
                            color: wayaTheme.colorScheme.greyColor500, fontWeight: FontWeight.normal, fontSize: 14),
                      ),
                    ),
                    Positioned(
                        top: 25,
                        child: Text(
                          "N 180,000",
                          style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.customBlack, fontSize: 18),
                        ))
                  ],
                )),
            SizedBox(
              width: 40.w,
            ),
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

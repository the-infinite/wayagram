import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/seller/views/dialogs/add_delivery_details.dart';

class SingleSeeBidWidget extends ConsumerWidget {
  final bool isSeller;
  const SingleSeeBidWidget({super.key, this.isSeller = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        // if (isSeller) {
        //   WayaNav.toNamed('/seller-bid-details', arguments: "id");
        //   //viewModel.sellerBidAction(context);
        // } else {
        //   WayaNav.toNamed('/seller-bid-details', arguments: "id");
        // }
      },
      child:
      Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
            decoration: BoxDecoration(
              color: wayaTheme.colorScheme.scaffoldColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/bid/store.png',
                      height: 48,
                    ),
                    const Gap(10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
                                decoration: BoxDecoration(
                                  color: wayaTheme.colorScheme.success,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/bid/down.png', height: 10),
                                    const Gap(5),
                                    Text(
                                      "Open Bid",
                                      style: TextStyle().wayaCopyWith(
                                        color: wayaTheme.colorScheme.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
                                decoration: BoxDecoration(
                                  color: wayaTheme.colorScheme.primar50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/bid/clock.png', height: 16),
                                    Text(
                                      "12m:00s",
                                      style: TextStyle().wayaCopyWith(
                                        color: wayaTheme.colorScheme.primary600,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Gap(8),
                          Text(
                            "Samsung S24 Ultra",
                            style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.customBlack,
                              fontSize: 14,
                            ),
                          ),
                          const Gap(8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Rufai Maleek ',
                                  style: TextStyle().wayaCopyWith(
                                    color: wayaTheme.colorScheme.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Fairly Used ',
                                  style: TextStyle().wayaCopyWith(
                                    color: WayaColors.greyColor400,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                // TextSpan(
                                //   text: 'Fairly Used ',
                                //   style: wayaTheme.textTheme.hintStyle,
                                // ),
                                TextSpan(
                                  text: '2Km Away',
                                  style: TextStyle().wayaCopyWith(
                                    color: WayaColors.greyColor400,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(10),

                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 1, color: WayaColors.greyColor100,),
                const Gap(10),
                Row(
                  children: [
                    Text(
                      "₦ 19,000.00",
                      style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.customBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: context.width * 0.45,
                      child: WayaButton(
                        callback: () {},

                        text: 'Place Bid',
                        height: 38,
                      ),
                    ),
                    // WayaButton(
                    //   callback: () {},
                    //   text: 'Place Bid',
                    //   height: 36,
                    // ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(10),
        ],
      )
      /*  Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
              decoration: BoxDecoration(
                  color: wayaTheme.colorScheme.scaffoldColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [

                      const Gap(4),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/bid/store.png', height: 48,),
                              const Gap(10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
                                        decoration: BoxDecoration(
                                            color: wayaTheme.colorScheme.success,
                                            borderRadius: BorderRadius.circular(6)),
                                        child: Row(
                                          children: [
                                            Image.asset('assets/images/bid/down.png', height: 16.h,),
                                            const Gap(5),
                                            Text(
                                              "Open Bid",
                                              style: TextStyle().wayaCopyWith(
                                                  color: wayaTheme.colorScheme.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Gap(120),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
                                        decoration: BoxDecoration(
                                            color: wayaTheme.colorScheme.primar50,
                                            borderRadius: BorderRadius.circular(6)),
                                        child: Row(
                                          children: [
                                            Image.asset('assets/images/bid/clock.png', height: 16.h,),
                                            Text(
                                              "12m:00s",
                                              style: TextStyle().wayaCopyWith(
                                                  color: wayaTheme.colorScheme.primary600,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Samsung S24 Ultra",
                                    style: TextStyle().wayaCopyWith(
                                        color: wayaTheme.colorScheme.customBlack,
                                        fontSize: 14),
                                  ),
                                ],),
                            ],
                          ),
                          const Gap(8),
                          Padding(
                            padding: const EdgeInsets.only(left: 58),
                            child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: 'Rufai Maleek ',
                                      style: TextStyle().wayaCopyWith(
                                          color: wayaTheme.colorScheme.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400)),

                                  TextSpan(
                                      text: 'Fairly Used ',
                                      style: wayaTheme.textTheme.hintStyle),
                                  TextSpan(
                                      text: '2Km Away',
                                      style: TextStyle().wayaCopyWith(
                                          color: WayaColors.greyColor400,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400)),
                                ])),
                          ),
                          const Gap(10),
                          Divider(color:wayaTheme.colorScheme.customBlack, thickness: 2.0,),
                          const Gap(10),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Row(children: [
                              Text(
                                "₦ 19,000.00",
                                style: TextStyle().wayaCopyWith(
                                    color: wayaTheme.colorScheme.customBlack,
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              //const Gap(80),
                              const Spacer(),
                              WayaButton(
                                callback: () {},
                                text: '       Place Bid       ',
                                height: 38,

                              )
                            ],),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Gap(10),
                ],
              ),
            ),
            const Gap(10)
          ],
        )*/
    );
  }
}

class SingleBidWidgetViewModel extends ChangeNotifier {
  final Ref ref;
  SingleBidWidgetViewModel(this.ref);

  Future<void> addDeliveryDetail(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddDeliveryDetails();
        });
  }

  Future<void> sellerBidAction(BuildContext context) async {
    WayaUtils.showNotice(
        context: context,
        buttonText: 'Add Delivery Details',
        secondButtonText: 'See your Order Details',
        title: 'Populate Delivery Details',
        message:
        "Add the delivery price and date of delivery for this order so the \n customer can review and pay",
        onPress: () async {
          await addDeliveryDetail(context);
        },
        onCancel: () {
          WayaNav.toNamed('/seller-bid-details', arguments: "id");
        },
        icon: Image.asset('assets/images/shop/delivery-van.png'));
  }
}

final singleSettlementWidgetViewModelProvider =
ChangeNotifierProvider<SingleBidWidgetViewModel>(
        (ref) => SingleBidWidgetViewModel(ref));

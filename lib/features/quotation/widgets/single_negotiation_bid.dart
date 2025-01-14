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
import 'package:wayagram/features/quotation/buyer/vm/reject_bid_vm.dart';
import 'package:wayagram/features/quotation/quotation_bottomsheet_modal/quotation_modal.dart';
import 'package:wayagram/features/shop/seller/views/dialogs/add_delivery_details.dart';

class SingleNegotiationBidWidget extends ConsumerWidget {
  final bool isSeller;
  const SingleNegotiationBidWidget({super.key, this.isSeller = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(rejectBidVmProvider);
    return GestureDetector(
        onTap: () {
          // if (isSeller) {
          //   WayaNav.toNamed('/seller-bid-details', arguments: "id");
          //   //viewModel.sellerBidAction(context);
          // } else {
          //   WayaNav.toNamed('/seller-bid-details', arguments: "id");
          // }
        },
        child: Column(
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
                                      Image.asset('assets/images/bid/down.png', height: 10.h),
                                      //Image.asset('assets/images/bid/check.png', height: 9.h, width: 9.w,),
                                      const Gap(5),
                                      Text(
                                        "New Bid",
                                        style: TextStyle().wayaCopyWith(
                                          color: wayaTheme.colorScheme.white,
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
                              "SURAJ STORES",
                              style: TextStyle().wayaCopyWith(
                                color: wayaTheme.colorScheme.customBlack,
                                fontSize: 14,
                              ),
                            ),
                            const Gap(8),
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '15min ',
                                        style: TextStyle().wayaCopyWith(
                                          color: wayaTheme.colorScheme.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '2km ',
                                        style: TextStyle().wayaCopyWith(
                                          color: WayaColors.greyColor400,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                Row(children: [
                                  Image.asset('assets/images/bid/star.png', height: 16.h, width: 16.w,),
                                  Text(
                                    " 4.5 (250 reviews)",
                                    style: TextStyle().wayaCopyWith(
                                      color: WayaColors.greyColor400,
                                      //color: wayaTheme.colorScheme.,
                                      fontSize: 12,
                                    ),
                                  ),


                                ],)
                              ],
                            ),
                            const Gap(10),


                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1, color: WayaColors.greyColor100,),
                  const Gap(10),
                  Text(
                    "₦ 19,000.00",
                    style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.customBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(10),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: context.width * 0.45,
                          child: WayaButton(
                            callback: () {
                              viewModel.rejectBid(context);
                            },
                            text: 'Decline',
                            height: 38,
                            color: WayaColors.error500 ,
                          ),
                        ),
                        SizedBox(width: 5.w,),
                        SizedBox(
                          width: context.width * 0.45,
                          child: WayaButton(
                            callback: () {
                              // WayaUtils.showModalSheetQuotation(
                              //   context,
                              //   child: BidWonModal(),
                              // );
                            },
                            text: 'Negotiate',
                            height: 38,
                            color: WayaColors.greyColor400,
                          ),
                        ),
                        SizedBox(width: 5.w,),
                        SizedBox(
                          width: context.width * 0.45,
                          child: WayaButton(
                            callback: () {
                              WayaUtils.showModalSheetQuotation(
                                context,
                                child: QuotationModal(),
                              );
                            },

                            text: 'Accept',
                            height: 38,
                          ),
                        ),
                      ],),
                  )

                ],
              ),
            ),

            const Gap(10),
          ],
        ),
    );
  }
}



class SingleNegotiationBidWidgetViewModel extends ChangeNotifier {
  final Ref ref;
  SingleNegotiationBidWidgetViewModel(this.ref);

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
ChangeNotifierProvider<SingleNegotiationBidWidgetViewModel>(
        (ref) => SingleNegotiationBidWidgetViewModel(ref));

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';

class SingleSeeBidWidget extends ConsumerWidget {
  final BuyRequestModel request;
  final Color color;

  // Construct.
  const SingleSeeBidWidget({
    super.key,
    required this.color,
    required this.request,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);

    //? The actual component.
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //? The row that contains this users data.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    //? The store image.
                    WayaAssets.images.bid.store.image(
                      height: 48,
                    ),

                    //? The
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
                                    // Down.
                                    WayaAssets.images.bid.down.image(
                                      height: 10,
                                    ),

                                    // Some space.
                                    const Gap(5),

                                    // Text
                                    Text(
                                      "Open Bid",
                                      style: wayaTheme.textTheme.bodyMedium?.copyWith(
                                        color: wayaTheme.colorScheme.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Boundless space.
                              const Spacer(),

                              //? Then we
                              Container(
                                padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
                                decoration: BoxDecoration(
                                  color: wayaTheme.colorScheme.primary50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    //? Clock icon.
                                    WayaAssets.images.bid.clock.image(
                                      height: 16,
                                    ),

                                    //? Our text that shows the time left until
                                    //? a bid is valid.
                                    Text(
                                      "12m:00s",
                                      style: wayaTheme.textTheme.bodyMedium?.copyWith(
                                        color: wayaTheme.colorScheme.primary600,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          //? This is good.
                          const Gap(8),
                          Text(
                            "Samsung S24 Ultra",
                            style: wayaTheme.textTheme.bodyMedium?.copyWith(
                              color: wayaTheme.colorScheme.customBlack,
                              fontSize: 14.sp,
                            ),
                          ),
                          const Gap(8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Rufai Maleek ',
                                  style: wayaTheme.textTheme.bodyMedium?.copyWith(
                                    color: wayaTheme.colorScheme.black,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Fairly Used ',
                                  style: wayaTheme.textTheme.bodyMedium?.copyWith(
                                    color: WayaColors.greyColor400,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                // TextSpan(
                                //   text: 'Fairly Used ',
                                //   style: wayaTheme.textTheme.hintStyle,
                                // ),
                                TextSpan(
                                  text: '2Km Away',
                                  style: wayaTheme.textTheme.bodyMedium?.copyWith(
                                    color: WayaColors.greyColor400,
                                    fontSize: 10.sp,
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

                //? A breaker here.
                const Divider(
                  thickness: 1,
                  color: WayaColors.greyColor100,
                ),

                // Some space.
                const Gap(10),

                //? This
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //? This bid amount.
                    Text(
                      WayaValueHelper.formatPrice(request.bidStartingAmount),
                      style: wayaTheme.textTheme.bodyMedium?.copyWith(
                        color: wayaTheme.colorScheme.customBlack,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    //? The button to place the bid.
                    SizedBox(
                      width: context.width * 0.35,
                      child: WayaButton(
                        callback: () {},
                        text: 'Place Bid',
                        height: 38,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Some space.
          const Gap(10),
        ],
      ),
    );
  }
}

class SingleBidWidgetViewModel extends ChangeNotifier {
  final Ref ref;
  SingleBidWidgetViewModel(this.ref);

  Future<void> addDeliveryDetail(BuildContext context) async {
    /**
   await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddDeliveryDetails();
        });
   */
  }

  Future<void> sellerBidAction(BuildContext context, QuotationBidModel bid) async {
    WayaUtils.showNotice(
      context: context,
      buttonText: 'Add Delivery Details',
      secondButtonText: 'See your Order Details',
      title: 'Populate Delivery Details',
      message: "Add the delivery price and date of delivery for this order so the \n customer can review and pay",
      onPress: () async {
        await addDeliveryDetail(context);
      },
      onCancel: () {
        WayaNav.toNamed(WayaAppRoutes.getBidDetailsScreen(bid.id));
      },
      icon: Image.asset('assets/images/shop/delivery-van.png'),
    );
  }
}

/// The single settlement widget view model provider.
final singleSettlementWidgetViewModelProvider = ChangeNotifierProvider<SingleBidWidgetViewModel>(
  (ref) => SingleBidWidgetViewModel(ref),
);

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';
import 'package:wayagram/shared/features/quotation/widget/bid_status.dart';
import 'package:wayagram/shared/features/quotation/widget/bid_timer.dart';

class SingleBidWidget extends ConsumerWidget {
  final bool isSeller;
  final QuotationBidModel bid;

  // Construct.
  const SingleBidWidget({super.key, required this.bid, this.isSeller = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final notifier = ref.read(userQuotationsProvider.notifier);

    //? This is our component.
    return GestureDetector(
      onTap: () {
        if (isSeller) {
          WayaNav.toNamed(
              WayaAppRoutes.getBidDetailsScreen(bid.id, bid.requestId));
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
        decoration: BoxDecoration(
          color: wayaTheme.colorScheme.scaffoldColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5.w,
          children: [
            //? Fix this BS.
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //? This is fine.
                  WayaAssets.icons.bidIcon.svg(),

                  // Some space.
                  const Gap(4),

                  //? This should fill all space too.
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //? The ID of this buy request.
                        Text(
                          "Quote #${bid.requestId}",
                          maxLines: 1,
                          style: wayaTheme.textTheme.bodyMedium?.copyWith(
                            color: wayaTheme.colorScheme.customBlack,
                            fontSize: 14.sp,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        //
                        const Gap(8),

                        //? How much time is left until this buy request is
                        //? completed.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //? First, text
                            Text(
                              'Time Remaining | ',
                              style: wayaTheme.textTheme.hintStyle.copyWith(
                                fontSize: 13.sp,
                              ),
                            ),

                            //? Finally the timer.
                            QuotationBidTimer(
                              request: notifier.getBidQuote(bid.requestId)!,
                              isShortTime: true,
                              fontSize: 13.sp,
                              isStandalone: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            //? This is fine too.
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //? The status of the bid.
                BidStatusCard(
                  bid: bid,
                ),

                // Some space.
                const Gap(8),

                //? When this was made.
                Text(
                  WayaDateHelper.getEffectiveTimestamp(bid.createdAt),
                  style: wayaTheme.textTheme.bodyMedium?.copyWith(
                    color: wayaTheme.colorScheme.greyColor400,
                    fontSize: 13.sp,
                  ),
                )
              ],
            )
          ],
        ),
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

  Future<void> sellerBidAction(
      BuildContext context, QuotationBidModel bid) async {
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
      onCancel: () => WayaNav.toNamed(
          WayaAppRoutes.getBidDetailsScreen(bid.id, bid.requestId)),
      icon: Image.asset('assets/images/shop/delivery-van.png'),
    );
  }
}

final singleBidWidgetViewModelProvider =
    ChangeNotifierProvider<SingleBidWidgetViewModel>(
        (ref) => SingleBidWidgetViewModel(ref));

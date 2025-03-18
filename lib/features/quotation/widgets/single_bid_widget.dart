import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';

class SingleBidWidget extends ConsumerWidget {
  final bool isSeller;
  final QuotationBidModel bid;

  // Construct.
  const SingleBidWidget({super.key, required this.bid, this.isSeller = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);

    //? This is our component.
    return GestureDetector(
      onTap: () {
        if (isSeller) {
          WayaNav.toNamed('/seller-bid-details', arguments: "id");
          //viewModel.sellerBidAction(context);
        } else {
          WayaNav.toNamed('/seller-bid-details', arguments: "id");
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
            decoration: BoxDecoration(
              color: wayaTheme.colorScheme.scaffoldColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    //? This is fine.
                    WayaAssets.icons.bidIcon.svg(),

                    // Some space.
                    const Gap(4),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //? The ID of this buy request.
                        Text(
                          "Quote #${bid.requestId}",
                          style: wayaTheme.textTheme.bodyMedium?.copyWith(
                            color: wayaTheme.colorScheme.customBlack,
                            fontSize: 14.sp,
                          ),
                        ),

                        //
                        const Gap(8),

                        //? How much time is left until this buy request is
                        //? completed.
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: 'Time Remaining | ', style: wayaTheme.textTheme.hintStyle),
                              TextSpan(
                                text: '11h: 20m: 30s',
                                style: wayaTheme.textTheme.bodyMedium?.copyWith(
                                  color: wayaTheme.colorScheme.customPrimary,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                //? This is fine too.
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
                      decoration: BoxDecoration(
                        color: wayaTheme.colorScheme.success50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Won",
                        style: wayaTheme.textTheme.bodyMedium?.copyWith(
                          color: wayaTheme.colorScheme.success,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),

                    // Some space.
                    const Gap(8),

                    //? When this was made.
                    Text(
                      WayaDateHelper.getDailyTimestamp(bid.createdAt),
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
          const Gap(10)
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

  Future<void> sellerBidAction(BuildContext context) async {
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
          WayaNav.toNamed('/seller-bid-details', arguments: "id");
        },
        icon: Image.asset('assets/images/shop/delivery-van.png'));
  }
}

final singleBidWidgetViewModelProvider =
    ChangeNotifierProvider<SingleBidWidgetViewModel>((ref) => SingleBidWidgetViewModel(ref));

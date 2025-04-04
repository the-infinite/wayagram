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
import 'package:wayagram/features/quotation/quotation_bottomsheet_modal/quotation_modal.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';
import 'package:wayagram/shared/features/shop/model/default.dart';
import 'package:wayagram/shared/features/shop/resource/default.dart';

class SingleNegotiationBidWidget extends ConsumerStatefulWidget {
  final BuyRequestModel request;
  final QuotationBidModel bid;
  final BidActionAuthor negotiator;

  const SingleNegotiationBidWidget({
    super.key,
    required this.request,
    required this.bid,
    this.negotiator = BidActionAuthor.buyer,
  });

  @override
  ConsumerState<SingleNegotiationBidWidget> createState() => _SingleNegotiationBidWidgetState();
}

class _SingleNegotiationBidWidgetState extends ConsumerState<SingleNegotiationBidWidget> {
  late final userQuotationNotifier = ref.read(userQuotationsProvider.notifier);
  final stateNotifier = ValueNotifier(false);
  ShopDetailsModel? _shopData;

  Future<void> _rejectBid() async {
    await WayaUtils.showNotice(
      context: context,
      title: 'Are you sure you want to reject this bid?',
      message: 'Are you sure you want to reject this bid? Once confirmed this can\'t be undone',
      onPress: () => WayaNav.goBack(),
      icon: WayaAssets.images.dCodeInvalid.image(),
      buttonCenterWidget: WayaButton(
        text: 'Yes, Reject Bid',
        callback: () async {
          final result = await userQuotationNotifier.sendBidAction(
            BidActionModel.reject(
              bidId: widget.bid.id,
              lastCounterSentBy: widget.negotiator,
            ),
          );

          //? If this was fine, leave.
          if (result) WayaNav.goBack();
        },
        color: WayaColors.error500,
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final result = await ShopResource.getShopById(widget.bid.shopId);

      //? If this still in view...
      if (mounted) {
        setState(() {
          _shopData = result;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? This is fine.
    return GestureDetector(
      onTap: () {},
      child: ValueListenableBuilder(
        valueListenable: stateNotifier,
        builder: (context, isNegotiating, _) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                      //? Something like this.
                      WayaAssets.images.bid.store.image(
                        height: 48,
                      ),

                      // Some space.
                      const Gap(10),

                      //?
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
                                  decoration: BoxDecoration(
                                    color: switch (widget.bid.status) {
                                      BidActionType.noop || BidActionType.accept => wayaTheme.colorScheme.success,
                                      BidActionType.reject => wayaTheme.colorScheme.error,
                                      BidActionType.negotiate => wayaTheme.colorScheme.primary,
                                    },
                                    borderRadius: BorderRadius.circular(20000),
                                  ),
                                  child: Row(
                                    children: [
                                      WayaAssets.images.bid.down.image(
                                        height: 10,
                                      ),

                                      // Some space.
                                      const Gap(5),

                                      //? Title.
                                      Text(
                                        switch (widget.bid.status) {
                                          BidActionType.noop => "New Bid",
                                          BidActionType.reject => "Rejected",
                                          BidActionType.negotiate => widget.bid.lastCounterSentBy != widget.negotiator
                                              ? "Negotiating"
                                              : "Counteroffer Sent",
                                          BidActionType.accept => "Accepted",
                                        },
                                        style: wayaTheme.textTheme.bodyMedium?.copyWith(
                                          color: wayaTheme.colorScheme.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // Some space.
                            const Gap(8),

                            //? The name of the store.
                            Text(
                              _shopData?.shop.name ?? "Loading",
                              style: wayaTheme.textTheme.bodyMedium?.copyWith(
                                color: wayaTheme.colorScheme.customBlack,
                                fontSize: 14.sp,
                              ),
                            ),

                            // Some space.
                            const Gap(8),

                            //? The timing, distance and reviews for this store.
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      //? How much time it would take to get to this store.
                                      TextSpan(
                                        text: '15min ',
                                        style: wayaTheme.textTheme.bodyMedium?.copyWith(
                                          color: wayaTheme.colorScheme.black,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),

                                      //? The distance from this user.
                                      TextSpan(
                                        text: '2km ',
                                        style: wayaTheme.textTheme.bodyMedium?.copyWith(
                                          color: WayaColors.greyColor400,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //? The reviews and ratings a store has.
                                Row(
                                  children: [
                                    //? The rating icon.
                                    WayaAssets.images.bid.star.image(
                                      height: 16.h,
                                      width: 16.w,
                                    ),

                                    //? The average rating and the total reviews
                                    //? count.
                                    Text(
                                      " ${_shopData?.averageRating ?? '0'} (${_shopData?.ratings.length ?? 0} reviews)",
                                      style: wayaTheme.textTheme.bodyMedium?.copyWith(
                                        color: WayaColors.greyColor400,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),

                            // Some space.
                            const Gap(10),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // A divider.
                  const Divider(
                    thickness: 1,
                    color: WayaColors.greyColor100,
                  ),

                  // Some space.
                  const Gap(10),

                  //? The bid amount.
                  Text(
                    WayaValueHelper.formatPrice(double.tryParse(widget.bid.bidAmount) ?? 0),
                    style: wayaTheme.textTheme.bodyMedium?.copyWith(
                      color: wayaTheme.colorScheme.customBlack,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  // Some space.
                  const Gap(10),

                  //? For the buttons we would be using to
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //? The button to decline a proposal.
                        SizedBox(
                          width: context.width * 0.45,
                          child: WayaButton(
                            callback: _rejectBid,
                            text: 'Decline',
                            height: 38,
                            color: WayaColors.error500,
                          ),
                        ),

                        // Some space.
                        SizedBox(
                          width: 5.w,
                        ),

                        //? The button to renegotiate this proposal.
                        SizedBox(
                          width: context.width * 0.45,
                          child: WayaButton(
                            callback: () {},
                            text: 'Negotiate',
                            height: 38,
                            color: WayaColors.greyColor400,
                          ),
                        ),

                        // Some space.
                        SizedBox(
                          width: 5.w,
                        ),

                        //? The button to accept this proposal.
                        SizedBox(
                          width: context.width * 0.45,
                          child: WayaButton(
                            callback: () async {
                              await WayaUtils.showModalSheetQuotation(
                                context,
                                child: BidWonModal(),
                              );
                              WayaUtils.showModalSheetQuotation(
                                context,
                                child: QuotationModal(),
                              );
                            },
                            text: 'Accept',
                            height: 38,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}

class SingleNegotiationBidWidgetViewModel extends ChangeNotifier {
  final Ref ref;
  SingleNegotiationBidWidgetViewModel(this.ref);

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
        WayaNav.toNamed(WayaAppRoutes.getBidDetailsScreen(bid.id, bid.requestId));
      },
      icon: Image.asset('assets/images/shop/delivery-van.png'),
    );
  }
}

final singleSettlementWidgetViewModelProvider = ChangeNotifierProvider<SingleNegotiationBidWidgetViewModel>(
  (ref) => SingleNegotiationBidWidgetViewModel(ref),
);

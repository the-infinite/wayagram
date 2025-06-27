// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/quotation/quotation_bottomsheet_modal/quotation_modal.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';
import 'package:wayagram/shared/features/quotation/widget/bid_status.dart';
import 'package:wayagram/shared/features/shop/model/default.dart';
import 'package:wayagram/shared/features/shop/resource/default.dart';

class SingleNegotiationBidWidget extends ConsumerStatefulWidget {
  final BuyRequestModel request;
  final QuotationBidModel bid;
  final BidActionAuthor negotiator;
  final Timer? timer;

  const SingleNegotiationBidWidget({
    super.key,
    required this.request,
    required this.bid,
    required this.timer,
    this.negotiator = BidActionAuthor.buyer,
  });

  @override
  ConsumerState<SingleNegotiationBidWidget> createState() => _SingleNegotiationBidWidgetState();
}

class _SingleNegotiationBidWidgetState extends ConsumerState<SingleNegotiationBidWidget> {
  late final userQuotationNotifier = ref.read(userQuotationsProvider.notifier);
  final stateNotifier = ValueNotifier(false);
  bool locked = false;
  ShopDetailsModel? _shopData;

  Future<void> _negotiateBid() async {
    final amount = await WayaUtils.showModalSheet<double>(
      context,
      child: EditOfferModal(
        title: 'Negotiate',
        hint: 'Update your asking price for this request',
        delta: widget.request.bidStartingAmount >= 3000000
            ? 25000
            : widget.request.bidStartingAmount >= 200000
                ? 5000
                : 1000,
      ),
    );

    //! If this was dismissed before an amount was even calculated...
    if (amount == null) return;

    //? Now, send the bid.
    final result = await userQuotationNotifier.sendBidAction(BidActionModel.negotiate(
      bidId: widget.bid.id,
      lastCounterSentBy: widget.negotiator,
      counterAmount: amount.toStringAsFixed(2),
    ));

    //! Since bidding failed, you can leave.
    if (result) return;

    //? Since this was done well.
    WayaSnackBar.showToast("Bid countered successfully");
  }

  Future<void> _acceptBid() async {
    final wayaTheme = Theme.of(context);
    final acceptController = ValueNotifier(false);

    //? Now, show the modal.
    final result = await WayaUtils.showNotice<bool>(
      context: context,
      onCancel: () => WayaNav.goBack(),
      title: 'Are you sure you want to accept this bid?',
      message: 'Are you sure you want to accept this bid? Once confirmed this can\'t be undone',
      icon: WayaAssets.images.dCodeValid.image(
        height: 117.dg,
        width: 117.dg,
      ),
      buttonColor: wayaTheme.colorScheme.success700,
      buttonText: 'Yes, Accept Bid',
      actionNotifier: acceptController,
      onPress: () async {
        final result = await userQuotationNotifier.sendBidAction(
          BidActionModel.accept(
            bidId: widget.bid.id,
            lastCounterSentBy: widget.negotiator,
          ),
        );

        //? If this was fine, leave.
        WayaNav.goBack(result: result);
      },
    );

    //! Since bidding failed, you can leave.
    if (!(result ?? false)) return;

    //? Prevent some confusing visuals.
    widget.timer?.cancel();
    locked = true;

    //? Since this was done well.
    await WayaUtils.showModalSheet<double>(
      context,
      child: BidWonModal(
        request: widget.request,
        bid: widget.bid,
        user: widget.negotiator,
      ),
    );
  }

  Future<void> _rejectBid() async {
    final wayaTheme = Theme.of(context);
    final acceptController = ValueNotifier(false);

    //? Now, show the modal.
    final result = await WayaUtils.showNotice<bool>(
      context: context,
      onCancel: () => WayaNav.goBack(),
      title: 'Are you sure you want to reject this bid?',
      message: 'Are you sure you want to reject this bid? Once confirmed this can\'t be undone',
      icon: WayaAssets.images.dCodeInvalid.image(
        height: 117.dg,
        width: 117.dg,
      ),
      buttonColor: wayaTheme.colorScheme.error500,
      buttonText: 'Yes, Reject Bid',
      actionNotifier: acceptController,
      onPress: () async {
        final result = await userQuotationNotifier.sendBidAction(
          BidActionModel.reject(
            bidId: widget.bid.id,
            lastCounterSentBy: widget.negotiator,
          ),
        );

        //? If this was fine, leave.
        WayaNav.goBack(result: result);
      },
    );

    //! Since bidding failed, you can leave.
    if (!(result ?? false)) return;

    //? Then notify the user that he or she has rejected the bid properly.
    WayaSnackBar.showToast("You have successfully rejected this bid");
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
    final sentBid = widget.bid.usedAmount != widget.request.bidStartingAmount;

    //? If this has been
    if (widget.bid.lastCounterSentBy == BidActionAuthor.vendor && widget.bid.status == BidActionType.accept) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (!locked) {
            //? Prevent this from possibly repeating again.
            locked = true;
            widget.timer?.cancel();

            //? Now, show the modal in question.
            WayaUtils.showModalSheet<double>(
              context,
              child: QuotationModal(
                request: widget.request,
                bid: widget.bid,
                user: widget.negotiator,
              ),
            );
          }
        },
      );
    }

    //? This is fine.
    return ValueListenableBuilder(
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
                    GestureDetector(
                      onTap: () => WayaNav.toNamed(WayaAppRoutes.getProfileRoute(_shopData?.shop.vendorId ?? 'undefined')),
                      child: WayaDp(
                        image: _shopData?.shop.coverImage,
                        isSelf: false,
                        canFocus: false,
                        radius: 24.r,
                      ),
                    ),

                    // Some space.
                    const Gap(10),

                    //?
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //? The status card.
                          BidNegotiationStatusCard(
                            bid: widget.bid,
                            user: widget.negotiator,
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
                              // RichText(
                              //   text: TextSpan(
                              //     children: [
                              //       //? How much time it would take to get to this store.
                              //       TextSpan(
                              //         text: '15min ',
                              //         style: wayaTheme.textTheme.bodyMedium?.copyWith(
                              //           color: wayaTheme.colorScheme.black,
                              //           fontSize: 12.sp,
                              //           fontWeight: FontWeight.w400,
                              //         ),
                              //       ),

                              //       //? The distance from this user.
                              //       TextSpan(
                              //         text: '2km ',
                              //         style: wayaTheme.textTheme.bodyMedium?.copyWith(
                              //           color: WayaColors.greyColor400,
                              //           fontSize: 12.sp,
                              //           fontWeight: FontWeight.w400,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),

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

                //? Second, the amount of money that we are keeping notice of here.
                Text(
                  WayaValueHelper.formatPrice(widget.request.bidStartingAmount),
                  textAlign: TextAlign.center,
                  style: wayaTheme.textTheme.headlineLarge?.copyWith(
                    fontSize: sentBid ? 16.sp : 20.sp,
                    fontWeight: sentBid ? FontWeight.normal : FontWeight.w500,
                    decoration: sentBid ? TextDecoration.lineThrough : null,
                    decorationColor: wayaTheme.colorScheme.greyColor300,
                    color: sentBid ? wayaTheme.colorScheme.greyColor300 : wayaTheme.colorScheme.customBlack,
                  ),
                ),

                // Some space.
                Gap(5.h),

                //? Third, the amount of money that we are keeping notice of here.
                if (sentBid)
                  Text(
                    WayaValueHelper.formatPrice(widget.bid.usedAmount),
                    textAlign: TextAlign.center,
                    style: wayaTheme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: WayaConstants.fontFamily,
                      fontSize: 20.sp,
                      color: wayaTheme.colorScheme.customBlack,
                    ),
                  ),

                // Some space.
                const Gap(10),

                //? For the buttons we would be using to
                if (![BidActionType.accept, BidActionType.reject].contains(widget.bid.status))
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
                            callback: _negotiateBid,
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
                            callback: _acceptBid,
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
    );
  }
}

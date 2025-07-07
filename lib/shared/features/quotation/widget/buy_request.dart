// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/quotation/quotation_bottomsheet_modal/quotation_modal.dart';
import 'package:wayagram/shared/cache/quotation.dart';
import 'package:wayagram/shared/features/quotation/modal/choose_shop.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';

class QuotationBuyRequestWidget extends StatefulWidget {
  final BuyRequestModel data;
  final int index;
  final QuotationsNotifier notifier;

  // Construct.
  const QuotationBuyRequestWidget({
    super.key,
    required this.data,
    required this.index,
    required this.notifier,
  });

  @override
  State<QuotationBuyRequestWidget> createState() => _QuotationBuyRequestWidgetState();
}

class _QuotationBuyRequestWidgetState extends State<QuotationBuyRequestWidget> {
  final timeNotifier = ValueNotifier(Duration.zero);
  final loadingController = ValueNotifier(false);
  Timer? timer;
  late final isClosed = [BuyRequestStatus.cancelled, BuyRequestStatus.closed].contains(widget.data.status);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed) return;

      //? This is fine.
      final request = wayaQuotationsCache.getCachedData(widget.data.id) ?? widget.data;

      //? If the status is not started, then we need to calculate the time left
      //? until the bid starts.
      if (request.status == BuyRequestStatus.notStarted) {
        timeNotifier.value = request.bidStart.difference(DateTime.now()).abs();
      }

      //? If the status is active, then we need to calculate the time left until
      //? bidding ends.
      else {
        timeNotifier.value = request.bidEnd.difference(DateTime.now()).abs();
      }

      //? Now, let the timer keep ticking.
      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        final cachedRequest = wayaQuotationsCache.getCachedData(widget.data.id) ?? widget.data;
        final eval = timeNotifier.value - const Duration(seconds: 1);

        //? Update this guy in the list.
        if (eval.isNegative) {
          await widget.notifier.getBuyRequest(cachedRequest.id);
          return;
        }

        //? Update the time we think it would take.
        timeNotifier.value = eval;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timeNotifier.dispose();
    timer?.cancel();
    super.dispose();
  }

  Future<void> _placeBid() async {
    final request = wayaQuotationsCache.getCachedData(widget.data.id) ?? widget.data;
    final amount = await WayaUtils.showModalSheet<double>(
      context,
      child: EditOfferModal(
        title: 'Edit your Offer',
        hint: 'Update your base price for this request',
        delta: request.bidStartingAmount >= 3000000
            ? 25000
            : request.bidStartingAmount >= 200000
                ? 5000
                : 1000,
      ),
    );

    //! If this was dismissed before an amount was even calculated...
    if (amount == null) return;

    //? Which shop is the user sending the bid as?
    final shopId = await WayaUtils.showModalSheet(context, child: ChooseShopModal());

    //! If the shop was not selected.
    if (shopId == null) return;

    double? deliveryCost;

    //? If this is a delivery request and the delivery address is not null.
    //? After the shop is selected, we need to confirm the delivery cost with
    //? the seller.
    if (request.deliveryAddress != null) {
      final cost = await WayaUtils.showModalSheet<double>(
        context,
        child: EditOfferModal(
          title: 'Delivery Cost',
          hint: 'Enter your delivery cost for this order to deliver to\n\n${request.deliveryAddress}',
          delta: request.bidStartingAmount >= 3000000
              ? 25000
              : request.bidStartingAmount >= 200000
                  ? 5000
                  : 1000,
        ),
      );

      //? Since const is null.
      if (cost == null) return;

      //? Now we can try again.
      deliveryCost = cost;
    }

    //? Now, send the bid.
    final result = await widget.notifier.sendBid(request.id, amount, shopId, deliveryCost);

    //! Since bidding failed, you can leave.
    if (result == null) return;

    //* Okay, since bidding was fine, we throw a pizza party.
    _viewSellerBid(result);
  }

  Future<void> _viewSellerBid(QuotationBidModel result) async {
    WayaNav.toNamed(WayaAppRoutes.getSellerBidsRoute(result.id, result.requestId));
  }

  Future<void> _viewBids() async {
    final request = wayaQuotationsCache.getCachedData(widget.data.id) ?? widget.data;
    WayaNav.toNamed(WayaAppRoutes.getBuyerBidsRoute(request.id));
  }

  @override
  Widget build(BuildContext context) {
    //? First, get the quotation that owns this bid.
    final request = wayaQuotationsCache.getCachedData(widget.data.id);

    //? If this is undefined...
    if (request == null) {
      return const SizedBox.shrink();
    }

    //? Proceed to get all the utilities needed to render the views.
    final wayaTheme = Theme.of(context);
    final vendoredBid = request.bids
        ?.where((bid) => bid.vendorId == ConversationState.self.id && bid.status != BidActionType.reject)
        .firstOrNull;

    //? The component itself.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: wayaTheme.colorScheme.greyColor200,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, top: 10, right: 16, bottom: 10),
                decoration: BoxDecoration(
                  color: switch (request.status) {
                    BuyRequestStatus.notStarted => wayaTheme.colorScheme.pending.withAlpha(30),
                    BuyRequestStatus.active => wayaTheme.colorScheme.success50,
                    _ => wayaTheme.colorScheme.error.withAlpha(30),
                  },
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  spacing: 5,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //? The icons.
                    WayaAssets.icons.bBid.svg(
                      colorFilter: ColorFilter.mode(
                        switch (request.status) {
                          BuyRequestStatus.notStarted => wayaTheme.colorScheme.pending,
                          BuyRequestStatus.active => wayaTheme.colorScheme.success,
                          _ => wayaTheme.colorScheme.error,
                        },
                        BlendMode.srcIn,
                      ),
                    ),

                    //? The status description text.
                    Text(
                      switch (request.status) {
                        BuyRequestStatus.notStarted => "Not Started",
                        BuyRequestStatus.active => "Open Bid",
                        BuyRequestStatus.cancelled => "Cancelled",
                        BuyRequestStatus.closed => "Closed",
                      },
                      style: wayaTheme.textTheme.descriptionStyle.copyWith(
                        color: switch (request.status) {
                          BuyRequestStatus.notStarted => wayaTheme.colorScheme.pending,
                          BuyRequestStatus.active => wayaTheme.colorScheme.success,
                          _ => wayaTheme.colorScheme.error,
                        },
                        fontSize: 14.sp,
                      ),
                    )
                  ],
                ),
              ),

              // Some space
              const Gap(10),

              //? The category of this quotation
              Text(
                request.category.toUpperCase(),
                style: wayaTheme.textTheme.hintStyle,
              ),

              // Some space.
              const Gap(20),

              //? The name of the product.
              Text(
                request.fullname,
                style: wayaTheme.textTheme.titleLarge,
              ),

              // Some space.
              const Gap(20),

              //? Our description.
              WayaCollapsibleText(
                request.description,
                maxLines: 3,
                textColor: wayaTheme.colorScheme.greyColor500,
                buttonColor: wayaTheme.colorScheme.primary,
                style: wayaTheme.textTheme.descriptionStyle,
              ),

              // Some space.
              const Gap(20),

              //? Where we keep our current time left.
              ValueListenableBuilder(
                valueListenable: timeNotifier,
                builder: (context, timeLeft, _) {
                  return RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: switch (request.status) {
                            BuyRequestStatus.notStarted => 'Bidding Starts in ',
                            BuyRequestStatus.active => 'Bidding Ends in ',
                            BuyRequestStatus.cancelled => 'Bidding Cancelled ',
                            BuyRequestStatus.closed => 'Bidding Closed ',
                          },
                          style: wayaTheme.textTheme.hintStyle,
                        ),
                        TextSpan(
                          text: isClosed
                              ? WayaDateHelper.getSocialDate(request.updatedAt)
                              : WayaDateHelper.convertDurationToCountdown(timeNotifier.value),
                          style: wayaTheme.textTheme.descriptionStyle.copyWith(
                            color: wayaTheme.colorScheme.customPrimary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Some space.
              const Gap(20),

              //? Now, for the starting bid amount.
              RichText(
                text: TextSpan(
                  children: [
                    //* For the section title.
                    TextSpan(text: 'Starting Price: ', style: wayaTheme.textTheme.hintStyle),

                    //* For the starting amount.
                    TextSpan(
                      text: '₦ ${request.bidStartingAmount}',
                      style: wayaTheme.textTheme.bodyBold.copyWith(
                        color: wayaTheme.colorScheme.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Some space.
              const Gap(20),

              //? The button that we use to place a bid.
              if (vendoredBid != null)
                WayaProgressiveButton(
                  callback: () => _viewSellerBid(vendoredBid),
                  text: 'View bid',
                  height: 48,
                  notifier: loadingController,
                )
              else
                WayaProgressiveButton(
                  callback: request.buyerId == ConversationState.self.id ? _viewBids : _placeBid,
                  text: request.buyerId == ConversationState.self.id ? 'View Bids' : 'Place Bid',
                  height: 48,
                  isDisabled:
                      request.buyerId == ConversationState.self.id ? false : request.status != BuyRequestStatus.active,
                  notifier: loadingController,
                ),
            ],
          ),
        ),

        //? Closing space.
        const Gap(30),
      ],
    );
  }
}

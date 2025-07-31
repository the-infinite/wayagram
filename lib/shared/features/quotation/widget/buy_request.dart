// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';
import 'package:wayagram/features/quotation/seller/views/create_bid/create_bid.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';
import 'package:wayagram/shared/cache/quotation.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';

class QuotationBuyRequestWidget extends ConsumerStatefulWidget {
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
  ConsumerState<QuotationBuyRequestWidget> createState() => _QuotationBuyRequestWidgetState();
}

class _QuotationBuyRequestWidgetState extends ConsumerState<QuotationBuyRequestWidget> {
  final orderController = ValueNotifier<BidOrderModel?>(null);
  QuotationBidModel? bid;
  final timeNotifier = ValueNotifier(Duration.zero);
  bool getOrder = true;
  final loadingController = ValueNotifier(false);
  Timer? timer;
  late final isClosed = [BuyRequestStatus.cancelled, BuyRequestStatus.closed].contains(widget.data.status);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //? First, we try to retrieve the order information.
      widget.notifier.getOrderDetails(widget.data.id).then(
        (value) {
          orderController.value = value;
        },
      );

      //? If this is not open, leave.
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
      timer = Timer.periodic(const Duration(seconds: 1), (_) async => await _ingestOrder());
    });
    super.initState();
  }

  @override
  void dispose() {
    timeNotifier.dispose();
    timer?.cancel();
    super.dispose();
  }

  Future<void> _ingestOrder() async {
    final cachedRequest = wayaQuotationsCache.getCachedData(widget.data.id) ?? widget.data;
    final eval = timeNotifier.value - const Duration(seconds: 1);

    //? Only do this when you are allowed to.
    if (getOrder) {
      try {
        //? Get the order value and update it.
        final value = await widget.notifier.getOrderDetails(widget.data.id);

        //? This is fine too.
        orderController.value = value;

        //? Stop getting this.
        if (value == null) {
          getOrder = false;
        }
      } catch (_) {}
    }

    //? Update this guy in the list.
    if (eval.isNegative || eval.inSeconds == 0) {
      await widget.notifier.getBuyRequest(cachedRequest.id);
      return;
    }

    //? Update the time we think it would take.
    timeNotifier.value = eval;
  }

  Future<void> _placeBid() async {
    //? Try to load all of the payment methods first, in place.
    final walletNotifier = ref.read(walletVmProvider.notifier);
    await walletNotifier.getPayoutMethod();

    //? If this is not fine.
    if (!mounted) {
      return;
    }

    //? First, we check if this user has any payout methods configured before
    //? placing the bid.
    final walletViewModel = ref.read(walletVmProvider);

    //? Check if user have payout method added and then tell he or she to if he
    //? or she has not.
    if (walletViewModel.payoutMethod.isEmpty) {
      await WayaUtils.showModalSheet(
        context,
        child: AddPayoutModal(),
      );
      return;
    }

    //? Then move forward.
    final request = wayaQuotationsCache.getCachedData(widget.data.id) ?? widget.data;

    //? Send the user to the screen dedicated to the cause.
    WayaNav.to(CreateBidScreen(request: request), transition: Transition.downToUp);
  }

  Future<void> _viewSellerBid(QuotationBidModel result) async {
    WayaNav.toNamed(WayaAppRoutes.getSellerBidsRoute(result.id, result.requestId));
  }

  Future<void> _viewOrder() async {
    WayaNav.toNamed(WayaAppRoutes.getQuotationOrderDetaisScreen(widget.data.id));
  }

  Future<void> _checkoutOrder() async {
    WayaNav.toNamed(WayaAppRoutes.getQuotationOrderDetailScreen(widget.data.id));
    final request = wayaQuotationsCache.getCachedData(widget.data.id) ?? widget.data;
    final bid = request.bids?.where((bid) => bid.status == BidActionType.accept).firstOrNull;

    //? This is fine
    if (bid != null && widget.data.buyerId == ConversationState.self.id) {
      WayaAppRoutes.getQuotationCheckoutSceen(bid.id, bid.requestId);
    }

    //? Are you the right vendor?
    else if (bid?.vendorId == ConversationState.self.id) {
      WayaNav.toNamed(WayaAppRoutes.getQuotationOrderDtailsScreen(widget.data.id));
    }
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
    return ValueListenableBuilder(
      valueListenable: orderController,
      builder: (context, order, _) {
        final participatedOrder =
            order?.buyerId == ConversationState.self.id || order?.vendorId == ConversationState.self.id;

        //? This is fine.
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

                  //? The button that we use to view an order.
                  if (participatedOrder && order!.isPaid)
                    WayaProgressiveButton(
                      callback: _viewOrder,
                      text: 'View Order',
                      height: 48,
                      notifier: loadingController,
                    )

                  //? The button that we use to checkout an order.
                  else if (participatedOrder && !order!.isPaid)
                    WayaProgressiveButton(
                      callback: _checkoutOrder,
                      text: 'Complete Order',
                      height: 48,
                      notifier: loadingController,
                    )

                  //? The button that we use to place a bid.
                  else if (vendoredBid != null)
                    WayaProgressiveButton(
                      callback: () => _viewSellerBid(vendoredBid),
                      text: 'View bid',
                      height: 48,
                      notifier: loadingController,
                    )

                  //? Then you can view bids.
                  else
                    WayaProgressiveButton(
                      callback: request.buyerId == ConversationState.self.id ? _viewBids : _placeBid,
                      text: request.buyerId == ConversationState.self.id ? 'View Bids' : 'Place Bid',
                      height: 48,
                      isDisabled: request.buyerId == ConversationState.self.id
                          ? false
                          : request.status != BuyRequestStatus.active,
                      notifier: loadingController,
                    ),
                ],
              ),
            ),

            //? Closing space.
            const Gap(30),
          ],
        );
      },
    );
  }
}

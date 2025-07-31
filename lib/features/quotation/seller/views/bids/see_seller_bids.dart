// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/controller/preloader.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';
import 'package:wayagram/features/quotation/quotation_bottomsheet_modal/quotation_modal.dart';
import 'package:wayagram/features/quotation/seller/views/create_bid/create_bid.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';
import 'package:wayagram/shared/features/quotation/widget/bid_status.dart';
import 'package:wayagram/shared/features/quotation/widget/bid_timer.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

class SeeSellerBids extends ConsumerStatefulWidget {
  static const route = '/quotation/seller/bids';
  final String id;
  final String requestId;
  const SeeSellerBids({super.key, required this.id, required this.requestId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SeeSellerBidsState();
}

class _SeeSellerBidsState extends ConsumerState<SeeSellerBids> {
  late final notifier = ref.read(userQuotationsProvider.notifier);
  final loadingController = ValueNotifier(false);
  Timer? _timer;
  bool locked = false;
  bool sentBid = false;
  CachedUserDataTuple? user;
  QuotationBidModel? bid;
  BuyRequestModel? request;

  void _ingestBid() async {
    final result = await notifier.getSingleBid(widget.id);

    if (result != null && mounted) {
      setState(() {
        bid = result;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        //? First, show the preloader.
        WayaPreloaderController.instance.show();

        //? This is fine.
        final foundBid = notifier.getBid(widget.id) ?? await notifier.getSingleBid(widget.id);
        final foundQuote = notifier.getBidQuote(widget.requestId) ?? await notifier.getBuyRequest(widget.requestId);
        final foundUser = foundQuote != null ? await UserResource.getUserDetails(foundQuote.buyerId) : null;

        //? Update these values in state.
        setState(() {
          bid = foundBid;
          request = foundQuote;
          user = foundUser;
          sentBid = bid?.usedAmount != request?.bidStartingAmount;
        });

        //? Finally, hide the preloader.
        WayaPreloaderController.instance.hide();

        //? Now, update the bid every so often.
        _timer ??= Timer.periodic(
          const Duration(seconds: 5),
          (timer) {
            _ingestBid();
          },
        );
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    loadingController.dispose();
    _timer?.cancel();
    super.dispose();
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

    //? Send the user to the screen dedicated to the cause.
    WayaNav.to(CreateBidScreen(request: request!), transition: Transition.downToUp);
  }

  Future<void> _negotiateBid(BuyRequestModel request, QuotationBidModel bid) async {
    final amount = await WayaUtils.showModalSheet<double>(
      context,
      child: EditOfferModal(
        title: 'Negotiate',
        hint: 'Update your selling price for this request',
        delta: request.bidStartingAmount >= 3000000
            ? 25000
            : request.bidStartingAmount >= 200000
                ? 5000
                : 1000,
      ),
    );

    //! If this was dismissed before an amount was even calculated...
    if (amount == null) return;

    //? Now, send the bid.
    final result = await notifier.sendBidAction(BidActionModel.negotiate(
      bidId: bid.id,
      lastCounterSentBy: BidActionAuthor.vendor,
      counterAmount: amount.toStringAsFixed(2),
      deliveryCost: bid.deliveryCharge,
    ));

    //! Since bidding failed, you can leave.
    if (result) return;

    //? Since this was done well.
    _ingestBid();
    WayaSnackBar.showToast("Bid countered successfully");
  }

  Future<void> _acceptBid(BuyRequestModel request, QuotationBidModel bid) async {
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
        final result = await notifier.sendBidAction(
          BidActionModel.accept(
            bidId: bid.id,
            lastCounterSentBy: BidActionAuthor.vendor,
          ),
        );

        //? If this was fine, leave.
        WayaNav.goBack(result: result);
      },
    );

    //! Since bidding failed, you can leave.
    if (!(result ?? false)) return;

    //? Prevent some confusing visuals.
    locked = true;
    _timer?.cancel();

    //? Since this was done well.
    _ingestBid();
    WayaUtils.showModalSheet<double>(
      context,
      child: BidWonModal(
        request: request,
        bid: bid,
        user: BidActionAuthor.vendor,
      ),
    );
  }

  Future<void> _rejectBid(BuyRequestModel request, QuotationBidModel bid) async {
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
        final result = await notifier.sendBidAction(
          BidActionModel.reject(
            bidId: bid.id,
            lastCounterSentBy: BidActionAuthor.vendor,
          ),
        );

        //? If this was fine, leave.
        WayaNav.goBack(result: result);
      },
    );

    //! Since bidding failed, you can leave.
    if (!(result ?? false)) return;

    //? Then notify the user that he or she has rejected the bid properly.
    _ingestBid();
    WayaSnackBar.showToast("You have successfully rejected this bid");
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? If this has been
    if (bid?.lastCounterSentBy == BidActionAuthor.buyer && bid?.status == BidActionType.accept) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (!locked) {
            //? Prevent this from possibly repeating again.
            locked = true;
            _timer?.cancel();

            //? Now, show the modal in question.
            WayaUtils.showModalSheet<double>(
              context,
              child: QuotationModal(
                request: request!,
                bid: bid!,
                user: BidActionAuthor.vendor,
              ),
            );
          }
        },
      );
    }

    //? This is fine.
    return WayaScaffold(
      isLoading: false,
      isScrollable: false,
      title: "Bid",
      body: SafeArea(
        child: bid == null || request == null
            ? const SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //? First, the row containing the profile picture and some request details.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8.w,
                    children: [
                      //? The user's profile picture.
                      WayaDp(
                        radius: 20.r,
                        image: user!.$1.profilePicture,
                        onTap: () => WayaNav.toNamed(WayaAppRoutes.getProfileRoute(user!.$1.id)),
                        isSelf: false,
                        canFocus: false,
                      ),

                      //? Second, the user's name.
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 5.h,
                          children: [
                            //* The name of the .
                            BidNegotiationStatusCard(
                              bid: bid!,
                              user: BidActionAuthor.vendor,
                            ),

                            //* The name of the requested item.
                            Text(
                              request!.fullname,
                              maxLines: 1,
                              style: wayaTheme.textTheme.bodyBold.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            //* The name of the user that is making the condition of the product
                            WayaRichText(
                              title1: user!.$2.displayName ?? user!.$1.fullname,
                              title2: request!.condition == "new" ? "   Brand New" : "   Fairly Used",
                              style1: wayaTheme.textTheme.bodyBold.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.normal,
                              ),
                              style2: wayaTheme.textTheme.bodyBold.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.normal,
                                color: wayaTheme.colorScheme.greyColor400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      //? Third, the request timer.
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: wayaTheme.colorScheme.primaryBrown50,
                          borderRadius: BorderRadius.circular(6000.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 2.w,
                          children: [
                            //? The icon for the stopwatch.
                            Icon(
                              Icons.timer_outlined,
                              color: wayaTheme.colorScheme.primary600,
                              size: 13.sp,
                            ),

                            //? The bid timer.
                            QuotationBidTimer(
                              request: request!,
                              isShortTime: true,
                              isExpanded: true,
                              isStandalone: false,
                              fontSize: 13.sp,
                              textColor: wayaTheme.colorScheme.primary600,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Divider that should create some space.
                  Divider(color: wayaTheme.colorScheme.greyColor200, thickness: 1),

                  //? Second, the amount of money that we are keeping notice of here.
                  Text(
                    WayaValueHelper.formatPrice(request!.bidStartingAmount),
                    textAlign: TextAlign.center,
                    style: wayaTheme.textTheme.headlineLarge?.copyWith(
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
                      WayaValueHelper.formatPrice(bid!.usedAmount),
                      textAlign: TextAlign.center,
                      style: wayaTheme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontFamily: WayaConstants.fontFamily,
                        color: wayaTheme.colorScheme.customBlack,
                      ),
                    ),

                  // Boundless space.
                  const Spacer(),

                  //? If this is one thing, you can place another bid.
                  WayaProgressiveButton(
                    callback: _placeBid,
                    notifier: loadingController,
                    color: wayaTheme.colorScheme.primary,
                    text: "Place Another Bid",
                  ),

                  // Some space.
                  Gap(10.h),

                  //? Since this bid is just opened, the seller cannot accept or reject it. So
                  //? we will show a disabled button.
                  if (bid!.status == BidActionType.noop) ...[
                    //* The button to negotiate an offer.
                    WayaButton(
                      callback: null,
                      isDisabled: true,
                      text: "Waiting for response",
                    ),

                    // Some space.
                    Gap(10.h),
                  ]

                  //? If this bid is not accepted or rejected, then we can show the buttons to negotiate, accept, and reject.
                  else if (![BidActionType.accept, BidActionType.reject].contains(bid!.status)) ...[
                    //* The button to negotiate an offer.
                    WayaProgressiveButton(
                      callback: () => _negotiateBid(request!, bid!),
                      notifier: loadingController,
                      color: wayaTheme.colorScheme.info,
                      text: bid!.lastCounterSentBy == BidActionAuthor.buyer ? "Negotiate" : "Renegotiate",
                    ),

                    // Some space.
                    if (bid!.lastCounterSentBy == BidActionAuthor.buyer)
                      Gap(
                        10.h,
                      ),

                    //? The buttons to accept and reject an offer.
                    if (bid!.lastCounterSentBy == BidActionAuthor.buyer)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10.h,
                        children: [
                          //* The button to reject an offer.
                          Expanded(
                            child: WayaProgressiveButton(
                              callback: () => _rejectBid(request!, bid!),
                              notifier: loadingController,
                              color: wayaTheme.colorScheme.error,
                              text: "Reject",
                            ),
                          ),

                          //* The button to accept an offer
                          Expanded(
                            child: WayaProgressiveButton(
                              callback: () => _acceptBid(request!, bid!),
                              notifier: loadingController,
                              color: wayaTheme.colorScheme.primary,
                              text: "Accept",
                            ),
                          ),
                        ],
                      ),
                  ],
                ],
              ),
      ),
    );
  }
}

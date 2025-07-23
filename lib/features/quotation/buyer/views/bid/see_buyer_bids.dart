// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/quotation/quotation_bottomsheet_modal/quotation_modal.dart';
import 'package:wayagram/features/quotation/widgets/single_negotiation_bid.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';
import 'package:wayagram/shared/features/quotation/widget/bid_timer.dart';

class SeeBuyerBids extends ConsumerStatefulWidget {
  static const route = '/quotation/buyer/bids';
  final String id;

  // Construct.
  const SeeBuyerBids({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SeeBuyerBidsState();
}

class _SeeBuyerBidsState extends ConsumerState<SeeBuyerBids> {
  late final notifier = ref.read(userQuotationsProvider.notifier);
  final cancelNotifier = ValueNotifier(false);
  final extendNotifier = ValueNotifier(false);
  final requestState = ValueNotifier<BuyRequestModel?>(null);
  Timer? _timer;
  BidOrderModel? order;

  Future<void> _ingestBid() async {
    //? Update this guy in the list.
    final result = await notifier.getBuyRequest(widget.id);
    final finalOrder = await notifier.getOrderDetails(widget.id);
    order = finalOrder;
    if (result != null) requestState.value = result;
  }

  Future<void> _viewOrder() async {
    WayaNav.toNamed(WayaAppRoutes.getQuotationOrderDetailsScreen(widget.id));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        //? Now, let the timer keep ticking.
        await _ingestBid();

        //? Now, listen to this periodically.
        _timer = Timer.periodic(
          const Duration(seconds: 7),
          (timer) async => await _ingestBid(),
        );
      },
    );
    super.initState();
  }

  void _cancelAndFinish() async {
    _timer?.cancel();
    await notifier.cancelRequest(widget.id);
    WayaNav.goBack();
  }

  @override
  void dispose() {
    _timer?.cancel();
    requestState.dispose();
    cancelNotifier.dispose();
    extendNotifier.dispose();
    super.dispose();
  }

  Future<void> _extendBidTime(BuyRequestModel request) async {
    final controller = ValueNotifier<String?>(null);
    final isLoading = ValueNotifier(false);

    //? Show the modal sheet.
    await WayaUtils.showModalSheet(
      context,
      child: ExtendBidTime(
        request: request,
        notifier: notifier,
        time: controller,
        isLoading: isLoading,
      ),
    );

    //? Dispose these ones.
    try {
      controller.dispose();
      isLoading.dispose();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final _ = ref.watch(userQuotationsProvider);

    final participatedOrder =
        order?.buyerId == ConversationState.self.id || order?.vendorId == ConversationState.self.id;

    //? This is fine too.
    return WayaScaffold(
      isLoading: false,
      isScrollable: false,
      padding: EdgeInsets.zero,
      backgroundColor: WayaColors.greyColor200,
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: requestState,
          builder: (context, request, _) => Column(
            mainAxisAlignment: request?.bids?.isEmpty ?? true ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //? If nobody has bid yet...
              if (request?.bids?.isEmpty ?? true) ...[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                  decoration: BoxDecoration(
                    color: wayaTheme.colorScheme.scaffoldColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //? The bid icon.
                      WayaAssets.images.bid.shop.image(
                        height: 110.h,
                        width: 110.w,
                      ),

                      // Some space.
                      SizedBox(height: 20.h),

                      //? Tell the user we are awaiting vendors.
                      Text(
                        "Finding Vendors....",
                        style: wayaTheme.textTheme.headlineLarge,
                      ),

                      // Some space.
                      SizedBox(height: 3.h),

                      //? The description.
                      Text(
                        "We're sending notifications to vendors around you to start bidding...",
                        textAlign: TextAlign.center,
                        style: wayaTheme.textTheme.hintStyle,
                      ),
                    ],
                  ),
                ),

                // Some space.
                SizedBox(height: 17.h),

                //? When this request exists...
                if (request != null) ...[
                  //? Next, the timer.
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: QuotationBidTimer(
                      request: request,
                    ),
                  ),

                  // More space.
                  SizedBox(height: 17.h),
                ]
              ] else
                //? This is fine.
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    itemCount: request?.bids?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final bid = request!.bids![index];

                      //? Return this one.
                      return SingleNegotiationBidWidget(
                        negotiator: BidActionAuthor.buyer,
                        request: request,
                        timer: _timer,
                        bid: bid,
                        order: order,
                        onBidReacted: _ingestBid,
                      );
                    },
                  ),
                ),

              //? This is fine.
              if (request?.hasAcceptedBid ?? false)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: WayaButton(
                    callback: participatedOrder && order!.isPaid
                        ? _viewOrder
                        : () async => WayaNav.offNamed(
                              WayaAppRoutes.getQuotationCheckoutScreen(request!.acceptedBid!.id, request.id),
                            ),
                    text: participatedOrder && order!.isPaid ? "View Order" : "Proceed to Payment",
                  ),
                )
              else
                Container(
                  padding: EdgeInsets.only(left: 20.w, right: 10.w, top: 20.h),
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //? First,
                      Row(
                        children: [
                          Text(
                            WayaValueHelper.formatPrice(request?.bidStartingAmount ?? 0),
                            style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.customBlack,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          //? Boundless space.
                          Spacer(),

                          //? So, let us see how well we are doing.
                          InkWell(
                            onTap: () async {
                              //? Show the edit offer modal.
                              final amount = await WayaUtils.showModalSheet<double>(
                                context,
                                child: EditOfferModal(
                                  delta: 100,
                                  maxAmount: request?.maxBidAmount ?? 5000000,
                                  title: 'Edit your Offer',
                                  hint: 'Update your base price for this request',
                                ),
                              );

                              //? If this is null, leave.
                              if (amount == null) return;

                              //? Since this was fine...
                              final result = await notifier.updateRequestAmount(widget.id, amount);

                              //? If this did not go well, leave.
                              if (!result) return;

                              //? Since it went well...
                              requestState.value = requestState.value!.copyWith(bidStartingAmount: amount);

                              //? Now, tell the user that it went well.
                              WayaUtils.showNotice(
                                context: context,
                                title: "Offer Updated",
                                message: "Your offer has been updated successfully",
                                icon: WayaAssets.images.bid.accept.image(
                                  height: 116.h,
                                  width: 116.h,
                                ),
                                buttonText: 'Okay',
                                isDismissible: true,
                                onPress: () => WayaNav.goBack(),
                              );
                            },
                            child: WayaAssets.images.bid.edit.image(
                              height: 26.h,
                            ),
                          )
                        ],
                      ),

                      // Some space.
                      const Gap(20),

                      //? The title offer.
                      Text(
                        "Your Offer",
                        style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.greyColor500,
                          fontWeight: FontWeight.normal,
                          fontSize: 14.sp,
                        ),
                      ),

                      // Some space.
                      const Gap(20),

                      //? The buttons in the
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //? The button to close a bid.
                          Expanded(
                            child: WayaProgressiveButton(
                              callback: () async {
                                //? After this is done..
                                await WayaUtils.showNotice(
                                  context: context,
                                  title: 'Cancel Buy Request',
                                  message: 'Are you sure you want to cancel this request?',
                                  icon: WayaAssets.images.bid.cancel.image(
                                    height: 116.h,
                                    width: 116.h,
                                  ),
                                  buttonText: 'Yes, Cancel Request',
                                  secondButtonText: 'No, Keep Request',
                                  isDismissible: true,
                                  onCancel: () => WayaNav.goBack(),
                                  onPress: _cancelAndFinish,
                                );

                                //? Leave.
                                WayaNav.goBack();
                              },
                              text: 'Cancel Buy Request',
                              color: WayaColors.error500,
                              notifier: cancelNotifier,
                            ),
                          ),

                          // Some space.
                          const Gap(5),

                          //? The button to extend a bid's time.
                          Expanded(
                            child: WayaProgressiveButton(
                              callback: () async => await _extendBidTime(request!),
                              text: 'Extend Bid Time',
                              notifier: extendNotifier,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

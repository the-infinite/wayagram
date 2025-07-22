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
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/quotation/quotation_bottomsheet_modal/quotation_modal.dart';
import 'package:wayagram/features/shop/order/widgets/order_info_widget.dart';
import 'package:wayagram/features/shop/widgets/about_product.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';
import 'package:wayagram/shared/features/quotation/widget/bid_status.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

import 'confirm_order.dart';

class QuotationOrderDetails extends ConsumerStatefulWidget {
  static const route = '/quotation/seller/orders/one';
  final String requestId;

  //? This is fine.
  const QuotationOrderDetails({
    super.key,
    required this.requestId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuotationOrderDetailsScreenState();
}

class _QuotationOrderDetailsScreenState extends ConsumerState<QuotationOrderDetails> {
  late final notifier = ref.read(userQuotationsProvider.notifier);
  Timer? _timer;
  bool _loaded = false;
  BidOrderStatus? status;
  BidOrderModel? order;
  CachedUserDataTuple? user;
  BuyRequestModel? request;
  QuotationBidModel? bid;

  void _ingestOrder() async {
    final foundOrder = await notifier.getOrderDetails(widget.requestId);
    final foundStatus = await notifier.trackDelivery(widget.requestId);
    final foundQuote = notifier.getBidQuote(widget.requestId) ?? await notifier.getBuyRequest(widget.requestId);
    final foundBid =
        foundOrder == null ? null : notifier.getBid(foundOrder.bidId) ?? await notifier.getSingleBid(foundOrder.bidId);

    //? This is fine.
    if (foundOrder != null && foundQuote != null && mounted) {
      setState(() {
        request = foundQuote;
        order = foundOrder;
        bid = foundBid ?? bid;
        status = foundStatus ?? status;
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
        final foundOrder = await notifier.getOrderDetails(widget.requestId);
        final foundQuote = notifier.getBidQuote(widget.requestId) ?? await notifier.getBuyRequest(widget.requestId);
        final foundStatus = await notifier.trackDelivery(widget.requestId);
        final foundUser = foundQuote != null
            ? await UserResource.getUserDetails(
                ConversationState.self.id == foundQuote.buyerId ? (foundOrder?.vendorId ?? "") : foundQuote.buyerId)
            : null;
        final foundBid = foundOrder == null
            ? null
            : notifier.getBid(foundOrder.bidId) ?? await notifier.getSingleBid(foundOrder.bidId);

        //? If this is actually on the buyer side, poll to update the order's state.
        if (foundOrder?.buyerId == ConversationState.self.id) {
          _timer = Timer.periodic(const Duration(seconds: 7), (_) => _ingestOrder());
        }

        //? Update these values in state.
        if (mounted) {
          setState(() {
            request = foundQuote;
            user = foundUser;
            order = foundOrder;
            bid = foundBid;
            status = foundStatus;
            _loaded = true;
          });
        }

        //? Finally, hide the preloader.
        WayaPreloaderController.instance.hide();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final subtotal = (request?.quantity ?? 0) * (bid?.usedAmount ?? 0);
    final isUnavailable = order == null || request == null;
    final isBuyer = order?.buyerId == ConversationState.self.id;
    final hasArrived = request?.deliveryType == BuyRequestDeliveryType.pickup
        ? status?.deliveryStatus == QuotationDeliveryStatus.delivered
        : status?.pickupStatus == QuotationPickupStatus.collected;

    //? Return the component.
    return WayaScaffold(
      isLoading: false,
      isScrollable: !isUnavailable,
      title: 'Order Details',
      body: !_loaded
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : isUnavailable
              ? Center(
                  child: Text(
                    "This order was not found",
                    style: wayaTheme.textTheme.headlineMedium,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //? Header 1.
                    Text(
                      "Order Details",
                      style: wayaTheme.textTheme.headlineLarge,
                    ),

                    // Some space.
                    Gap(3.h),

                    //? Subtitle.
                    Text(
                      'View and manage this order',
                      style: wayaTheme.textTheme.hintStyle,
                    ),

                    //? Some space.
                    Gap(20.h),

                    //? The product's name.
                    AboutProduct(
                      title: 'Product Name',
                      content: request!.productName,
                    ),

                    // Some space.
                    Gap(15.h),

                    if (request!.brand?.isNotEmpty ?? false) ...[
                      //? The brand name.
                      AboutProduct(
                        title: 'Brand Name',
                        content: request!.brand!,
                      ),

                      // Some space.
                      Gap(15.h),
                    ],

                    //? The category and condition.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AboutProduct(
                            title: 'Product Category',
                            content: request!.category,
                          ),
                        ),

                        //? This is fine.
                        Expanded(
                          child: AboutProduct(
                            title: 'Product Condition',
                            content: request!.condition,
                          ),
                        )
                      ],
                    ),

                    // Some space.
                    Gap(15.h),

                    //?  The description of the product.
                    AboutProduct(
                      title: 'Product Description',
                      content: request!.description,
                    ),

                    // Some space.
                    Gap(15.h),

                    //? The quantity, state of purchase and location.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //? First, quantity.
                        Expanded(
                          child: AboutProduct(
                            title: 'Quantity',
                            content: WayaValueHelper.formatNumber(request!.quantity),
                          ),
                        ),

                        //? Second, the state it was bought in.
                        Expanded(
                          flex: 2,
                          child: AboutProduct(
                            title: 'State of Purchase',
                            content: request!.stateOfPurchase,
                          ),
                        ),

                        //? Finally, the location.
                        Expanded(
                          child: AboutProduct(
                            title: 'LGA',
                            content: request!.lga,
                          ),
                        )
                      ],
                    ),

                    // Some space.
                    Gap(30.h),

                    //? The starting amount for bidding.
                    OrderInfoWidget(
                      title: "Bid Starting Amount",
                      description: WayaValueHelper.formatPrice(request!.bidStartingAmount),
                    ),

                    // Some space.
                    Gap(25.h),

                    //? The customer details section title..
                    Text(
                      isBuyer ? "Seller Details" : "Customer Details",
                      style: wayaTheme.textTheme.bodyMedium,
                    ),

                    // Some space.
                    Gap(15.h),

                    //? The name of the customer.
                    GestureDetector(
                      onTap: () =>
                          WayaNav.toNamed(WayaAppRoutes.getProfileRoute(user?.$1.id ?? "undefined", "quotation")),
                      child: OrderInfoWidget(
                        title: isBuyer ? "Seller's Name" : "Customer's Name",
                        description: user?.$1.fullname ?? "N/A",
                      ),
                    ),

                    // Some space.
                    Gap(8.h),

                    //? The delivery type.
                    OrderInfoWidget(
                      title: "Delivery Type",
                      description: request!.deliveryType == BuyRequestDeliveryType.pickup ? 'Pickup' : 'Home Delivery',
                    ),

                    //? Only show the confirmation token when the value exists
                    //? and this is the buyer.
                    if (isBuyer && order?.token != null) ...[
                      // Some space.
                      Gap(25.h),

                      //? The details of the bid, starting with the section title.
                      Text(
                        "Confirmation Token",
                        style: wayaTheme.textTheme.bodyMedium,
                      ),

                      // Some space.
                      Gap(10.h),

                      //? The second position.
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: wayaTheme.colorScheme.greyColor50,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //? The confirmation token.
                            Text(
                              order?.token ?? "N/A",
                              style: wayaTheme.textTheme.bodyMedium,
                            ),

                            // Boundless space.
                            const Spacer(),

                            //? Finally, the button to copy the token to clipboard.
                            IconButton(
                              onPressed: () => WayaUtils.copyText(order?.token ?? "Not Available"),
                              icon: WayaAssets.icons.sCopy.svg(
                                colorFilter: ColorFilter.mode(wayaTheme.colorScheme.primary, BlendMode.srcIn),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Some space.
                    Gap(25.h),

                    //? The details of the bid, starting with the section title.
                    Text(
                      "Bid Details",
                      style: wayaTheme.textTheme.bodyMedium,
                    ),

                    // Some space.
                    Gap(10.h),

                    //? The delivery address.
                    if (request!.deliveryType == BuyRequestDeliveryType.delivery) ...[
                      OrderInfoWidget(
                        title: "Delivery Address",
                        description: request!.deliveryAddress ?? "No delivery address provided",
                      ),

                      // Some space.
                      Gap(8.h),
                    ] else ...[
                      // //
                      // OrderInfoWidget(
                      //   title: "Pickup Address",
                      //   description: bid.pickupAddress ?? "No pickup address provided",
                      // ),

                      // // Some space.
                      // Gap(8.h),
                    ],

                    //? The bid's amount.
                    OrderInfoWidget(
                      title: "Bid Amount",
                      description: WayaValueHelper.formatPrice(bid?.usedAmount ?? 0),
                    ),

                    // Some space.
                    Gap(8.h),

                    //? The status.
                    OrderInfoWidget(
                      title: "Order Status",
                      child: OrderStatusCard(order: order!),
                    ),

                    // Some space.
                    Gap(8.h),

                    //? The status.
                    if (request!.deliveryType == BuyRequestDeliveryType.delivery)
                      OrderInfoWidget(
                        title: "Delivery Status",
                        child: DeliveryStatusCard(status: status?.deliveryStatus ?? QuotationDeliveryStatus.pending),
                      )
                    else
                      OrderInfoWidget(
                        title: "Pickup Status",
                        child: PickupStatusCard(status: status?.pickupStatus ?? QuotationPickupStatus.pending),
                      ),

                    //? When this is for the seller, please include whether or
                    //? not this has been paid for.
                    if (!isBuyer) ...[
                      // Some space.
                      Gap(8.h),

                      //? Comment on the order.
                      OrderInfoWidget(
                        title: "Payment Status",
                        description: order?.isPaid ?? false ? "Paid" : "Unpaid",
                      ),
                    ],

                    // Some space.
                    Gap(8.h),

                    //? Comment on the order.
                    OrderInfoWidget(
                      title: "Comment",
                      description: "-",
                    ),

                    // Some space.
                    Gap(30.h),

                    //? The details of the bid, starting with the section title.
                    Text(
                      "Order Summary",
                      style: wayaTheme.textTheme.bodyMedium,
                    ),

                    // Some space.
                    Gap(10.h),

                    //? The delivery price of a bid.
                    OrderInfoWidget(
                      title: "Subtotal",
                      description: WayaValueHelper.formatPrice(subtotal),
                    ),

                    // Some space.
                    Gap(8.h),

                    //? The delivery price of a bid.
                    OrderInfoWidget(
                      title: "Delivery Price",
                      description: WayaValueHelper.formatPrice(bid?.deliveryCharge ?? 0),
                    ),

                    // Some space.
                    Gap(8.h),

                    //? The delivery price of a bid.
                    OrderInfoWidget(
                      title: "Total",
                      description: WayaValueHelper.formatPrice(subtotal + (bid?.deliveryCharge ?? 0)),
                    ),

                    //? Section for buttons that mutate the state of the order.
                    if (order!.orderStatus == QuotationOrderStatus.inProgress) ...[
                      // Some space.
                      Gap(30.h),

                      //? The button to change the status of the delivery.
                      if (isBuyer)
                        const SizedBox.shrink()
                      else if (request!.deliveryType == BuyRequestDeliveryType.delivery)
                        WayaButton(
                          color: wayaTheme.colorScheme.transparent,
                          textColor: wayaTheme.colorScheme.greyColor900,
                          border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
                          callback: () async {
                            final controller = ValueNotifier<QuotationDeliveryStatus?>(null);
                            final isLoading = ValueNotifier(false);

                            //? Show the modal sheet.
                            await WayaUtils.showModalSheet(
                              context,
                              child: UpdateDeliveryStatusModal(
                                notifier: notifier,
                                controller: controller,
                                isLoading: isLoading,
                                orderId: order!.id,
                              ),
                            );

                            //? Dispose these ones.
                            try {
                              _ingestOrder();
                              controller.dispose();
                              isLoading.dispose();
                            } catch (_) {}
                          },
                          text: "Change Delivery Status",
                          leadingIcon: WayaAssets.icons.vanIcon.svg(
                            colorFilter: ColorFilter.mode(wayaTheme.colorScheme.greyColor900, BlendMode.srcIn),
                            width: 20,
                          ),
                        )
                      else
                        WayaButton(
                          color: wayaTheme.colorScheme.transparent,
                          textColor: wayaTheme.colorScheme.greyColor900,
                          border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
                          callback: () async {
                            final controller = ValueNotifier<QuotationPickupStatus?>(null);
                            final isLoading = ValueNotifier(false);

                            //? Show the modal sheet.
                            await WayaUtils.showModalSheet(
                              context,
                              child: UpdatePickupStatusModal(
                                notifier: notifier,
                                controller: controller,
                                isLoading: isLoading,
                                orderId: order!.id,
                              ),
                            );

                            //? Dispose these ones.
                            try {
                              _ingestOrder();
                              controller.dispose();
                              isLoading.dispose();
                            } catch (_) {}
                          },
                          text: "Change Pickup Status",
                          leadingIcon: WayaAssets.icons.vanIcon.svg(
                            colorFilter: ColorFilter.mode(wayaTheme.colorScheme.greyColor900, BlendMode.srcIn),
                            width: 20,
                          ),
                        ),

                      // Some space.
                      Gap(10.h),

                      //? If this is for the buyer and the order has gotten to the
                      //? final step that needs confirmation...
                      if (!isBuyer && order?.orderStatus == QuotationOrderStatus.inProgress && hasArrived) ...[
                        // Some space.
                        Gap(30.h),

                        //
                        WayaButton(
                          color: wayaTheme.colorScheme.transparent,
                          textColor: wayaTheme.colorScheme.greyColor900,
                          border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
                          callback: () async => await WayaNav.to(
                            transition: Transition.rightToLeftWithFade,
                            ConfirmQuotationOrder(
                              request: request!,
                              bid: bid!,
                              order: order!,
                              user: user!,
                              notifier: notifier,
                            ),
                          ),
                          text: "Complete Order",
                          leadingIcon: WayaAssets.icons.buttonIcon.svg(
                            colorFilter: ColorFilter.mode(wayaTheme.colorScheme.greyColor900, BlendMode.srcIn),
                            width: 20,
                          ),
                        ),
                      ]

                      //? The button to change the order status.
                      else if (!isBuyer && order?.orderStatus == QuotationOrderStatus.inProgress)
                        WayaButton(
                          color: wayaTheme.colorScheme.transparent,
                          textColor: wayaTheme.colorScheme.greyColor900,
                          border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
                          callback: () async {
                            final controller = ValueNotifier<QuotationOrderStatus?>(null);
                            final isLoading = ValueNotifier(false);

                            //? Show the modal sheet.
                            await WayaUtils.showModalSheet(
                              context,
                              child: UpdateOrderStatusModal(
                                notifier: notifier,
                                controller: controller,
                                isLoading: isLoading,
                                orderId: order!.id,
                              ),
                            );

                            //? Dispose these ones.
                            try {
                              controller.dispose();
                              isLoading.dispose();
                            } catch (_) {}
                          },
                          text: "Change Order Status",
                          leadingIcon: WayaAssets.icons.buttonIcon.svg(
                            colorFilter: ColorFilter.mode(wayaTheme.colorScheme.greyColor900, BlendMode.srcIn),
                            width: 20,
                          ),
                        ),
                    ],
                  ],
                ),
    );
  }
}

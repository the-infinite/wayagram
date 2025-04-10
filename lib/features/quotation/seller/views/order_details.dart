import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/quotation/quotation_bottomsheet_modal/quotation_modal.dart';
import 'package:wayagram/features/shop/order/widgets/order_info_widget.dart';
import 'package:wayagram/features/shop/widgets/about_product.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';
import 'package:wayagram/shared/features/quotation/widget/bid_status.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

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
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final notifier = ref.read(userQuotationsProvider.notifier);
    final request = notifier.getBidQuote(widget.requestId)!;

    //? Return the component.
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: 'Order Details',
      body: WayaFutureSubscriber(
        future: notifier.getOrderDetails(widget.requestId),
        suspense: (context) => const SizedBox(),
        builder: (context, data) {
          if (data == null) {
            return const SizedBox();
          }

          //? Find and return the order.
          final order = data;

          //? Return the column.
          return Column(
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
                content: request.productName,
              ),

              // Some space.
              Gap(15.h),

              if (request.brand?.isNotEmpty ?? false) ...[
                //? The brand name.
                AboutProduct(
                  title: 'Brand Name',
                  content: request.brand!,
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
                      content: request.category,
                    ),
                  ),

                  //? This is fine.
                  Expanded(
                    child: AboutProduct(
                      title: 'Product Condition',
                      content: request.condition,
                    ),
                  )
                ],
              ),

              // Some space.
              Gap(15.h),

              //?  The description of the product.
              AboutProduct(
                title: 'Product Description',
                content: request.description,
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
                      content: WayaValueHelper.formatNumber(request.quantity),
                    ),
                  ),

                  //? Second, the state it was bought in.
                  Expanded(
                    flex: 2,
                    child: AboutProduct(
                      title: 'State of Purchase',
                      content: request.stateOfPurchase,
                    ),
                  ),

                  //? Finally, the location.
                  Expanded(
                    child: AboutProduct(
                      title: 'LGA',
                      content: request.lga,
                    ),
                  )
                ],
              ),

              // Some space.
              Gap(30.h),

              //? The starting amount for bidding.
              OrderInfoWidget(
                title: "Bid Starting Amount",
                description: WayaValueHelper.formatPrice(request.bidStartingAmount),
              ),

              // Some space.
              Gap(25.h),

              //? The customer details section title..
              Text(
                "Customer Details",
                style: wayaTheme.textTheme.bodyMedium,
              ),

              // Some space.
              Gap(15.h),

              //? The name of the customer.
              WayaFutureSubscriber(
                future: UserResource.getUserDetails(request.buyerId),
                builder: (context, data) {
                  //? Return null as a failsafe.
                  if (data == null) {
                    return const SizedBox();
                  }

                  //? Then return the buyer's information.
                  return OrderInfoWidget(
                    title: "Customer's Name",
                    description: data.$1.fullname,
                  );
                },
              ),

              // Some space.
              Gap(8.h),

              //? The delivery type.
              OrderInfoWidget(
                title: "Delivery Type",
                description: request.deliveryType == BuyRequestDeliveryType.pickup ? 'Pickup' : 'Home Delivery',
              ),

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
              if (request.deliveryType == BuyRequestDeliveryType.delivery) ...[
                OrderInfoWidget(
                  title: "Delivery Address",
                  description: request.deliveryAddress ?? "No delivery address provided",
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
                description: WayaValueHelper.formatPrice(order.amount),
              ),

              // Some space.
              Gap(8.h),

              //? The status.
              OrderInfoWidget(
                title: "Bid Status",
                child: OrderStatusCard(order: order),
              ),

              // Some space.
              Gap(8.h),

              //? The delivery price of a bid.
              OrderInfoWidget(
                title: "Delivery Price",
                description: WayaValueHelper.formatPrice(99999),
              ),

              // Some space.
              Gap(8.h),

              //? The delivery date.
              OrderInfoWidget(
                title: "Delivery Date",
                description: WayaDateHelper.getDailyTimestamp(order.updatedAt),
              ),

              // Some space.
              Gap(8.h),

              //? Comment on the order.
              OrderInfoWidget(
                title: "Comment",
                description: '-',
              ),

              // Some space.
              Gap(30.h),

              //? The button to change the status of the delivery.
              if (request.deliveryType == BuyRequestDeliveryType.delivery)
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
                        orderId: order.id,
                      ),
                    );

                    //? Dispose these ones.
                    try {
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
                        orderId: order.id,
                      ),
                    );

                    //? Dispose these ones.
                    try {
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

              //? The button to change the order status.
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
                      orderId: order.id,
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
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/widgets/about_product.dart';
import 'package:wayagram/features/shop/order/widgets/order_info_widget.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';
import 'package:wayagram/shared/features/quotation/widget/bid_status.dart';
import 'package:wayagram/shared/features/quotation/widget/bid_timer.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

class SellerBidDetails extends ConsumerStatefulWidget {
  static const route = '/quotation/seller/bid';
  final String id;
  final String requestId;

  //? This is fine.
  const SellerBidDetails({
    super.key,
    required this.id,
    required this.requestId,
  });

  @override
  ConsumerState<SellerBidDetails> createState() => _SellerBidDetailsState();
}

class _SellerBidDetailsState extends ConsumerState<SellerBidDetails> {
  //? Final attempt.

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final notifier = ref.read(userQuotationsProvider.notifier);
    final bid = notifier.getBid(widget.id)!;
    final request = notifier.getBidQuote(widget.requestId)!;

    //? Return the component.
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: 'Bid Details',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //? Header 1.
          Text(
            "Bid Details",
            style: wayaTheme.textTheme.headlineLarge,
          ),

          // Some space.
          Gap(3.h),

          //? Subtitle.
          Text(
            'View and manage this bid',
            style: wayaTheme.textTheme.hintStyle,
          ),

          //? Some space.
          Gap(20.h),

          //? Some other text.
          Align(
            alignment: Alignment.center,
            child: Text(
              'Bid Time Remaining',
              style: wayaTheme.textTheme.hintStyle,
            ),
          ),

          // Some space.
          Gap(10.h),

          //? Show the bid timer
          Align(
            alignment: Alignment.center,
            child: QuotationBidTimer(
              request: request,
            ),
          ),

          // Some space.
          Gap(30.h),

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
            description: WayaValueHelper.formatPrice(bid.amount),
          ),

          // Some space.
          Gap(8.h),

          //? The status.
          OrderInfoWidget(
            title: "Bid Status",
            child: BidStatusCard(bid: bid),
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
            description: WayaDateHelper.getDailyTimestamp(bid.updatedAt),
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

          //? The button to change the order status.
          if (bid.status == BidActionType.accept)
            WayaButton(
              color: wayaTheme.colorScheme.transparent,
              textColor: wayaTheme.colorScheme.greyColor900,
              border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
              callback: () => WayaNav.toNamed(WayaAppRoutes.getQuotationOrderDetailsScreen(bid.requestId)),
              text: "Proceed to order fulfillment",
              leadingIcon: WayaAssets.icons.orders.svg(
                colorFilter: ColorFilter.mode(wayaTheme.colorScheme.greyColor900, BlendMode.srcIn),
                width: 20,
              ),
            ),
        ],
      ),
    );
  }
}

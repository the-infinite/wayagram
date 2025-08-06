// ignore_for_file: use_build_context_synchronously

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
import 'package:wayagram/features/polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';
import 'package:wayagram/features/quotation/seller/views/create_bid/create_bid.dart';
import 'package:wayagram/features/shop/widgets/about_product.dart';
import 'package:wayagram/features/shop/order/widgets/order_info_widget.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';
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
  late final notifier = ref.read(userQuotationsProvider.notifier);
  final loadingController = ValueNotifier(false);
  CachedUserDataTuple? _buyerDetails;

  Future<void> _placeBid(BuyRequestModel request) async {
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
    final request = notifier.getBidQuote(widget.requestId)!;

    //? Send the user to the screen dedicated to the cause.
    WayaNav.to(CreateBidScreen(request: request), transition: Transition.downToUp);
  }

  Future<void> _viewSellerBid(QuotationBidModel result) async {
    WayaNav.toNamed(WayaAppRoutes.getSellerBidsRoute(result.id, result.requestId));
  }

  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //? Get the buyer's details.
      final request = notifier.getBidQuote(widget.requestId)!;
      _buyerDetails = await UserResource.getUserDetails(request.buyerId);
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
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
              isExpanded: true,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
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
          if (_buyerDetails == null)
            const SizedBox()
          else
            GestureDetector(
              onTap: () => WayaNav.toNamed(WayaAppRoutes.getProfileRoute(_buyerDetails!.$1.id, "quotation")),
              child: OrderInfoWidget(
                title: "Customer's Name",
                description: _buyerDetails!.$1.fullname,
              ),
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
              description: request.deliveryAddress ?? "N/A",
            ),

            // Some space.
            Gap(8.h),
            //   ] else ...[
            //     //
            //     OrderInfoWidget(
            //       title: "Pickup Address",
            //       description: bid.pickupAddress ?? "No pickup address provided",
            //     ),

            //     // Some space.
            //     Gap(8.h),
          ],

          //? The bid's amount.
          OrderInfoWidget(
            title: "Delivery Fee",
            description: WayaValueHelper.formatPrice(bid.deliveryCharge ?? 0),
          ),

          // Some space.
          Gap(8.h),

          //? The status.
          OrderInfoWidget(
            title: "Bid Status",
            child: BidStatusCard(bid: bid),
          ),

          // Some space.
          Gap(30.h),

          //? The button to change the order status.
          //   if (bid.status == BidActionType.accept)
          //     WayaButton(
          //       color: wayaTheme.colorScheme.transparent,
          //       textColor: wayaTheme.colorScheme.greyColor900,
          //       border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
          //       callback: () => WayaNav.toNamed(WayaAppRoutes.getQuotationOrderDetailsScreen(bid.requestId)),
          //       text: "View Order",
          //       leadingIcon: WayaAssets.icons.orders.svg(
          //         colorFilter: ColorFilter.mode(wayaTheme.colorScheme.greyColor900, BlendMode.srcIn),
          //         width: 20,
          //       ),
          //     )
          //   else
          if (bid.status == BidActionType.reject)
            WayaProgressiveButton(
              callback: () => _placeBid(request),
              text: 'Bid Again',
              height: 48,
              notifier: loadingController,
              leadingIcon: WayaAssets.icons.bid.svg(
                colorFilter: ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
                width: 20,
              ),
            )
          else
            WayaProgressiveButton(
              callback: () => _viewSellerBid(bid),
              text: 'View Bid',
              height: 48,
              notifier: loadingController,
            ),
        ],
      ),
    );
  }
}

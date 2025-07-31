import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/quotation/buyer/views/create_request/steps/preview_request.dart';
import 'package:wayagram/features/quotation/seller/vm/create_bid.dart';
import 'package:wayagram/features/shop/widgets/about_product.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';

class BidConfirmationStep extends ConsumerStatefulWidget {
  final CreateBidProvider provider;
  final CreateBidVm notifier;
  final BuyRequestModel request;
  final Function(int index) jumpTo;
  final Function gotoPreviousTab;

  // Construct.
  const BidConfirmationStep({
    super.key,
    required this.jumpTo,
    required this.gotoPreviousTab,
    required this.request,
    required this.provider,
    required this.notifier,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BidOverviewStepState();
}

class _BidOverviewStepState extends ConsumerState<BidConfirmationStep> {
  final loadingController = ValueNotifier(false);

  //? View seller bid.
  Future<void> _viewSellerBid(QuotationBidModel result) async {
    WayaNav.toNamed(WayaAppRoutes.getSellerBidsRoute(result.id, result.requestId));
  }

  //? Place bid.
  Future<void> _placeBid() async {
    //? Now, send the bid.
    final result = await widget.notifier.sendBid();

    //! Since bidding failed, you can leave.
    if (result == null) return;

    //* Okay, since bidding was fine, we throw a pizza party.
    _viewSellerBid(result);
  }

  //? Dispose this one.
  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //?
    final wayaTheme = Theme.of(context);
    final state = ref.watch(widget.provider);

    //? Return the
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //? Page title.
          Text(
            "Preview Bid",
            style: wayaTheme.textTheme.titleLarge,
          ),

          // Some space.
          const Gap(5),

          //? Page subtitle.
          Text(
            "Great, you have finished making your bid! Let's run through it to make sure we didn't miss anything.",
            style: wayaTheme.textTheme.hintStyle,
          ),

          // Some space.
          const Gap(25),

          //? How to edit this one.
          EditHeader(
            onTap: () => widget.jumpTo(0),
            title: 'Product Information',
          ),

          // Space.
          const Gap(30),

          //? The name of this product.
          AboutProduct(
            title: 'Product Name',
            content: widget.request.productName,
          ),

          //? If there is no brand name, don't show this.
          if (widget.request.brand?.isNotEmpty ?? false) ...[
            // Some space.
            const Gap(15),

            //? The brand name of the product.
            AboutProduct(
              title: 'Brand Name',
              content: '${widget.request.brand!.capitalizeFirst}',
            ),
          ],

          // Some more space.
          const Gap(15),

          //? The product's category and condition.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AboutProduct(
                  title: 'Request Category',
                  content: widget.request.category,
                ),
              ),
              Expanded(
                child: AboutProduct(
                  title: 'Required Condition',
                  content: widget.request.condition,
                ),
              )
            ],
          ),

          // Some more space.
          const Gap(15),

          //? The description of the product.
          AboutProduct(
            title: 'Request Description',
            content: widget.request.description,
          ),

          // Some more space.
          const Gap(15),

          //? The description of the product.
          AboutProduct(
            title: 'Provided Comment',
            content: state.description ?? "N/A",
          ),

          // Some more space.
          const Gap(15),

          //? The distance and delivery type.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AboutProduct(
                  title: 'Provided Condition',
                  content: state.condition ?? "N/A",
                ),
              ),
            ],
          ),

          // Some more space.
          const Gap(15),

          //? The quantity, state of purchase and LGA.
          AboutProductImage(
            title: "Provided Images",
            content: state.images ?? [],
          ),

          // Some more space.
          const Gap(30),

          //? For the pricing and delivery section.
          EditHeader(
            onTap: () => widget.jumpTo(1),
            title: 'Pricing & Delivery',
          ),

          // Some space.
          const Gap(30),

          //? For the bid starting and maximum amounts.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //? Maximum bid amount.
              if (widget.request.maximumUnitPrice != null)
                Expanded(
                  child: AboutProduct(
                    title: 'Maximum Bid Amount',
                    content: '${WayaValueHelper.formatPrice(widget.request.maximumUnitPrice!)} per unit',
                  ),
                ),

              //? Desired quantity
              Expanded(
                child: AboutProduct(
                  title: 'Quantity',
                  content: widget.request.quantity.toString(),
                ),
              ),
            ],
          ),

          // Some more space.
          const Gap(15),

          //? Now, for how much the user offered...
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 10.w,
            children: [
              //? Maximum bid amount.
              Expanded(
                child: AboutProduct(
                  title: 'Offer Per Unit',
                  content: '${WayaValueHelper.formatPrice(state.unitPrice ?? 0)} per unit',
                ),
              ),

              //? Desired quantity
              Expanded(
                child: AboutProduct(
                  title: 'Final Offer',
                  content: WayaValueHelper.formatPrice(widget.request.quantity * (state.unitPrice ?? 0)),
                ),
              ),
            ],
          ),

          //? For deliveries.
          if (widget.request.deliveryType == BuyRequestDeliveryType.delivery) ...[
            // Some more space.
            const Gap(30),

            //? First, the delivery address...
            AboutProduct(
              title: 'Delivery Address',
              content: widget.request.deliveryAddress ?? "N/A",
            ),

            // Some more space.
            const Gap(15),

            //? For delivery state and LGA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 10.w,
              children: [
                Expanded(
                  child: AboutProduct(
                    title: 'State',
                    content: widget.request.deliveryState ?? "N/A",
                  ),
                ),
                Expanded(
                  child: AboutProduct(
                    title: 'LGA',
                    content: widget.request.deliveryLga ?? "N/A",
                  ),
                )
              ],
            ),

            // Some more space.
            const Gap(15),

            //? For the bid start and end times.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AboutProduct(
                    title: 'Delivery Date',
                    content: WayaDateHelper.getDailyTimestamp(state.readyDate ?? DateTime.now()),
                  ),
                ),
                Expanded(
                  child: AboutProduct(
                    title: 'Delivery Cost',
                    content: WayaValueHelper.formatPrice(state.deliveryCharge ?? 0),
                  ),
                ),
              ],
            ),
          ],

          // Some space.
          const Gap(40),

          //? OUr button for this one.
          WayaProgressiveButton(
            callback: _placeBid,
            notifier: loadingController,
            text: "Place Bid",
          ),

          // Some space.
          const Gap(8),

          //? Navigate backward.
          WayaButton(
            text: 'Go Back',
            color: wayaTheme.colorScheme.transparent,
            textColor: wayaTheme.colorScheme.customBlack,
            border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
            callback: () => widget.gotoPreviousTab(),
          ),
        ],
      ),
    );
  }
}

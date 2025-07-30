import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/quotation/seller/vm/create_bid.dart';
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
  Future<void> _viewSellerBid(QuotationBidModel result) async {
    WayaNav.toNamed(WayaAppRoutes.getSellerBidsRoute(result.id, result.requestId));
  }

  Future<void> _placeBid() async {
    //? Then move forward.
    // final request = wayaQuotationsCache.getCachedData(widget.data.id) ?? widget.data;
    // final amount = await WayaUtils.showModalSheet<double>(
    //   context,
    //   child: EditOfferModal(
    //     title: 'Edit your Offer',
    //     hint: 'Update your base price for this request',
    //     delta: request.bidStartingAmount >= 3000000
    //         ? 25000
    //         : request.bidStartingAmount >= 200000
    //             ? 5000
    //             : 1000,
    //   ),
    // );

    // //! If this was dismissed before an amount was even calculated...
    // if (amount == null) return;

    // //? Which shop is the user sending the bid as?
    // final shopId = await WayaUtils.showModalSheet(context, child: ChooseShopModal());

    // //! If the shop was not selected.
    // if (shopId == null) return;

    // double? deliveryCost;

    // //? If this is a delivery request and the delivery address is not null.
    // //? After the shop is selected, we need to confirm the delivery cost with
    // //? the seller.
    // if (request.deliveryAddress != null) {
    //   final cost = await WayaUtils.showModalSheet<double>(
    //     context,
    //     child: EditOfferModal(
    //       title: 'Delivery Cost',
    //       hint: 'Enter your delivery cost for this order to deliver to\n\n${request.deliveryAddress}',
    //       delta: request.bidStartingAmount >= 3000000
    //           ? 25000
    //           : request.bidStartingAmount >= 200000
    //               ? 5000
    //               : 1000,
    //     ),
    //   );

    //   //? Since const is null.
    //   if (cost == null) return;

    //   //? Now we can try again.
    //   deliveryCost = cost;
    // }

    // //? Now, send the bid.
    // final result = await widget.notifier.sendBid(request.id, amount, shopId, deliveryCost);

    // //! Since bidding failed, you can leave.
    // if (result == null) return;

    // //* Okay, since bidding was fine, we throw a pizza party.
    // _viewSellerBid(result);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

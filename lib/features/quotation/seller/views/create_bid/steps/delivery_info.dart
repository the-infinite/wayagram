import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/quotation/seller/vm/create_bid.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';

class BidDeliveryInfoStep extends ConsumerStatefulWidget {
  final CreateBidProvider provider;
  final CreateBidVm notifier;
  final BuyRequestModel request;
  final Function gotoNextTab;
  final Function gotoPreviousTab;

  // Construct.
  const BidDeliveryInfoStep({
    super.key,
    required this.gotoNextTab,
    required this.gotoPreviousTab,
    required this.request,
    required this.provider,
    required this.notifier,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BidOverviewStepState();
}

class _BidOverviewStepState extends ConsumerState<BidDeliveryInfoStep> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

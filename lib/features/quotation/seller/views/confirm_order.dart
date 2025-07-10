import 'package:flutter/material.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

class ConfirmQuotationOrder extends StatefulWidget {
  final BuyRequestModel request;
  final QuotationBidModel bid;
  final BidOrderModel order;
  final CachedUserDataTuple user;

  // Construct.
  const ConfirmQuotationOrder({
    super.key,
    required this.request,
    required this.bid,
    required this.order,
    required this.user,
  });

  @override
  State<ConfirmQuotationOrder> createState() => _ConfirmQuotationOrderState();
}

class _ConfirmQuotationOrderState extends State<ConfirmQuotationOrder> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

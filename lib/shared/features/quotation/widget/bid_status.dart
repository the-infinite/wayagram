import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';

class BidStatusCard extends StatelessWidget {
  final QuotationBidModel bid;

  // Construct.
  const BidStatusCard({
    super.key,
    required this.bid,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? Return the status card.
    return Container(
      padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
      decoration: BoxDecoration(
        color: switch (bid.status) {
          BidActionType.negotiate => wayaTheme.colorScheme.primary50,
          BidActionType.accept => wayaTheme.colorScheme.success50,
          BidActionType.reject => wayaTheme.colorScheme.error50,
          _ => wayaTheme.colorScheme.pending50,
        },
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        switch (bid.status) {
          BidActionType.negotiate => "Negotiating",
          BidActionType.accept => "Won",
          BidActionType.reject => "Closed",
          _ => "Open",
        },
        style: wayaTheme.textTheme.bodyMedium?.copyWith(
          color: switch (bid.status) {
            BidActionType.negotiate => wayaTheme.colorScheme.primary,
            BidActionType.accept => wayaTheme.colorScheme.success,
            BidActionType.reject => wayaTheme.colorScheme.error,
            _ => wayaTheme.colorScheme.pending,
          },
          fontWeight: FontWeight.w500,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}

class OrderStatusCard extends StatelessWidget {
  final BidOrderModel order;

  const OrderStatusCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? Return the status card.
    return Container(
      padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
      decoration: BoxDecoration(
        color: switch (order.orderStatus) {
          QuotationOrderStatus.inProgress => wayaTheme.colorScheme.info50,
          QuotationOrderStatus.completed => wayaTheme.colorScheme.success50,
          QuotationOrderStatus.failed => wayaTheme.colorScheme.error50,
        },
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        switch (order.orderStatus) {
          QuotationOrderStatus.inProgress => "Ongoing",
          QuotationOrderStatus.completed => "Completed",
          QuotationOrderStatus.failed => "Cancelled",
        },
        style: wayaTheme.textTheme.bodyMedium?.copyWith(
          color: switch (order.orderStatus) {
            QuotationOrderStatus.inProgress => wayaTheme.colorScheme.info,
            QuotationOrderStatus.completed => wayaTheme.colorScheme.success,
            QuotationOrderStatus.failed => wayaTheme.colorScheme.error,
          },
          fontWeight: FontWeight.w500,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}

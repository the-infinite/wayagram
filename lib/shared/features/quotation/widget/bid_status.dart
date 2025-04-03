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

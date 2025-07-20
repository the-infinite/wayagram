import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/chat/state/default.dart';
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

class DeliveryStatusCard extends StatelessWidget {
  final QuotationDeliveryStatus status;

  // Construct.
  const DeliveryStatusCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? Return the status card.
    return Container(
      padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
      decoration: BoxDecoration(
        color: switch (status) {
          QuotationDeliveryStatus.pending ||
          QuotationDeliveryStatus.processing ||
          QuotationDeliveryStatus.readyForDispatch =>
            wayaTheme.colorScheme.info50,
          QuotationDeliveryStatus.outForDelivery ||
          QuotationDeliveryStatus.inTransit =>
            wayaTheme.colorScheme.primary50,
          QuotationDeliveryStatus.delivered => wayaTheme.colorScheme.success50,
        },
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        switch (status) {
          QuotationDeliveryStatus.pending => "Pending",
          QuotationDeliveryStatus.processing => "Processing",
          QuotationDeliveryStatus.readyForDispatch => "Ready for Dispatch",
          QuotationDeliveryStatus.inTransit => throw "In Transit",
          QuotationDeliveryStatus.outForDelivery => "Out for Delivery",
          QuotationDeliveryStatus.delivered => "Delivered",
        },
        style: wayaTheme.textTheme.bodyMedium?.copyWith(
          color: switch (status) {
            QuotationDeliveryStatus.pending ||
            QuotationDeliveryStatus.processing ||
            QuotationDeliveryStatus.readyForDispatch =>
              wayaTheme.colorScheme.info,
            QuotationDeliveryStatus.outForDelivery ||
            QuotationDeliveryStatus.inTransit =>
              wayaTheme.colorScheme.primary,
            QuotationDeliveryStatus.delivered => wayaTheme.colorScheme.success,
          },
          fontWeight: FontWeight.w500,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}

class PickupStatusCard extends StatelessWidget {
  final QuotationPickupStatus status;

  // Construct.
  const PickupStatusCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? Return the status card.
    return Container(
      padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
      decoration: BoxDecoration(
        color: switch (status) {
          QuotationPickupStatus.pending => wayaTheme.colorScheme.info50,
          QuotationPickupStatus.ready || QuotationPickupStatus.scheduled => wayaTheme.colorScheme.primary50,
          QuotationPickupStatus.collected => wayaTheme.colorScheme.success50,
        },
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        switch (status) {
          QuotationPickupStatus.pending => "Pending",
          QuotationPickupStatus.ready => "Ready for Pickup",
          QuotationPickupStatus.scheduled => "Pickup Scheduled",
          QuotationPickupStatus.collected => "Picked Up",
        },
        style: wayaTheme.textTheme.bodyMedium?.copyWith(
          color: switch (status) {
            QuotationPickupStatus.pending => wayaTheme.colorScheme.info,
            QuotationPickupStatus.ready || QuotationPickupStatus.scheduled => wayaTheme.colorScheme.primary,
            QuotationPickupStatus.collected => wayaTheme.colorScheme.success,
          },
          fontWeight: FontWeight.w500,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}

class BidNegotiationStatusCard extends StatelessWidget {
  final QuotationBidModel bid;
  final BidActionAuthor user;

  const BidNegotiationStatusCard(
      {super.key, required this.bid, required this.user});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final isMe = bid.lastCounterSentBy == user;

    //? Return the status card.
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: switch (bid.status) {
            BidActionType.negotiate =>
              isMe ? wayaTheme.colorScheme.primary : wayaTheme.colorScheme.info,
            BidActionType.reject => wayaTheme.colorScheme.error,
            _ => wayaTheme.colorScheme.success,
          },
          borderRadius: BorderRadius.circular(6000.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 2.w,
          children: [
            //? Then the picture for this bid status.
            SvgPicture.asset(
              switch (bid.status) {
                BidActionType.accept => WayaAssets.icons.bid.path,
                BidActionType.reject => WayaAssets.icons.bidError.path,
                BidActionType.negotiate => isMe
                    ? WayaAssets.icons.bidSent.path
                    : WayaAssets.icons.bidReceived.path,
                _ => bid.vendorId == ConversationState.self.id
                    ? WayaAssets.icons.bidSent.path
                    : WayaAssets.icons.bidReceived.path,
              },
              colorFilter: ColorFilter.mode(
                wayaTheme.colorScheme.white,
                BlendMode.srcIn,
              ),
              height: 12.sp,
            ),

            //? The text in this place.
            Text(
              switch (bid.status) {
                BidActionType.negotiate =>
                  isMe ? "Counteroffer Sent" : "Counteroffer received",
                BidActionType.accept => "Accepted",
                BidActionType.reject => isMe ? "Declined" : "Rejected",
                _ => "Open Bid",
              },
              style: wayaTheme.textTheme.bodyMedium?.copyWith(
                color: switch (bid.status) {
                  _ => wayaTheme.colorScheme.white,
                },
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
            )
          ],
        ),
      ),
    );
  }
}

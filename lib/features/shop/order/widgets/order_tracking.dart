import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/features/shop/order/data/model/order_state.dart';

class OrderStatus {
  final bool status;
  final String title;
  final String description;
  final String date;
  final String time;

  OrderStatus({
    required this.description,
    required this.title,
    required this.status,
    required this.time,
    required this.date,
  });
}

class OrderTracking extends StatefulWidget {
  final String? status;
  final String? type;
  final List<String> statuses;
  final List<CartOrderStatus>? currentStatuses;

  const OrderTracking({
    super.key,
    this.status,
    required this.type,
    required this.statuses,
    this.currentStatuses,
  });

  @override
  State<OrderTracking> createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {
  final DateFormat formatter = DateFormat('dd MMM.');

  List<OrderStatus> orderStatusList = [];
  List<String> currentStatusList = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      currentStatusList =
          widget.currentStatuses?.map((s) => s.status).toList() ?? [];
    });
    _updateOrderStatusList();
  }

  @override
  void didUpdateWidget(covariant OrderTracking oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStatuses != oldWidget.currentStatuses) {
      _updateOrderStatusList();
    }
  }

  void _updateOrderStatusList() {
    final List<String> expectedStatuses =
        widget.type == 'Pickup' ? pickupStatus : deliveryStatus;

    // final List<String> currentStatusList =
    //     widget.currentStatuses?.map((s) => s.status.toLowerCase()).toList() ??
    //         [];
    int lastActiveIndex = expectedStatuses
        .lastIndexWhere((status) => currentStatusList.contains(status));

    setState(() {
      orderStatusList = expectedStatuses.map((s) {
        final int statusIndex = expectedStatuses.indexOf(s);
        final bool isActive = statusIndex <= lastActiveIndex;
        final CartOrderStatus? cartStatus = widget.currentStatuses
            ?.firstWhereOrNull((c) => c.status.toLowerCase() == s);
        final DateTime? updatedAt =
            cartStatus != null ? DateTime.tryParse(cartStatus.updatedAt) : null;
        final String formattedDate =
            updatedAt != null ? formatter.format(updatedAt) : '';
        final String formattedTime =
            updatedAt != null ? DateFormat('h:mm a').format(updatedAt) : '';

        return OrderStatus(
          description: getStatusDescription(s),
          title: getStatusTitle(s),
          date: formattedDate,
          time: formattedTime,
          status: isActive,
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(orderStatusList.length, (index) {
        return StepWidget(
          orderStatus: orderStatusList[index],
          isNotLast: index != orderStatusList.length - 1,
        );
      }),
    );
  }

  String getStatusDescription(String status) {
    switch (status) {
      case 'pending':
        return "Your order has been received and is awaiting confirmation";
      case 'processing':
        return "We are preparing your order for delivery";
      case 'onTransit':
        return "Your order is on its way to your location";
      case 'completed':
        return "Your order has been delivered";
      case 'readyForPickUp':
        return "Your order is ready for pickup";
      case 'pickUpScheduled':
        return "Your order is scheduled for pickup";
      default:
        return "";
    }
  }

  String getStatusTitle(String status) {
    switch (status) {
      case 'pending':
        return "Pending";
      case 'processing':
        return "Processing";
      case 'onTransit':
        return "In Transit";
      case 'completed':
        return "Delivered";
      case 'readyForPickUp':
        return "Ready for Pickup";
      case 'pickUpScheduled':
        return "Pickup Scheduled";
      default:
        return "";
    }
  }
}

class StepWidget extends StatelessWidget {
  final OrderStatus orderStatus;
  final bool isNotLast;
  const StepWidget({
    super.key,
    required this.orderStatus,
    required this.isNotLast,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepIndicator(
                status: orderStatus.status, showStraightLine: isNotLast),
            const Gap(12),
            SizedBox(
              width: context.width * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderStatus.title,
                    style: wayaTheme.textTheme.bodyMedium,
                  ),
                  const Gap(8),
                  Text(
                    orderStatus.description,
                    style: wayaTheme.textTheme.hintStyle,
                  ),
                ],
              ),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              orderStatus.date,
              style: wayaTheme.textTheme.hintStyle,
            ),
            const Gap(8),
            Text(
              orderStatus.time,
              style: wayaTheme.textTheme.hintStyle,
            ),
          ],
        )
      ],
    );
  }
}

class StepIndicator extends StatelessWidget {
  final bool status;
  final bool showStraightLine;
  const StepIndicator({
    super.key,
    required this.status,
    required this.showStraightLine,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 1,
              color: !status
                  ? wayaTheme.colorScheme.greyColor300
                  : wayaTheme.colorScheme.customPrimary,
            ),
          ),
          child: Center(
            child: !status
                ? const SizedBox()
                : Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.customPrimary,
                      shape: BoxShape.circle,
                    ),
                  ),
          ),
        ),
        const Gap(6),
        if (showStraightLine) StraightLineVertical(status: status),
        const Gap(6),
      ],
    );
  }
}

class StraightLineVertical extends StatelessWidget {
  final bool status;
  const StraightLineVertical({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Container(
        width: 1,
        height: 60,
        color: status
            ? Theme.of(context).colorScheme.customPrimary
            : Theme.of(context).colorScheme.greyColor300,
      ),
    );
  }
}

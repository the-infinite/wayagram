import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';

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

class OrderTracking extends StatelessWidget {
  final String? status;
  const OrderTracking({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    // Define the order statuses
    final List<String> statuses = [
      'pending',
      'processing',
      'in_transit',
      'out_for_delivery',
      'delivered',
    ];

    // Determine the index of the current status
    final currentStatusIndex = status != null ? statuses.indexOf(status!) : -1;

    // Create the list of order statuses
    List<OrderStatus> orderStatus = [
      OrderStatus(
        description:
            "Your order has been received and is awaiting confirmation",
        title: "Pending",
        date: '10 Oct.',
        time: '9:00PM',
        status: currentStatusIndex >= 0,
      ),
      OrderStatus(
        description: "We are preparing your order for delivery",
        title: "Processing",
        time: '9:00PM',
        date: '10 Oct.',
        status: currentStatusIndex >= 1,
      ),
      OrderStatus(
        description: "Your order is on its way to your location",
        title: "In Transit",
        time: '9:00PM',
        date: '10 Oct.',
        status: currentStatusIndex >= 2,
      ),
      OrderStatus(
        description: "Your order is out for delivery",
        title: "Out for Delivery",
        date: '10 Oct.',
        time: '9:00PM',
        status: currentStatusIndex >= 3,
      ),
      OrderStatus(
        description: "Your order has been delivered",
        title: "Delivered",
        date: '10 Oct.',
        time: '9:00PM',
        status: currentStatusIndex >= 4,
      ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(orderStatus.length, (index) {
        return StepWidget(
          orderStatus: orderStatus[index],
          isNotLast: index != orderStatus.length - 1,
        );
      }),
    );
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
                    style: wayaTheme.textTheme.bodyLarge,
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

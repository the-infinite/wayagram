import 'package:flutter/material.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';

class OrderState {
  final bool isLoading;
  final bool isRejecting;
  final TextEditingController search;

  OrderState({
    this.isLoading = false,
    this.isRejecting = false,
    TextEditingController? search,
  }) : search = search ?? TextEditingController();

  OrderState copyWith(
      {TextEditingController? search, bool? isRejecting, bool? isLoading}) {
    return OrderState(
        isLoading: isLoading ?? this.isLoading,
        isRejecting: isRejecting ?? this.isRejecting,
        search: search ?? this.search);
  }
}

class OrderDetailArg {
  final String type;
  final Order order;

  OrderDetailArg({required this.type, required this.order});
}

const deliveryStatus = ['pending', 'processing', 'onTransit', 'completed'];
const pickupStatus = [
  'pending',
  'readyForPickUp',
  'pickUpScheduled',
  'completed'
];

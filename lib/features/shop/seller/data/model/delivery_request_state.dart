import 'package:flutter/material.dart';
import 'package:wayagram/features/shop/seller/data/model/delivery_request_response_model.dart';
class DeliveryRequestState {
  final bool isLoading;
  final List<DeliveryRequestData> deliveryRequests;
  final TextEditingController search;

  DeliveryRequestState(
      {this.deliveryRequests = const [],
      this.isLoading = false,
      TextEditingController? search})
      : search = search ?? TextEditingController();

  DeliveryRequestState copyWith({
      bool? isLoading, TextEditingController? search, List<DeliveryRequestData>? deliveryRequest}) {
    return DeliveryRequestState(
        deliveryRequests: deliveryRequest ?? this.deliveryRequests,
        isLoading: isLoading ?? this.isLoading,
        search: search ?? this.search);
  }
}

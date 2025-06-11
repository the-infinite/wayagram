import 'package:flutter/foundation.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class OrderRepository extends BaseRepository {
  static const serviceUrl = "wayagram-shop/api/v2";

  Future<WayaRequestResponse> createOrder(
      {required String cartId,
      required String shopId,
      required String userId,
      String? pickupAddress}) {
    Map<String, dynamic> payload = {
      'cartId': cartId,
      'shopId': shopId,
      'userId': userId
    };

    if (pickupAddress != null) payload['pickupAddress'] = pickupAddress;
    debugPrint(payload.toString());
    return post("$serviceUrl/orders/place-order", payload);
  }

  Future<WayaRequestResponse> getUserOrders(String userId, int page) async {
    return get("$serviceUrl/orders/get-orders?userId=$userId&page=$page");
  }

  Future<WayaRequestResponse> getSellerOrders(
     {  required String shopId, required int page, String? status}) async {
    final queryParams = [
      'shopId=$shopId',
      'page=$page',
      if (status != null && status.isNotEmpty) 'status=$status',
    ].join('&');

    return get("$serviceUrl/orders/get-orders?$queryParams");
  }
  //

  Future<WayaRequestResponse> deliveryStatusUpdate(
      {required String orderId,
      required String status,
      required String shopId}) async {
    return put("$serviceUrl/orders/deliveryStatus/$orderId?shopId=$shopId",
        {"deliveryStatus": status});
  }

  Future<WayaRequestResponse> pickupStatusUpdate(
      {required String orderId,
      required String status,
      required String shopId}) async {
    return put("$serviceUrl/orders/pickupStatus/$orderId?shopId=$shopId",
        {"pickupStatus": status});
  }

  Future<WayaRequestResponse> declineOrder(
      {required String orderId,
      required String reason,
      required String shopId}) {
    return post("$serviceUrl/orders/decline-order?shopId=$shopId",
        {"orderId": orderId, "reason": reason});
  }
}

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

    print(payload);

    return post("$serviceUrl/orders/place-order", payload);
  }

  Future<WayaRequestResponse> getUserOrders(String userId, int page) async {
    return get("$serviceUrl/orders/get-orders?userId=$userId&page=$page");
  }

  Future<WayaRequestResponse> getSellerOrders(String shopId, int page) async {
    return get("$serviceUrl/orders/get-orders?shopId=$shopId&page=$page");
  }
  //

  Future<WayaRequestResponse> deliveryStatusUpdate(
      {required String orderId, required String status}) async {
    return put("$serviceUrl/orders/deliveryStatus/$orderId",
        {"deliveryStatus": status});
  }

  Future<WayaRequestResponse> pickupStatusUpdate(
      {required String orderId, required String status}) async {
    return put(
        "$serviceUrl/orders/pickupStatus/$orderId", {"pickupStatus": status});
  }

  Future<WayaRequestResponse> declineOrder(
      {required String orderId, required String reason}) {
    return post("$serviceUrl/orders/decline-order",
        {"orderId": orderId, "reason": reason});
  }
}

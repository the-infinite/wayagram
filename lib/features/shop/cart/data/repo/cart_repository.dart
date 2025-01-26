import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class CartRepository extends BaseRepository {
  static const serviceUrl = "wayagram-shop/api/v2";

  Future<WayaRequestResponse> addItemToCart(
      {required String productId,
      required int quantity,
      required String userId,
      required String shopId,
      required int price}) {
    return post("$serviceUrl/cart/add-to-cart", {
      "productId": productId,
      "quantity": quantity,
      "shopId": shopId,
      "userId": userId,
      "price": price
    });
  }

  Future<WayaRequestResponse> getUserCart(String userId) async {
    return get("$serviceUrl/cart/$userId");
  }

  Future<WayaRequestResponse> decreaseQuantity(
      {required String productId,
      required String userId,
      required String shopId}) async {
    return patch("$serviceUrl/cart/decrease-quantity",
        {"productId": productId, "userId": userId, "shopId": shopId});
  }

  Future<WayaRequestResponse> updateQuantity(
      {required String productId,
      required String userId,
      required String shopId}) async {
    return patch("$serviceUrl/cart/update-quantity",
        {"productId": productId, "userId": userId, "shopId": shopId});
  }

  Future<WayaRequestResponse> updateDeliveryAddress(
      {required String deliveryAddress,
      required String userId,
      required String shopId}) async {
    return patch("$serviceUrl/cart/request-deliveryFee", {
      "userId": userId,
      "shopId": shopId,
      "deliveryAddress": deliveryAddress
    });
  }

  Future<WayaRequestResponse> updateDeliveryFee(
      {required String deliveryAddress,
      required String deliveryFee,
      required String deliveryDate,
      required String userId,
      required String shopId}) async {
    return patch(
        "$serviceUrl/cart/shop/$shopId/user/$userId/update-fee-and-date",
        {"deliveryDate": deliveryDate, "deliveryFee": deliveryFee});
  }

  Future<WayaRequestResponse> getPendingDelivery({required String id}) async {
    return get("$serviceUrl/cart/delivery-address/$id");
  }

  //
  ///
  Future<WayaRequestResponse> createOrder(
      {required String cartId,
      required String shopId,
      required String userId}) {
    return post("$serviceUrl/orders/place-order",
        {'cartId': cartId, 'shopId': shopId, 'userId': userId});
  }
  //
}

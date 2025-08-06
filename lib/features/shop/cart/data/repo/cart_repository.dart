import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/service/repos/base_repository_riverpod.dart';

part 'cart_repository.g.dart';

class CartRepository extends BaseRepositoryRiverpod {
  static const serviceUrl = "wayagram-shop/api/v2";

  CartRepository(super.ref);

  Future<WayaRequestResponse> addItemToCart({
    required String productId,
    required int quantity,
    required String userId,
    required String shopId,
  }) {
    return post("$serviceUrl/cart/add-to-cart", {
      "productId": productId,
      "quantity": quantity,
      "shopId": shopId,
      "userId": userId,
    });
  }

  Future<WayaRequestResponse> getUserCart(String userId) async {
    return get("$serviceUrl/cart/$userId");
  }

  // //
  ///
  Future<WayaRequestResponse> removeShopProduct(
      {required String shopId}) async {
    return patch("$serviceUrl/cart/remove-shop-product", {"shopId": shopId});
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
      required int deliveryFee,
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
}

@riverpod
CartRepository cartRepository(Ref ref) {
  return CartRepository(ref);
}

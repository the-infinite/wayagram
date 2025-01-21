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
    return post("$serviceUrl/client/cart/add-to-cart", {
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
}

import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/create_shop_model.dart';
import 'package:wayagram/features/shop/seller/data/model/add_product_model.dart';

class ShopRepository extends BaseRepository {
  static const serviceUrl = "wayagram-shop/api/v2";
  static final instance = ShopRepository._();

  ShopRepository._();

  Future<WayaRequestResponse> getShop() {
    return get("$serviceUrl/shop");
  }

  Future<WayaRequestResponse> createShop(CreateShopModel payload) {
    return post("$serviceUrl/shops/create", payload.toJson());
  }

  Future<WayaRequestResponse> getShopBySellerId(String id) {
    return get('$serviceUrl/shops/$id');
  }

  Future<WayaRequestResponse> getAllCategories(int page) {
    return get('$serviceUrl/category/all?page=$page&limit=1000');
  }

  Future<WayaRequestResponse> createProduct(
      {required AddProductModel payload, required String id}) {
    return post(
      "$serviceUrl/products/create/$id",
      payload.toJson(),
    );
  }

  Future<WayaRequestResponse> getAllDiscounts(int page) {
    return get('$serviceUrl/discount/all?page=$page');
  }

  Future<WayaRequestResponse> getProducts({required int page, int limit = 20}) {
    return get('$serviceUrl/products/get?page=$page');
  }

  Future<WayaRequestResponse> getProductById({required String id}) {
    return get('$serviceUrl/products/get?id=$id');
  }

  ///products/:productId/shop/:shopId

  Future<WayaRequestResponse> deleteProductRequest(
      {required String shopId, required String productId}) {
    return delete("$serviceUrl/products/$productId/shop/$shopId");
  }

  Future<WayaRequestResponse> editProductRequest(
      {required AddProductModel payload, required String productId}) {
    return patch("$serviceUrl/products/edit/$productId", payload.toJson());
  }

  Future<WayaRequestResponse> getSellerProducts(
      {required String shopId, required int page}) {
    return get('$serviceUrl/products/get?shopId=$shopId&page=$page');
  }

  Future<WayaRequestResponse> editShop(
      CreateShopModel payload, String vendorId) {
    return patch(
      "$serviceUrl/shops/edit/$vendorId",
      payload.toJson(),
    );
  }

  Future<WayaRequestResponse> addToFavorite(
      {required String productId, required String shopId}) {
    return post("$serviceUrl/favorites/add/$shopId", {"productId": productId});
  }

  ///
  Future<WayaRequestResponse> addToken({required String deliveryToken}) {
    return post(
        "$serviceUrl/orders/complete-order", {"deliveryToken": deliveryToken});
  }

  Future<WayaRequestResponse> getShopDetailsById(String id) {
    return get("$serviceUrl/shops/shop/$id");
  }

  Future<WayaRequestResponse> createRating(
      {required String raterId,
      String? productId,
      String? shopId,
      required int score,
      required String review,
      required String type}) {
    final payload = {
      'raterId': raterId,
      'score': score,
      'review': review,
      'type': type
    };

    if (productId != null) payload['productId'] = productId;
    if (shopId != null) payload['shopId'] = shopId;

    print("Ewfwefewfwefewfewfwefwef $payload");

    return post("$serviceUrl/rating/create", payload);
  }

  ///
  Future<WayaRequestResponse> getProductRating({required String productId}) {
    return get('$serviceUrl/rating/userRatings?productId=$productId');
  }

  //
  Future<WayaRequestResponse> getShopMetrics({required String shopId}) {
    return get('$serviceUrl/orders/shop-metrics/$shopId');
  }
  //
}
//

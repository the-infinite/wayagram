import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/seller/data/model/create_shop_model.dart';
import 'package:wayagram/features/shop/seller/data/model/add_product_model.dart';

class ShopRepository extends BaseRepository {
  static const serviceUrl = WayaServiceUri.shop;
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

  Future<WayaRequestResponse> getManageShopById(String id) {
    return get('$serviceUrl/shopMember/get-shops/$id');
  }

  Future<WayaRequestResponse> getAllCategories(int page, [int limit = 1000]) {
    return get('$serviceUrl/category/all?page=$page&limit=$limit');
  }

  Future<WayaRequestResponse> createProduct({
    required AddProductModel payload,
    required String id,
  }) {
    return post(
      "$serviceUrl/products/create/$id",
      payload.toJson(),
    );
  }

  Future<WayaRequestResponse> getAllDiscounts(int page) {
    return get('$serviceUrl/discount/all?page=$page');
  }

  Future<WayaRequestResponse> fetchFavorites() {
    return get('$serviceUrl/favorites/all');
  }

  Future<WayaRequestResponse> getProducts({required int page, int limit = 20}) {
    return get('$serviceUrl/products/get?page=$page');
  }

  Future<WayaRequestResponse> getOngoingWayaDealProducts(
      {required int page, int limit = 20}) {
    return get('$serviceUrl/products/get?page=$page&dealStatus=ongoing');
  }

  Future<WayaRequestResponse> getProductById({required String id}) {
    return get('$serviceUrl/products/get?id=$id');
  }

  //
  Future<WayaRequestResponse> getBanner() {
    return get("$serviceUrl/banners/all");
  }

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
    return get('$serviceUrl/products/get?shopId=$shopId&page=$page&limit=100');
  }

  Future<WayaRequestResponse> getSellerListedWayaDealProducts(
      {required String shopId, required int page}) {
    return get(
        '$serviceUrl/products/get?shopId=$shopId&page=$page&dealStatus=ongoing');
  }

  Future<WayaRequestResponse> editShop(
      CreateShopModel payload, String vendorId) {
    return patch(
      "$serviceUrl/shops/edit/$vendorId",
      payload.toJson(),
    );
  }

  Future<WayaRequestResponse> addToFavorite(
      {required String productId, required String userId}) {
    return post("$serviceUrl/favorites/add/$userId", {"productId": productId});
  }

  Future<WayaRequestResponse> removeFromFavorite({required String favoriteId}) {
    print("favorite thing $favoriteId");
    return put("$serviceUrl/favorites/remove", {"productId": favoriteId});
  }

  ///
  Future<WayaRequestResponse> addToken({
    required String deliveryToken,
  }) {
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
    return post("$serviceUrl/rating/create", payload);
  }

  ///
  Future<WayaRequestResponse> getProductRating({required String productId}) {
    return get('$serviceUrl/rating/userRatings?productId=$productId');
  }

  //
  Future<WayaRequestResponse> getTopSellingProducts() {
    return get('$serviceUrl/products/most-sold');
  }

  //
  Future<WayaRequestResponse> getShopMetrics({required String shopId}) {
    return get('$serviceUrl/orders/shop-metrics/$shopId');
  }

  //
  Future<WayaRequestResponse> getShopSettings() {
    return get('$serviceUrl/user-shop/settings');
  }

  Future<WayaRequestResponse> updateShopSettings(
      bool notifyFriendsAboutProductPosts, bool makeProductPostsPublic) {
    return patch('$serviceUrl/user-shop/setting', {
      "notifyFriendsAboutProductPosts": notifyFriendsAboutProductPosts,
      "makeProductPostsPublic": makeProductPostsPublic
    });
  }

  Future<WayaRequestResponse> updateQuotationSettings(
      bool receiveQuotationRequests,
      bool makeRequestsPublic,
      bool displayQuotationRequestsInFeed) {
    return patch('$serviceUrl/user-shop/setting', {
      "receiveQuotationRequests": receiveQuotationRequests,
      "makeRequestsPublic": makeRequestsPublic,
      "displayQuotationRequestsInFeed": displayQuotationRequestsInFeed,
    });
  }
}
//

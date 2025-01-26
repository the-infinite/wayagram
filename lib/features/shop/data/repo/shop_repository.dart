import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/create_shop_model.dart';
import 'package:wayagram/features/shop/seller/data/model/add_product_model.dart';

class ShopRepository extends BaseRepository {
  static const serviceUrl = "wayagram-shop/api/v2";
  Future<WayaRequestResponse> getShop() {
    return get("$serviceUrl/shop");
  }

  Future<WayaRequestResponse> createShop(CreateShopModel payload) {
    return post("$serviceUrl/shops/create", payload.toJson(), formdata: true);
  }

  Future<WayaRequestResponse> getShopBySellerId(String id) {
    return get('$serviceUrl/shops/$id');
  }

  Future<WayaRequestResponse> getAllCategories(int page) {
    return get('$serviceUrl/category/all?page=$page');
  }

  Future<WayaRequestResponse> createProduct(
      {required AddProductModel payload, required String id}) {
    return post("$serviceUrl/products/create/$id", payload.toJson(),
        formdata: true);
  }

  Future<WayaRequestResponse> getAllDiscounts(int page) {
    return get('$serviceUrl/discount/all?page=$page');
  }

  Future<WayaRequestResponse> getProducts() {
    return get('$serviceUrl/products/get');
  }

  ///products/:productId/shop/:shopId

  Future<WayaRequestResponse> deleteProductRequest(
      {required String shopId, required String productId}) {
    return delete("$serviceUrl/products/$productId/shop/$shopId");
  }

  Future<WayaRequestResponse> editProductRequest(
      {required AddProductModel payload}) {
    return post("$serviceUrl/products/create", payload.toJson());
  }

  Future<WayaRequestResponse> getSellerProducts(
      {required String shopId, required int page}) {
    return get('$serviceUrl/products?shopId=$shopId&page=$page');
  }

  Future<WayaRequestResponse> editShop(
      CreateShopModel payload, String vendorId) {
  
    return patch("$serviceUrl/shops/edit/$vendorId", payload.toJson(),
        formdata: true);
  }

  //
}
//

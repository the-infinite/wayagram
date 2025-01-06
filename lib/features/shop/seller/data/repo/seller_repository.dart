import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/create_shop_model.dart';

class SellerRepository extends BaseRepository {
  static const serviceUrl = "wayagram-shop/api/v2";
  Future<WayaRequestResponse> getShop() {
    return get("$serviceUrl/shop");
  }

  Future<WayaRequestResponse> createShop(CreateShopModel payload) {
    return post("$serviceUrl/shops/create", payload.toJson());
  }



  // Future<WayaRequestResponse> getShopBySellerId(String id) {
  //   return get('shop/seller/$id');
  // }
}

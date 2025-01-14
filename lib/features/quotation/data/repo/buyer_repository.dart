import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/create_shop_model.dart';

class QuotationRepository extends BaseRepository {
  static const serviceUrl = "wayagram-shop/api/v2";
  Future<WayaRequestResponse> getShop() {
    return get("$serviceUrl/shop");
  }

  Future<WayaRequestResponse> createShop(CreateShopModel payload) {
    return post("$serviceUrl/shops/create", payload.toJson(), formdata: true);
  }

  Future<WayaRequestResponse> getShopBySellerId(String id) {
    return get('$serviceUrl/shops/3814919c-37fe-49a8-a2e7-0d58059697b7');
  }
}
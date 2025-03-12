import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class ProductsRepository extends BaseRepository {
  final serviceUrl = "wayagram-shop/api/v2/products";
  static final instance = ProductsRepository._();
  ProductsRepository._();
  Future<WayaRequestResponse> getShopProducts(String id, int page, [int limit = 15]) {
    return get("$serviceUrl/get");
  }
}

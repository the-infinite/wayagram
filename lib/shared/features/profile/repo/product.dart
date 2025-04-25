import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/core/utils/utils.dart';

class ProductsRepository extends BaseRepository {
  final serviceUrl = WayaServiceUri.product;
  static final instance = ProductsRepository._();
  ProductsRepository._();
  Future<WayaRequestResponse> getShopProducts(String id, int page, [int limit = 15]) {
    return get("$serviceUrl/products/get?userId=$id&page=$page");
  }
}

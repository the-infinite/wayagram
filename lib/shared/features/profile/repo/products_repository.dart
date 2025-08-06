import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/service/repos/base_repository_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';

part 'products_repository.g.dart';

class ProductsRepository extends BaseRepositoryRiverpod {
  final serviceUrl = WayaServiceUri.shop;
  ProductsRepository(super.ref);

  Future<WayaRequestResponse> getShopProducts(String id, int page,
      [int limit = 15]) {
    return get("$serviceUrl/products/get?userId=$id&page=$page");
  }
}

@riverpod
ProductsRepository productsRepository(Ref ref) {
  return ProductsRepository(ref);
}

import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';

enum ProductDetailType { wayagramdeal, recommended }

class ProductDetailModel {
  final String title;
  final String? description;
  final Future<PaginatedResult<Product>?> Function(int page) fetchData;

  ProductDetailModel({
    required this.title,
    this.description,
    required this.fetchData,
  });
}

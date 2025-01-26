import 'package:wayagram/features/shop/data/model/shop_state.dart';

enum ProductDetailType { wayagramdeal, recommended }

class ProductDetailModel<T> {
  String title;
  String? description;
  final Future<PaginatedResult<T>?> Function(int page) fetchData;

  ProductDetailModel(
      {required this.title,
       this.description,
      required this.fetchData});
}

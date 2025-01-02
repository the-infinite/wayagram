import 'package:wayagram/features/shop/data/model/model.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(Duration(seconds: 10));
    return products;
  }
}

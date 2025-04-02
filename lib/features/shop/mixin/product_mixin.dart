import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/shop/data/model/product_detail_type.dart';

import 'package:wayagram/features/shop/vm/shop_vm.dart';

mixin ProductMixin {
  ProductDetailModel getProduct({
    required ProductDetailType type,
    required WidgetRef ref,
  }) {
    switch (type) {
      case ProductDetailType.wayagramdeal:
        return ProductDetailModel(
          title: 'Wayagram Deals',
          fetchData: ref.read(shopVmProvider.notifier).getAllWayaDealProducts
    ,
        );
      case ProductDetailType.recommended:
        return ProductDetailModel(
          title: 'Recommended Products',
          fetchData: ref.read(shopVmProvider.notifier).getAllProducts
             ,
        );
    }
  }
}

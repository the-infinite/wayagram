import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/shop/buyer/views/all_orders.dart';
import 'package:wayagram/features/shop/buyer/views/delivery_cost_request.dart';


class ProductDetailVm extends ChangeNotifier {
  final Ref ref;
  ProductDetailVm(this.ref);

  Future<void> testRequest(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeliveryCostRequest(onPress: () {}, orders: orders);
        });
  }
}

final productDetailVmProvider =
    ChangeNotifierProvider((ref) => ProductDetailVm(ref));

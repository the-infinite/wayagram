import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/shop/buyer/views/dialogs/delivery_cost_request.dart';
import 'package:wayagram/features/shop/cart/data/model.dart';
import 'package:wayagram/features/shop/data/model/model.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';

class CartCardVm extends ChangeNotifier {
  final Ref ref;
  CartCardVm(this.ref);

  void deliveryRequest(BuildContext context, List<Cart> orders) {
    showDialog(
        context: context,
        builder: (context) {
          return DeliveryCostRequest(onPress: () {}, orders: orders);
        });
  }
}

final cartCardVmProvider = ChangeNotifierProvider((ref) => CartCardVm(ref));

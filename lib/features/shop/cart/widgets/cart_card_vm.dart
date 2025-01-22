import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/shop/buyer/views/dialogs/delivery_cost_request.dart';
import 'package:wayagram/features/shop/cart/data/model/cart_response_model.dart';

class CartCardVm extends StateNotifier<void> {
  final Ref ref;
  CartCardVm(this.ref) : super(null);

  void deliveryRequest(BuildContext context, List<CartProduct> orders,
      String shopId, String shopName, String shopLogo) async {
   showDialog(
        context: context,
        builder: (context) {
          return DeliveryCostRequest(
              onPress: () {},
              orders: orders,
              shopId: shopId,
              shopName: shopName,
              shopLogo: shopLogo);
        });
  }
}

final cartCardVmProvider = StateNotifierProvider((ref) => CartCardVm(ref));

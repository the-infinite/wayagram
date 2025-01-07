import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/shop/cart/vm/cart_vm.dart';
import 'package:wayagram/features/shop/cart/widgets/cart_card.dart';

class CartView extends ConsumerStatefulWidget {
  static const route = '/cart';
  const CartView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartViewState();
}

class _CartViewState extends ConsumerState<CartView> {
  @override
  Widget build(BuildContext context) {
    final restructuredCart = ref.watch(restructuredCartProvider);
    // TODO: implement build
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: "Cart",
        body: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: restructuredCart.length,
            itemBuilder: (context, index) {
              return CartCard(restructuredCart: restructuredCart[index]);
            }));
  }
}

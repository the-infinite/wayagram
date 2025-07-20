import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/cart/vm/cart_vm.dart';
import 'package:wayagram/features/shop/cart/widgets/cart_card.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

class CartView extends ConsumerStatefulWidget {
  static const route = '/cart';
  const CartView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartViewState();
}

class _CartViewState extends ConsumerState<CartView> {
  bool isCartEmpty = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(cartVmProvider.notifier).loadCart();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final restructuredCart = ref.watch(cartVmProvider);

    if (restructuredCart.cart == null) {
      setState(() {
        isCartEmpty = true;
      });
    }
    if (restructuredCart.cart != null) {
      if (restructuredCart.cart?.items != null &&
          restructuredCart.cart!.items.isEmpty) {
        setState(() {
          isCartEmpty = true;
        });
      }
      if (restructuredCart.cart?.items != null &&
          restructuredCart.cart!.items.isNotEmpty) {
        setState(() {
          isCartEmpty = false;
        });
      }
    }

    return WayaScaffold(
        isLoading: restructuredCart.isLoading,
        isScrollable: true,
        onRefresh: () => ref.read(cartVmProvider.notifier).loadCart(),
        title: "Cart",
        body: restructuredCart.cart == null || isCartEmpty
            ? Center(
                child: CartEmptyState(),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: restructuredCart.cart == null
                    ? 0
                    : restructuredCart.cart!.items.length,
                itemBuilder: (context, index) {
                  return CartCard(
                      cartId: restructuredCart.cart!.id,
                      cartItem: restructuredCart.cart!.items[index]);
                }));
  }
}

class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      buttonTrailingIcon: SvgPicture.asset('assets/icons/button-icon.svg'),
      buttontext: "Start Shopping",
      assetImage: SvgPicture.asset('assets/icons/empty-state.svg'),
      message: "No Item in the Cart",
      onTap: () => WayaNav.goBack(),
    );
  }
}

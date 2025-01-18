import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/features/shop/cart/data/model.dart';
import 'package:wayagram/features/shop/data/model/model.dart';

final cartProvider =
    StateNotifierProvider<CartVm, List<Cart>>((ref) => CartVm());

class CartVm extends StateNotifier<List<Cart>> {
  final WayaLocalDataSource localDataSource = WayaLocalDataSource();

  CartVm() : super([]) {
    loadCart();
  }

  Future<void> loadCart() async {
   // final List<Cart> cartArray =
       // localDataSource.getCart().isEmpty ? [] : localDataSource.getCart();

    state = [];
  }

  addToCart(Product product, int count) {
    final existingIndex = state.indexWhere((i) => i.id == product.id);

    if (existingIndex >= 0) {
      state = state.asMap().entries.map((entry) {
        final index = entry.key;
        final currentItem = entry.value;

        if (index == existingIndex) {
          // copyWith to create updated item
          return currentItem.copyWith(
              currentItem.count + 1, currentItem.quantity - 1);
        }
        return currentItem;
      }).toList();
    } else {
      // add product to cart
      final Cart cartItem = Cart.fromProduct(product, count);

      state = [...state, cartItem];
    }
    localDataSource.saveToCart(state);
  }

  removeFromCart(String id) {
    final isIdPresent = state.any((cart) => cart.id == id);

    if (isIdPresent) {
      final Cart cartItem = state.firstWhere((c) => c.id == id);
      if (cartItem.count > 0) {
        state.map((cart) {
          return cart.copyWith(cart.count - 1, cart.quantity + 1);
        }).toList();
      } else {
        state.where((cart) => cart.id != id).toList();
      }

      localDataSource.saveToCart(state);
    }
  }
}

final restructuredCartProvider = Provider<List<RestructuredCart>>((ref) {
  final cartItems = ref.watch(cartProvider);
  return restructureCartBySeller(cartItems);
});
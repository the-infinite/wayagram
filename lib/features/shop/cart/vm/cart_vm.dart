import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/features/shop/cart/data/repo/cart_repository.dart';
import 'package:wayagram/features/shop/data/model/model.dart';
import 'package:wayagram/features/shop/cart/data/model/cart_response_model.dart';

// final cartProvider =
//     StateNotifierProvider<CartVm, List<Cart>>((ref) => CartVm());

class CartState {
  final bool isLoading;
  final CartData? cart;

  CartState({this.cart, this.isLoading = false});

  CartState copyWith({CartData? cart, bool? isLoading}) {
    return CartState(
        cart: cart ?? this.cart, isLoading: isLoading ?? this.isLoading);
  }
}

//
class CartVm extends StateNotifier<CartState> {
  final Ref ref;
  final WayaLocalDataSource _localDataSource;
  final WayaSecureDataSource _secureDataSource;
  final CartRepository _cartRepository;

  CartVm(this.ref, this._localDataSource, this._cartRepository,
      this._secureDataSource)
      : super(CartState()) {
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      final userId = await _secureDataSource.getUserId();
      final response = await _cartRepository.getUserCart(userId!);

      if (response.success) {
        CartResponse cartResponse = CartResponse.fromJson(response.data);
        state = state.copyWith(cart: cartResponse.data);
      }
    } catch (e) {
      print(e);
    }
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
    _localDataSource.saveToCart(state);
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

      _localDataSource.saveToCart(state);
    }
  }

  Future<void> postItemToCart() async {}
}

final cartVmProvider = StateNotifierProvider<CartVm, CartState>((ref) {
  return CartVm(
      ref, WayaLocalDataSource(), CartRepository(), WayaSecureDataSource());
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/features/shop/cart/data/repo/cart_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/cart/data/model/cart_response_model.dart';
import 'package:uuid/uuid.dart';

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
  final WayaSecureDataSource _secureDataSource;
  final CartRepository _cartRepository;

  CartVm(this.ref, this._cartRepository, this._secureDataSource)
      : super(CartState()) {
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      final userId = await _secureDataSource.getUserId();
      final response = await _cartRepository.getUserCart(userId!);

      if (response.success) {
        final cartResponse = CartResponse.fromJson(response.data);
        state = state.copyWith(cart: cartResponse.data);
      }
    } catch (e) {
      print(e);
    }
  }

  void addToCart(Product product, int count) async {
    final existingCart = state.cart;

    if (existingCart == null) {
      final newCart = CartData(
        id: Uuid().v4(),
        userId: Uuid().v4(),
        total: (product.price * count).toString(),
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        items: [
          CartItem(
            shopId: product.shopId,
            products: [
              CartProduct(
                price: double.parse(product.price).toInt(),
                quantity: count,
                productId: product.id,
              )
            ],
          ),
        ],
      );
      state = state.copyWith(cart: newCart);

// post cart
      await postCartItem(product);
      return;
    }

    final updatedItems = [...existingCart.items];
    bool productAdded = false;

    for (int i = 0; i < updatedItems.length; i++) {
      if (updatedItems[i].shopId == product.shopId) {
        final updatedProducts = [...updatedItems[i].products];

        for (int j = 0; j < updatedProducts.length; j++) {
          if (updatedProducts[j].productId == product.id) {
            updatedProducts[j] = updatedProducts[j].copyWith(
              quantity: updatedProducts[j].quantity + count,
            );
            productAdded = true;
            break;
          }
        }

        if (!productAdded) {
          updatedProducts.add(
            CartProduct(
              price: double.parse(product.price).toInt(),
              quantity: count,
              productId: product.id,
            ),
          );
          productAdded = true;
        }

        updatedItems[i] = updatedItems[i].copyWith(products: updatedProducts);
        break;
      }
    }

    if (!productAdded) {
      updatedItems.add(
        CartItem(
          shopId: product.shopId,
          products: [
            CartProduct(
              price: double.parse(product.price).toInt(),
              quantity: count,
              productId: product.id,
            ),
          ],
        ),
      );
    }

    final total = updatedItems.fold<double>(
      0,
      (sum, item) =>
          sum +
          item.products.fold(
            0,
            (prodSum, prod) => prodSum + (prod.price * prod.quantity),
          ),
    );

    state = state.copyWith(
      cart: existingCart.copyWith(
        items: updatedItems,
        total: total.toString(),
        updatedAt: DateTime.now(),
      ),
    );
// update cart
    await updateCartItem(product);
  }

  void removeFromCart(String productId, Product product) async {
    final existingCart = state.cart;
    if (existingCart == null) return;

    final updatedItems = existingCart.items
        .map((item) {
          final updatedProducts = item.products
              .map((product) {
                if (product.productId == productId) {
                  final newQuantity = product.quantity - 1;
                  return newQuantity > 0
                      ? product.copyWith(quantity: newQuantity)
                      : null;
                }
                return product;
              })
              .whereType<CartProduct>()
              .toList();

          return item.copyWith(products: updatedProducts);
        })
        .where((item) => item.products.isNotEmpty)
        .toList();

    final total = updatedItems.fold<double>(
      0,
      (sum, item) =>
          sum +
          item.products.fold(
            0,
            (prodSum, prod) => prodSum + (prod.price * prod.quantity),
          ),
    );

    state = state.copyWith(
      cart: existingCart.copyWith(
        items: updatedItems,
        total: total.toString(),
        updatedAt: DateTime.now(),
      ),
    );

    await decreaseCartItem(product);
  }

  Future<void> postCartItem(Product product) async {
    try {
      final userId = await _secureDataSource.getUserId();
      int intPrice = double.parse(product.price).toInt();
      final response = await _cartRepository.addItemToCart(
          productId: product.id,
          quantity: 1,
          userId: userId!,
          shopId: product.shopId,
          price: intPrice);
      if (response.success) {
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateCartItem(Product product) async {
    try {
      final userId = await _secureDataSource.getUserId();

      final response = await _cartRepository.updateQuantity(
        productId: product.id,
        userId: userId!,
        shopId: product.shopId,
      );
      if (response.success) {
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> decreaseCartItem(Product product) async {
    try {
      final userId = await _secureDataSource.getUserId();

      final response = await _cartRepository.decreaseQuantity(
        productId: product.id,
        userId: userId!,
        shopId: product.shopId,
      );
      if (response.success) {
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }

  int getTotalProductQuantity() {
  final existingCart = state.cart;
  if (existingCart == null) return 0;


  final totalQuantity = existingCart.items.fold<int>(
    0,
    (sum, item) => sum + item.products.fold<int>(
      0,
      (productSum, product) => productSum + product.quantity,
    ),
  );

  return totalQuantity;
}

}

final cartVmProvider = StateNotifierProvider<CartVm, CartState>((ref) {
  return CartVm(ref, CartRepository(), WayaSecureDataSource());
});

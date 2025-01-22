import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/features/shop/cart/data/repo/cart_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/cart/data/model/cart_response_model.dart';
import 'package:uuid/uuid.dart';

class CartState {
  final bool isLoading;
  final bool isRequestingDelivery;
  final bool isAddingDeliveryFee;
  final CartData? cart;
  final int totalItem;

  CartState(
      {this.cart,
      this.isLoading = false,
      this.isRequestingDelivery = false,
      this.totalItem = 0,
      this.isAddingDeliveryFee = false});

  CartState copyWith(
      {CartData? cart,
      bool? isLoading,
      bool? isRequestingDelivery,
      int? totalItem,
      bool? isAddingDeliveryFee}) {
    return CartState(
        cart: cart ?? this.cart,
        isLoading: isLoading ?? this.isLoading,
        isAddingDeliveryFee: isAddingDeliveryFee ?? this.isAddingDeliveryFee,
        totalItem: totalItem ?? this.totalItem,
        isRequestingDelivery:
            isRequestingDelivery ?? this.isRequestingDelivery);
  }
}

//
class CartVm extends StateNotifier<CartState> {
  final Ref ref;
  final WayaSecureDataSource _secureDataSource;
  final CartRepository _cartRepository;

  CartVm(this.ref, this._cartRepository, this._secureDataSource)
      : super(CartState());

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
    print("in product");

    if (existingCart == null) {
      // Create a new cart if none exists
      final newCart = CartData(
        userId: Uuid().v4(),
        total: (product.price * count).toString(),
        items: [
          CartItem(
            shopId: product.shopId,
            deliveryAddress: "",
            deliveryFee: "",
            deliveryDate: "",
            shopName: "",
            shopLogo: "",
            products: [
              CartProduct(
                price: double.parse(product.price).toInt(),
                quantity: count,
                productId: product.id,
                productName: product.name,
                deliveryCharge: false,
                productImage: product.images.isEmpty ? "" : product.images[0],
              ),
            ],
          ),
        ],
      );
      state = state.copyWith(cart: newCart);
      print("in first");
      // Post cart item
      getTotalProductQuantity();
      await postCartItem(product);
      return;
    }

    // Update existing cart
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
              productName: product.name,
              deliveryCharge: false,
              productImage: product.images.isEmpty ? "" : product.images[0],
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
          deliveryAddress: "",
          deliveryFee: "",
          deliveryDate: "",
          shopName: "",
          shopLogo: "",
          products: [
            CartProduct(
              price: double.parse(product.price).toInt(),
              quantity: count,
              productId: product.id,
              productName: product.name,
              deliveryCharge: false,
              productImage: product.images.isEmpty ? "" : product.images[0],
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
      ),
    );
    getTotalProductQuantity();
    // Update cart
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

    // Calculate total
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
      ),
    );
    getTotalProductQuantity();
    // Decrease cart item
    await decreaseCartItem(product);
  }

  Future<void> postCartItem(Product product) async {
    try {
      final userId = await _secureDataSource.getUserId();
      int intPrice = double.parse(product.price).toInt();
      print(product.shopId);
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

  void getTotalProductQuantity() {
    final existingCart = state.cart;
    if (existingCart == null) return;

    final totalQuantity = existingCart.items.fold<int>(
      0,
      (sum, item) =>
          sum +
          item.products.fold<int>(
            0,
            (productSum, product) => productSum + product.quantity,
          ),
    );
    state = state.copyWith(totalItem: totalQuantity);
  }

  Future<void> deliveryRequest(
      {required String shopId, required String address}) async {
    try {
      state = state.copyWith(isRequestingDelivery: true);
      final userId = await _secureDataSource.getUserId();

      final response = await _cartRepository.updateDeliveryAddress(
        deliveryAddress: address,
        userId: userId!,
        shopId: shopId,
      );
      if (response.success) {
        print(response.data);
      }
    } catch (e) {
      print(e);
    } finally {
      state = state.copyWith(isRequestingDelivery: false);
    }
  }

  Future<void> addDeliveryFee(
      {required String shopId,
      required String address,
      required String deliveryFee,
      required String deliveryDate}) async {
    state = state.copyWith(isAddingDeliveryFee: true);
    try {
      final userId = await _secureDataSource.getUserId();

      final response = await _cartRepository.updateDeliveryFee(
          deliveryAddress: address,
          userId: userId!,
          shopId: shopId,
          deliveryDate: deliveryDate,
          deliveryFee: deliveryFee);
      if (response.success) {
        print(response.data);
      }
    } catch (e) {
      print(e);
    } finally {
      state = state.copyWith(isAddingDeliveryFee: false);
    }
  }
}

final cartVmProvider = StateNotifierProvider<CartVm, CartState>((ref) {
  return CartVm(ref, CartRepository(), WayaSecureDataSource());
});

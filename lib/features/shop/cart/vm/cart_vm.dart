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
      state = state.copyWith(isLoading: true);
      final userId = await _secureDataSource.getUserId();
      final response = await _cartRepository.getUserCart(userId!);

      if (response.success) {
        final cartResponse = CartResponse.fromJson(response.data);
        state = state.copyWith(cart: cartResponse.data);
        getTotalProductQuantity();
      }
    } catch (e) {
      print(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void addToCart(
      {required int count,
      required String shopId,
      required int price,
      required String productName,
      required String productImage,
      required String productId}) async {
    final existingCart = state.cart;
    // int intPrice = double.parse(product.price).toInt();
    // int price = product.discountPercentage > 0
    //     ? (intPrice - (intPrice * product.discountPercentage / 100)).toInt()
    //     : intPrice;

    if (existingCart == null) {
      final newCart = CartData(
        id: Uuid().v4(),
        userId: Uuid().v4(),
        items: [
          CartItem(
            shopId: shopId,
            deliveryAddress: "",
            deliveryFee: 0,
            deliveryDate: "",
            shopName: "",
            shopLogo: "",
            totalFee: price * count,
            products: [
              CartProduct(
                price: price,
                quantity: count,
                productId: productId,
                productName: productName,
                deliveryCharge: false,
                productImage: productImage,
                deliveryOptions: ""
              ),
            ],
          ),
        ],
      );
      state = state.copyWith(cart: newCart);
      // Post cart item
      getTotalProductQuantity();
      await postCartItem(id: productId, shopId: shopId, price: price);
      return;
    }

    // Update existing cart
    final updatedItems = [...existingCart.items];
    bool productAdded = false;

    for (int i = 0; i < updatedItems.length; i++) {
      if (updatedItems[i].shopId == shopId) {
        final updatedProducts = [...updatedItems[i].products];

        for (int j = 0; j < updatedProducts.length; j++) {
          if (updatedProducts[j].productId == productId) {
            updatedProducts[j] = updatedProducts[j].copyWith(
              quantity: updatedProducts[j].quantity + count,
            );
            productAdded = true;
            print("updating");
            await updateCartItem(id: productId, shopId: shopId);
            break;
          }
        }

        if (!productAdded) {
          updatedProducts.add(
            CartProduct(
              price: price,
              quantity: count,
              productId: productId,
              productName: productName,
              deliveryCharge: false,
              productImage: productImage,
              deliveryOptions: ''
            ),
          );
          productAdded = true;
           print("add item for a shop ");
                 await postCartItem(id: productId, shopId: shopId, price: price);
        }

        updatedItems[i] = updatedItems[i].copyWith(products: updatedProducts);

        final totalFee = updatedItems[i].products.fold<int>(
              0,
              (sum, product) => sum + (product.price * product.quantity),
            );
        updatedItems[i] = updatedItems[i].copyWith(totalFee: totalFee);

        break;
      }
    }

    if (!productAdded) {
      updatedItems.add(
        CartItem(
          shopId: shopId,
          deliveryAddress: "",
          deliveryFee: 0,
          deliveryDate: "",
          shopName: "",
          shopLogo: "",
          totalFee: price * count,
          products: [
            CartProduct(
              price: price,
              quantity: count,
              productId: productId,
              productName: productName,
              deliveryCharge: false,
              productImage: productImage,
              deliveryOptions: ''
            ),
          ],
        ),
      );

      await postCartItem(id: productId, shopId: shopId, price: price);
    }

    // final total = updatedItems.fold<double>(
    //   0,
    //   (sum, item) =>
    //       sum +
    //       item.products.fold(
    //         0,
    //         (prodSum, prod) => prodSum + (prod.price * prod.quantity),
    //       ),
    // );

    state = state.copyWith(
      cart: existingCart.copyWith(
        items: updatedItems,
      ),
    );
    getTotalProductQuantity();
    // Update cart
    //
  }

  void removeFromCart(
      {required String productId, required String shopId}) async {
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

          final totalFee = updatedProducts.fold<int>(
            0,
            (sum, product) => sum + (product.price * product.quantity),
          );

          return item.copyWith(products: updatedProducts, totalFee: totalFee);
        })
        .where((item) => item.products.isNotEmpty)
        .toList();

    // // Calculate total
    // final total = updatedItems.fold<double>(
    //   0,
    //   (sum, item) =>
    //       sum +
    //       item.products.fold(
    //         0,
    //         (prodSum, prod) => prodSum + (prod.price * prod.quantity),
    //       ),
    // );

    state = state.copyWith(
      cart: existingCart.copyWith(
        items: updatedItems,
      ),
    );
    getTotalProductQuantity();
    // Decrease cart item
    await decreaseCartItem(shopId: shopId, id: productId);
  }

  Future<void> postCartItem(
      {required String id, required String shopId, required int price}) async {
    try {
      final userId = await _secureDataSource.getUserId();

      final response = await _cartRepository.addItemToCart(
          productId: id,
          quantity: 1,
          userId: userId!,
          shopId: shopId,
          price: price);

      if (response.success) {
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateCartItem(
      {required String id, required String shopId}) async {
    try {
      final userId = await _secureDataSource.getUserId();

      final response = await _cartRepository.updateQuantity(
        productId: id,
        userId: userId!,
        shopId: shopId,
      );
      if (response.success) {
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> decreaseCartItem(
      {required String id, required String shopId}) async {
    try {
      final userId = await _secureDataSource.getUserId();

      final response = await _cartRepository.decreaseQuantity(
        productId: id,
        userId: userId!,
        shopId: shopId,
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

import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/shop/cart/data/model/cart_product.dart';

part 'cart_item.g.dart';

@JsonSerializable()
class CartItem {
  final String shopId;
  final String? deliveryAddress;
  final int? deliveryFee;
  final String? deliveryDate;
  final String shopName;
  final String shopLogo;
  final int? totalFee;
  final List<CartProduct> products;

  CartItem({
    required this.shopId,
    this.deliveryAddress,
    this.deliveryFee,
    this.deliveryDate,
    required this.shopName,
    required this.shopLogo,
    this.totalFee,
    required this.products,
  });

  CartItem copyWith({
    String? shopId,
    String? deliveryAddress,
    int? deliveryFee,
    String? deliveryDate,
    String? shopName,
    String? shopLogo,
    int? totalFee,
    List<CartProduct>? products,
  }) {
    return CartItem(
      shopId: shopId ?? this.shopId,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      shopName: shopName ?? this.shopName,
      shopLogo: shopLogo ?? this.shopLogo,
      totalFee: totalFee ?? this.totalFee,
      products: products ?? this.products,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'cart_product.g.dart';

@JsonSerializable()
class CartProduct {
  final int price;
  final int quantity;
  final String productId;
  final String productName;
  final String? pickUpAddress;
  final String deliveryOptions;
  final bool deliveryCharge;
  final String? productImage;
  final String? unitPrice;

  CartProduct({
    required this.price,
    required this.quantity,
    required this.productId,
    required this.productName,
    required this.deliveryCharge,
    this.productImage,
    this.pickUpAddress,
    this.unitPrice,
    required this.deliveryOptions,
  });

  CartProduct copyWith({
    int? price,
    int? quantity,
    String? productId,
    String? productName,
    bool? deliveryCharge,
    String? productImage,
    String? deliveryOptions,
    String? unitPrice,
    String? pickUpAddress,
  }) {
    return CartProduct(
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        deliveryCharge: deliveryCharge ?? this.deliveryCharge,
        productImage: productImage ?? this.productImage,
        deliveryOptions: deliveryOptions ?? this.deliveryOptions,
        unitPrice: unitPrice ?? this.unitPrice,
        pickUpAddress: pickUpAddress ?? this.pickUpAddress);
  }

  factory CartProduct.fromJson(Map<String, dynamic> json) =>
      _$CartProductFromJson(json);

  Map<String, dynamic> toJson() => _$CartProductToJson(this);
}

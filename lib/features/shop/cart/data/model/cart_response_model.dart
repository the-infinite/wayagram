import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/shop/cart/data/model/cart_data.dart';
import 'package:wayagram/features/shop/cart/data/model/cart_item.dart';

part 'cart_response_model.g.dart';

@JsonSerializable()
class CartResponse {
  final String message;
  final bool status;
  final int statusCode;
  final CartData? data;

  CartResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    this.data,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) =>
      _$CartResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CartResponseToJson(this);
}

class CheckoutArg {
  final String cartId;
  final CartItem cartItem;

  CheckoutArg({required this.cartId, required this.cartItem});
}

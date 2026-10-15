import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/shop/cart/data/model/cart_item.dart';

part 'cart_data.g.dart';

@JsonSerializable()
class CartData {
  final String id;
  final String userId;
  final List<CartItem> items;

  CartData({
    required this.id,
    required this.userId,
    required this.items,
  });

  CartData copyWith({String? id, String? userId, List<CartItem>? items}) {
    return CartData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        items: items ?? this.items);
  }

  factory CartData.fromJson(Map<String, dynamic> json) =>
      _$CartDataFromJson(json);

  Map<String, dynamic> toJson() => _$CartDataToJson(this);
}

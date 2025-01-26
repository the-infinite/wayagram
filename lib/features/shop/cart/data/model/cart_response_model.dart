import 'dart:convert';

class CartResponse {
  final String message;
  final bool status;
  final int statusCode;
  final CartData data;

  CartResponse({
    required this.message,
    required this.data,
    required this.status,
    required this.statusCode,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      message: json['message'],
      data: CartData.fromJson(json['data']),
      status: json['status'] ?? false,
      statusCode: json['statusCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusCode': statusCode,
      'data': data.toJson(),
    };
  }
}

class CartData {
  final String id;
  final String userId;
  final List<CartItem> items;
  final String total;
  final DateTime updatedAt;
  final DateTime createdAt;

  CartData({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.updatedAt,
    required this.createdAt,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      total: json['total'],
      updatedAt: DateTime.parse(json['updatedAt']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'updatedAt': updatedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  CartData copyWith(
      {String? id,
      String? userId,
      List<CartItem>? items,
      String? total,
      DateTime? updatedAt,
      DateTime? createdAt}) {
    return CartData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        items: items ?? this.items,
        total: total ?? this.total,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt);
  }
}

class CartItem {
  final String shopId;
  final List<CartProduct> products;

  CartItem({
    required this.shopId,
    required this.products,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      shopId: json['shopId'],
      products: (json['products'] as List<dynamic>)
          .map((product) => CartProduct.fromJson(product))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shopId': shopId,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }

  CartItem copyWith({String? shopId, List<CartProduct>? products}) {
    return CartItem(
        shopId: shopId ?? this.shopId, products: products ?? this.products);
  }
}

class CartProduct {
  final int price;
  final int quantity;
  final String productId;

  CartProduct({
    required this.price,
    required this.quantity,
    required this.productId,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      price: json['price'],
      quantity: json['quantity'],
      productId: json['productId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'quantity': quantity,
      'productId': productId,
    };
  }

  CartProduct copyWith({int? price, int? quantity, String? productId}) {
    return CartProduct(
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        productId: productId ?? this.productId);
  }
}

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

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
        message: json['message'],
        status: json['status'],
        statusCode: json['statusCode'],
        data: json['data'] != null ? CartData.fromJson(json['data']) : null,
      );
}

class CartData {
  final String userId;
  final List<CartItem> items;
  final String total;

  CartData({
    required this.userId,
    required this.items,
    required this.total,
  });

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
        userId: json['userId'],
        items: (json['items'] as List)
            .map((item) => CartItem.fromJson(item))
            .toList(),
        total: json['total'],
      );

  CartData copyWith({
    String? userId,
    List<CartItem>? items,
    String? total,
  }) {
    return CartData(
        userId: userId ?? this.userId,
        items: items ?? this.items,
        total: total ?? this.total);
  }
}

class CartItem {
  final String shopId;
  final String? deliveryAddress;
  final String? deliveryFee;
  final String? deliveryDate;
  final String shopName;
  final String shopLogo;
  final List<CartProduct> products;

  CartItem({
    required this.shopId,
     this.deliveryAddress = '',
     this.deliveryFee = '',
     this.deliveryDate = '',
    required this.shopName,
    required this.shopLogo,
    required this.products,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        shopId: json['shopId'],
        deliveryAddress: json['deliveryAddress'],
        deliveryFee: json['deliveryFee'],
        deliveryDate: json['deliveryDate'],
        shopName: json['shopName'],
        shopLogo: json['shopLogo'],
        products: (json['products'] as List)
            .map((product) => CartProduct.fromJson(product))
            .toList(),
      );

  CartItem copyWith({
    String? shopId,
    String? deliveryAddress,
    String? deliveryFee,
    String? deliveryDate,
    String? shopName,
    String? shopLogo,
    List<CartProduct>? products,
  }) {
    return CartItem(
        shopId: shopId ?? this.shopId,
        deliveryAddress: deliveryAddress ?? this.deliveryAddress,
        deliveryFee: deliveryFee ?? this.deliveryFee,
        deliveryDate: deliveryDate ?? this.deliveryDate,
        shopName: shopName ?? this.shopName,
        shopLogo: shopLogo ?? this.shopLogo,
        products: products ?? this.products);
  }
}

class CartProduct {
  final int price;
  final int quantity;
  final String productId;
  final String productName;
  final bool deliveryCharge;
  final String? productImage;

  CartProduct({
    required this.price,
    required this.quantity,
    required this.productId,
    required this.productName,
    required this.deliveryCharge,
    required this.productImage,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        price: json['price'],
        quantity: json['quantity'],
        productId: json['productId'],
        productName: json['productName'],
        deliveryCharge: json['deliveryCharge'],
        productImage: json['productImage'],
      );

  CartProduct copyWith(
      {int? price,
      int? quantity,
      String? productId,
      String? productName,
      bool? deliveryCharge,
      String? productImage}) {
    return CartProduct(
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        deliveryCharge: deliveryCharge ?? this.deliveryCharge,
        productImage: productImage ?? this.productImage);
  }
}

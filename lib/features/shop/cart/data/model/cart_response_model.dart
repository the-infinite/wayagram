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

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: json['data'] != null ? CartData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusCode': statusCode,
      'data': data?.toJson(),
    };
  }
}

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

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

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

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      shopId: json['shopId'] ?? '',
      deliveryAddress: json['deliveryAddress'],
      deliveryFee: _parseToInt(json['deliveryFee']), // Safe parsing
      deliveryDate: json['deliveryDate'],
      shopName: json['shopName'] ?? '',
      shopLogo: json['shopLogo'] ?? '',
      totalFee: _parseToInt(json['totalFee']), // Safe parsing
      products: (json['products'] as List)
          .map((product) => CartProduct.fromJson(product))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shopId': shopId,
      'deliveryAddress': deliveryAddress,
      'deliveryFee': deliveryFee,
      'deliveryDate': deliveryDate,
      'shopName': shopName,
      'shopLogo': shopLogo,
      'totalFee': totalFee,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }

  static int? _parseToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}

class CartProduct {
  final int price;
  final int quantity;
  final String productId;
  final String productName;
  final String? pickUpAddress;
  final String deliveryOptions;
  final bool deliveryCharge;
  final String? productImage;

  CartProduct(
      {required this.price,
      required this.quantity,
      required this.productId,
      required this.productName,
      required this.deliveryCharge,
     this.productImage,
      this.pickUpAddress,
      required this.deliveryOptions});

  CartProduct copyWith(
      {int? price,
      int? quantity,
      String? productId,
      String? productName,
      bool? deliveryCharge,
      String? productImage,
      String? deliveryOptions,
      String? pickUpAddress}) {
    return CartProduct(
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        deliveryCharge: deliveryCharge ?? this.deliveryCharge,
        productImage: productImage ?? this.productImage,
        deliveryOptions: deliveryOptions ?? this.deliveryOptions,
        pickUpAddress: pickUpAddress ?? this.pickUpAddress);
  }

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
        price: json['price'],
        quantity: json['quantity'],
        productId: json['productId'],
        productName: json['productName'],
        deliveryCharge: json['deliveryCharge'],
        productImage: json['productImage'],
        pickUpAddress: json['pickUpAddress'],
        deliveryOptions: json['deliveryOptions']);
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'quantity': quantity,
      'productId': productId,
      'productName': productName,
      'deliveryCharge': deliveryCharge,
      'productImage': productImage,
      'deliveryOptions': deliveryOptions,
      'pickUpAddress': pickUpAddress
    };
  }
}

class CheckoutArg {
  final String cartId;
  final CartItem cartItem;

  CheckoutArg({required this.cartId, required this.cartItem});
}

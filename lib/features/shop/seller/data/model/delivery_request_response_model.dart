class DeliveryRequestResponseModel {
  final String message;
  final List<DeliveryRequestData> data;

  DeliveryRequestResponseModel({
    required this.message,
    required this.data,
  });

  factory DeliveryRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return DeliveryRequestResponseModel(
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) =>
              DeliveryRequestData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class DeliveryRequestData {
  final String userId;
  final List<DeliveryItem> items;

  DeliveryRequestData({
    required this.userId,
    required this.items,
  });

  factory DeliveryRequestData.fromJson(Map<String, dynamic> json) {
    return DeliveryRequestData(
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => DeliveryItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class DeliveryItem {
  final String shopId;
  final List<DeliveryProduct> products;
  final String deliveryAddress;
  final int? totalFee;

  DeliveryItem({
    required this.shopId,
    required this.products,
    required this.deliveryAddress,
     this.totalFee
  });

  factory DeliveryItem.fromJson(Map<String, dynamic> json) {
    return DeliveryItem(
      shopId: json['shopId'] as String,
      products: (json['products'] as List<dynamic>)
          .map((item) => DeliveryProduct.fromJson(item as Map<String, dynamic>))
          .toList(),
      deliveryAddress: json['deliveryAddress'] as String,
      totalFee: json['totalFee']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shopId': shopId,
      'products': products.map((product) => product.toJson()).toList(),
      'deliveryAddress': deliveryAddress,
      'totalFee': totalFee
    };
  }
}

class DeliveryProduct {
  final String price;
  final int quantity;
  final String productId;
  final String productName;
  final String productImage;

  DeliveryProduct(
      {required this.price,
      required this.quantity,
      required this.productId,
      required this.productImage,
      required this.productName});

  factory DeliveryProduct.fromJson(Map<String, dynamic> json) {
    return DeliveryProduct(
        price: json['unitPrice'] as String,
        quantity: json['quantity'],
        productId: json['productId'],
        productImage: json['productImage'],
        productName: json['productName']);
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'quantity': quantity,
      'productId': productId,
      'productImage': productImage,
      'productName': productName
    };
  }
}

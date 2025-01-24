class PlaceOrderModel {
  final String userId;
  final List<OrderItem> items;
  final String shopId;
  final String vendorId;
  final double deliveryFee;
  final String deliveryAddress;
  final String pickupAddress;
  final DateTime deliveryDate;
  final double total;

  PlaceOrderModel({
    required this.userId,
    required this.items,
    required this.shopId,
    required this.vendorId,
    required this.deliveryFee,
    required this.deliveryAddress,
    required this.pickupAddress,
    required this.deliveryDate,
    required this.total,
  });

  // CopyWith method
  PlaceOrderModel copyWith({
    String? userId,
    List<OrderItem>? items,
    String? shopId,
    String? vendorId,
    double? deliveryFee,
    String? deliveryAddress,
    String? pickupAddress,
    DateTime? deliveryDate,
    double? total,
  }) {
    return PlaceOrderModel(
      userId: userId ?? this.userId,
      items: items ?? this.items,
      shopId: shopId ?? this.shopId,
      vendorId: vendorId ?? this.vendorId,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      total: total ?? this.total,
    );
  }

  // From JSON
  factory PlaceOrderModel.fromJson(Map<String, dynamic> json) {
    return PlaceOrderModel(
      userId: json['userId'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      shopId: json['shopId'],
      vendorId: json['vendorId'],
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      deliveryAddress: json['deliveryAddress'],
      pickupAddress: json['pickupAddress'],
      deliveryDate: DateTime.parse(json['deliveryDate']),
      total: (json['total'] as num).toDouble(),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'shopId': shopId,
      'vendorId': vendorId,
      'deliveryFee': deliveryFee,
      'deliveryAddress': deliveryAddress,
      'pickupAddress': pickupAddress,
      'deliveryDate': deliveryDate.toIso8601String(),
      'total': total,
    };
  }
}

class OrderItem {
  final String productId;
  final int quantity;
  final double price;
  final String name;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.name,
  });

  // CopyWith method
  OrderItem copyWith({
    String? productId,
    int? quantity,
    double? price,
    String? name,
  }) {
    return OrderItem(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      name: name ?? this.name,
    );
  }

  // From JSON
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      quantity: json['quantity'],
      price: json['price'],
      name: json['name'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'name': name,
    };
  }
}

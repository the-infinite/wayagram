import 'package:wayagram/features/shop/seller/data/model/pagination_model.dart';

class OrdersResponse {
  final String message;
  final bool status;
  final int statusCode;
  final OrdersData data;

  OrdersResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: OrdersData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'status': status,
        'statusCode': statusCode,
        'data': data.toJson(),
      };
}

class OrdersData {
  final List<Order> data;
  final Pagination pagination;

  OrdersData({
    required this.data,
    required this.pagination,
  });

  factory OrdersData.fromJson(Map<String, dynamic> json) {
    return OrdersData(
      data: (json['data'] as List).map((e) => Order.fromJson(e)).toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data.map((e) => e.toJson()).toList(),
        'pagination': pagination.toJson(),
      };
}

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final String shopId;
  final String vendorId;
  final String total;
  final String status;
  final String? pickupAddress;
  final String pickupStatus;
  final String? deliveryAddress;
  final String? deliveryFee;
  final DateTime? deliveryDate;
  final String deliveryStatus;
  final String version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String shopName;
  final String shopPhone;
  final String? deliveryToken;
    final String? deliveryType;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.shopId,
    required this.vendorId,
    required this.total,
    required this.status,
    this.deliveryType,
    this.pickupAddress,
    required this.pickupStatus,
    this.deliveryAddress,
    this.deliveryFee,
    this.deliveryDate,
    this.deliveryToken,
    required this.deliveryStatus,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.shopName,
    required this.shopPhone,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List).map((e) => OrderItem.fromJson(e)).toList(),
      shopId: json['shopId'],
      vendorId: json['vendorId'],
      total: json['total'],
      status: json['status'],
      pickupAddress: json['pickupAddress'],
      deliveryType: json['deliveryType'],
      pickupStatus: json['pickupStatus'],
      deliveryToken: json['deliveryToken'],
      deliveryAddress: json['deliveryAddress'],
      deliveryFee: json['deliveryFee'] ?? '0',
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'])
          : null,
      deliveryStatus: json['deliveryStatus'],
      version: json['_v'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      shopName: json['shopName'],
      shopPhone: json['shopPhone'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'items': items.map((e) => e.toJson()).toList(),
        'shopId': shopId,
        'vendorId': vendorId,
        'total': total,
        'status': status,
        'pickupAddress': pickupAddress,
        'pickupStatus': pickupStatus,
        'deliveryAddress': deliveryAddress,
        'deliveryFee': deliveryFee,
        'deliveryDate': deliveryDate?.toIso8601String(),
        'deliveryStatus': deliveryStatus,
        'deliveryToken': deliveryToken,
        'deliveryType': deliveryType,
        '_v': version,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'shopName': shopName,
        'shopPhone': shopPhone,
      };
}

class OrderItem {
  final String name;
  final int price;
  final int quantity;
  final String productId;
  final String? productImage;

  OrderItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.productId,
    this.productImage,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'] ?? '',
      price: json['price'],
      quantity: json['quantity'],
      productId: json['productId'],
      productImage: json['productImage'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'quantity': quantity,
        'productId': productId,
        'productImage': productImage,
      };
}

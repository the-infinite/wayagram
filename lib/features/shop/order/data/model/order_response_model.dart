import 'package:wayagram/shared/model/base_model.dart';

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
  final List<Order> docs;
  final int totalDocs;
  final int limit;
  final int page;
  final int totalPages;
  final bool hasNextPage;
  final int? nextPage;
  final bool hasPrevPage;
  final int? prevPage;
  final int pagingCounter;
  final Metadata metadata;

  OrdersData({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.hasNextPage,
    this.nextPage,
    required this.hasPrevPage,
    this.prevPage,
    required this.pagingCounter,
    required this.metadata,
  });

  factory OrdersData.fromJson(Map<String, dynamic> json) {
    return OrdersData(
      docs: (json['docs'] as List).map((e) => Order.fromJson(e)).toList(),
      totalDocs: json['totalDocs'],
      limit: json['limit'],
      page: json['page'],
      totalPages: json['totalPages'],
      hasNextPage: json['hasNextPage'],
      nextPage: json['nextPage'],
      hasPrevPage: json['hasPrevPage'],
      prevPage: json['prevPage'],
      pagingCounter: json['pagingCounter'],
      metadata: Metadata.fromJson(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() => {
        'docs': docs.map((e) => e.toJson()).toList(),
        'totalDocs': totalDocs,
        'limit': limit,
        'page': page,
        'totalPages': totalPages,
        'hasNextPage': hasNextPage,
        'nextPage': nextPage,
        'hasPrevPage': hasPrevPage,
        'prevPage': prevPage,
        'pagingCounter': pagingCounter,
        'metadata': metadata.toJson(),
      };
}

class Order extends BaseModel<Order> {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final String shopId;
  final String vendorId;
  final String total;
  final String status;
  final String? pickupAddress;
  final String? deliveryAddress;
  final dynamic deliveryFee;
  final DateTime? deliveryDate;
  final String? deliveryToken;
  final String version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String shopName;
  final String shopPhone;
  final String? deliveryType;
  final List<CartOrderStatus> deliveryStatusHistory;
  final List<CartOrderStatus> pickupStatusHistory;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.shopId,
    required this.vendorId,
    required this.total,
    required this.status,
    this.pickupAddress,
    this.deliveryAddress,
    this.deliveryFee,
    this.deliveryDate,
    this.deliveryToken,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.shopName,
    required this.shopPhone,
    this.deliveryType,
    this.deliveryStatusHistory = const [],
    this.pickupStatusHistory = const [],
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
      deliveryAddress: json['deliveryAddress'],
      deliveryFee: json['deliveryFee'],
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'])
          : null,
      deliveryToken: json['deliveryToken'],
      version: json['_v'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      shopName: json['shopName'],
      shopPhone: json['shopPhone'],
      deliveryType: json['deliveryType'],
      deliveryStatusHistory: (json['deliveryStatusHistory'] as List)
          .map((e) => CartOrderStatus.fromJson(e))
          .toList(),
      pickupStatusHistory: (json['pickupStatusHistory'] as List)
          .map((e) => CartOrderStatus.fromJson(e))
          .toList(),
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
        'deliveryAddress': deliveryAddress,
        'deliveryFee': deliveryFee,
        'deliveryDate': deliveryDate?.toIso8601String(),
        'deliveryToken': deliveryToken,
        '_v': version,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'shopName': shopName,
        'shopPhone': shopPhone,
        'deliveryType': deliveryType,
        'deliveryStatusHistory':
            deliveryStatusHistory.map((e) => e.toJson()).toList(),
        'pickupStatusHistory':
            pickupStatusHistory.map((e) => e.toJson()).toList(),
      };

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'shopId': shopId,
        'vendorId': vendorId,
        'total': total,
        'status': status,
        'pickupAddress': pickupAddress,
        'deliveryAddress': deliveryAddress,
        'deliveryFee': deliveryFee,
        'shopName': shopName,
        'shopPhone': shopPhone,
        'deliveryToken': deliveryToken,
        'deliveryType': deliveryType,
      };
}

class Metadata {
  final int offset;
  final bool searchApplied;
  final List<String> searchFields;
  final Map<String, dynamic> appliedFilters;

  Metadata({
    required this.offset,
    required this.searchApplied,
    required this.searchFields,
    required this.appliedFilters,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      offset: json['offset'],
      searchApplied: json['searchApplied'],
      searchFields: List<String>.from(json['searchFields']),
      appliedFilters: json['appliedFilters'],
    );
  }

  Map<String, dynamic> toJson() => {
        'offset': offset,
        'searchApplied': searchApplied,
        'searchFields': searchFields,
        'appliedFilters': appliedFilters,
      };
}

class OrderItem {
  final String productName;
  final String price;
  final int quantity;
  final String productId;
  final String? productImage;

  OrderItem({
    required this.productName,
    required this.price,
    required this.quantity,
    required this.productId,
    this.productImage,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productName: json['productName'] ?? '',
      price: json['price'],
      quantity: json['quantity'],
      productId: json['productId'],
      productImage: json['productImage'],
    );
  }

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'price': price,
        'quantity': quantity,
        'productId': productId,
        'productImage': productImage,
      };
}

class CartOrderStatus {
  final String status;
  final String updatedAt;

  CartOrderStatus({required this.status, required this.updatedAt});

  factory CartOrderStatus.fromJson(Map<String, dynamic> json) {
    return CartOrderStatus(
      status: json['status'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'updatedAt': updatedAt,
      };
}

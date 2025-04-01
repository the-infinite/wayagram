import 'package:wayagram/shared/model/base_model.dart';
import 'package:wayagram/features/shop/seller/data/model/pagination_model.dart';

class ProductResponse {
  final String message;
  final bool status;
  final int statusCode;
  final ProductData data;

  ProductResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: ProductData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'status': status,
        'statusCode': statusCode,
        'data': data.toJson(),
      };
}

class ProductData {
  final List<Product> data;
  final Pagination pagination;

  ProductData({
    required this.data,
    required this.pagination,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      data: List<Product>.from(
        json['data'].map((item) => Product.fromJson(item)),
      ),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data.map((item) => item.toJson()).toList(),
        'pagination': pagination.toJson(),
      };
}

class Product extends BaseModel<Product> {
  final String id;
  final String categoryId;
  final String? discountTypeId;
  final String name;
  final String description;
  final String? vendorId;
  final dynamic price;
  final int stockQuantity;
  final List<String> images;
  final int height;
  final int width;
  final String? color;
  final String materialType;
  final int depth;
  final String condition;
  final dynamic wayagramDeal;
  final dynamic dealStatus;
  final String? wayagramDealRejectedReason;
  final bool approve;
  final bool deliveryCharge;
  final String options;
  final String? pickupAddress;
  final int? rating;
  final int discountPercentage;
  final String shopId;
  final dynamic discountedPrice;
  final String shopName;
  final String shopPhone;
  final dynamic shopRating;
  final String? shopLogo;
  final String categoryName;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product(
      {required this.id,
      required this.categoryId,
      this.discountTypeId,
      required this.name,
      required this.description,
      required this.price,
      required this.stockQuantity,
      required this.images,
      required this.height,
      required this.width,
      this.color,
      required this.materialType,
      required this.depth,
      required this.condition,
      this.wayagramDeal,
      this.dealStatus,
      this.wayagramDealRejectedReason,
      required this.approve,
      required this.deliveryCharge,
      required this.options,
      required this.pickupAddress,
      this.rating,

      required this.discountPercentage,
      required this.shopId,
      required this.discountedPrice,
      required this.shopName,
      required this.shopPhone,
      required this.categoryName,
      required this.isDeleted,
      required this.createdAt,
      required this.updatedAt,
      this.vendorId,
      this.shopRating,
      this.shopLogo});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'] ?? '',
        categoryId: json['categoryId'] ?? '',
        discountTypeId: json['discountTypeId'],
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        price: json['price'],
        stockQuantity: json['stockQuantity'] ?? 0,
        images:
            (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
        height: json['height'],
        width: json['width'],
        color: json['color'] ?? '',
        materialType: json['materialType'] ?? '',
        depth: json['depth'],
        condition: json['condition'] ?? '',
        wayagramDeal: json['wayagramDeal'] ,
        dealStatus: json['dealStatus'] ?? false,
        wayagramDealRejectedReason: json['wayagramDealRejectedReason'],
        approve: json['approve'] ?? false,
        deliveryCharge: json['deliveryCharge'] ?? false,
        options: json['options'] ?? '',
        pickupAddress: json['pickupAddress'] ?? '',
        rating: json['rating'],
        discountPercentage: json['discountPercentage'] ?? 0,
        shopId: json['shopId'] ?? '',
        discountedPrice: json['discountedPrice'],
        shopName: json['shopName'] ?? '',
        shopPhone: json['shopPhone'] ?? '',
        categoryName: json['categoryName'] ?? '',
        isDeleted: json['isDeleted'] ?? false,
        createdAt: DateTime.parse(json['createdAt'] ?? ''),
        updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
        shopRating: json['shopRating'],
        vendorId: json['vendorId'] ?? '',
        shopLogo: json['shopLogo']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'discountTypeId': discountTypeId,
      'name': name,
      'description': description,
      'price': price,
      'stockQuantity': stockQuantity,
      'images': images,
      'height': height,
      'width': width,
      'color': color,
      'materialType': materialType,
      'depth': depth,
      'condition': condition,
      'wayagramDeal': wayagramDeal,
      'dealStatus': dealStatus,
      'wayagramDealRejectedReason': wayagramDealRejectedReason,
      'approve': approve,
      'deliveryCharge': deliveryCharge,
      'options': options,
      'pickupAddress': pickupAddress,
      'rating': rating,
      'discountPercentage': discountPercentage,
      'shopId': shopId,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'discountedPrice': discountedPrice,
      'shopName': shopName,
      'shopPhone': shopPhone,
      'categoryName': categoryName,
      'shopRating': shopRating,
      'shopLogo': shopLogo,
      'vendorId': vendorId
    };
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'categoryId': categoryId,
        'name': name,
        'description': description,
        'price': price,
        'materialType': materialType,
        'condition': condition,
        'deliveryCharge': deliveryCharge,
        'options': options,
        'pickupAddress': pickupAddress,
        'discountPercentage': discountPercentage,
        'shopRating': shopRating
      };

  Product copyWith(
      {String? id,
      String? categoryId,
      String? discountTypeId,
      String? name,
      String? description,
      dynamic price,
      int? stockQuantity,
      List<String>? images,
      int? height,
      int? width,
      String? color,
      String? materialType,
      int? depth,
      String? condition,
      bool? wayagramDeal,
      bool? dealStatus,
      String? wayagramDealRejectedReason,
      bool? approve,
      bool? deliveryCharge,
      String? options,
      String? pickupAddress,
      int? rating,
      int? discountPercentage,
      String? shopId,
      String? version,
      bool? isDeleted,
      DateTime? createdAt,
      DateTime? updatedAt,
      dynamic discountedPrice,
      String? shopName,
      String? shopPhone,
      String? categoryName,
      dynamic shopRating,
      String? vendorId,
      String? shopLogo}) {
    return Product(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        discountTypeId: discountTypeId ?? this.discountTypeId,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        images: images ?? this.images,
        height: height ?? this.height,
        width: width ?? this.width,
        color: color ?? this.color,
        materialType: materialType ?? this.materialType,
        depth: depth ?? this.depth,
        condition: condition ?? this.condition,
        wayagramDeal: wayagramDeal ?? this.wayagramDeal,
        dealStatus: dealStatus ?? this.dealStatus,
        wayagramDealRejectedReason:
            wayagramDealRejectedReason ?? this.wayagramDealRejectedReason,
        approve: approve ?? this.approve,
        deliveryCharge: deliveryCharge ?? this.deliveryCharge,
        options: options ?? this.options,
        pickupAddress: pickupAddress ?? this.pickupAddress,
        rating: rating ?? this.rating,
        discountPercentage: discountPercentage ?? this.discountPercentage,
        shopId: shopId ?? this.shopId,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        discountedPrice: discountedPrice ?? this.discountedPrice,
        shopName: shopName ?? this.shopName,
        shopPhone: shopPhone ?? this.shopPhone,
        categoryName: categoryName ?? this.categoryName,
        shopLogo: shopLogo ?? this.shopLogo,
        vendorId: vendorId ?? this.vendorId,
        shopRating: shopRating ?? this.shopRating);
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.parse(value);
    }
    return 0;
  }
}

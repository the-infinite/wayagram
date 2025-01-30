import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/shared/model/base_model.dart';
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

class Product extends BaseModel<Product>{
  final String id;
  final String categoryId;
  final Select? category;
  final String? discountTypeId;
  final String name;
  final String description;
  final String price;
  final int stockQuantity;
  final List<String> images;
  final int height;
  final int width;
  final String color;
  final String materialType;
  final int depth;
  final String condition;
  final bool wayagramDeal;
  final String? wayagramDealRejectedReason;
  final bool approve;
  final bool deliveryCharge;
  final String options;
  final String? pickupAddress;
  final String? rating;
  final int discountPercentage;
  final String shopId;
  final String version;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String discountedPrice;

  Product({
    required this.id,
    required this.categoryId,
    this.discountTypeId,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.images,
    required this.height,
    required this.width,
    required this.color,
    this.category,
    required this.materialType,
    required this.depth,
    required this.condition,
    required this.wayagramDeal,
    this.wayagramDealRejectedReason,
    required this.approve,
    required this.deliveryCharge,
    required this.options,
    this.pickupAddress,
    this.rating,
    required this.discountPercentage,
    required this.shopId,
    required this.version,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.discountedPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        categoryId: json['categoryId'],
        discountTypeId: json['discountTypeId'],
        name: json['name'],
        description: json['description'],
        price: json['price'],
        stockQuantity: json['stockQuantity'],
        images: List<String>.from(json['images']),
        height: json['height'],
        width: json['width'],
        color: json['color'],
        materialType: json['materialType'],
        depth: json['depth'],
        condition: json['condition'],
        wayagramDeal: json['wayagramDeal'],
        wayagramDealRejectedReason: json['wayagramDealRejectedReason'],
        approve: json['approve'],
        deliveryCharge: json['deliveryCharge'],
        options: json['options'],
        pickupAddress: json['pickupAddress'],
        rating: json['rating'],
        discountPercentage: _parseToInt(json['discountPercentage']),
        shopId: json['shopId'],
        version: json['_v'],
        isDeleted: json['isDeleted'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        discountedPrice: json['discountedPrice'],
        category: json['category']);
  }

  Map<String, dynamic> toJson() => {
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
        'wayagramDealRejectedReason': wayagramDealRejectedReason,
        'approve': approve,
        'deliveryCharge': deliveryCharge,
        'options': options,
        'pickupAddress': pickupAddress,
        'rating': rating,
        'discountPercentage': discountPercentage,
        'shopId': shopId,
        '_v': version,
        'isDeleted': isDeleted,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'discountedPrice': discountedPrice,
        'category': category
      };

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
  
      };

  Product copyWith({
    String? id,
    String? categoryId,
    Select? category,
    String? discountTypeId,
    String? name,
    String? description,
    String? price,
    int? stockQuantity,
    List<String>? images,
    int? height,
    int? width,
    String? color,
    String? materialType,
    int? depth,
    String? condition,
    bool? wayagramDeal,
    String? wayagramDealRejectedReason,
    bool? approve,
    bool? deliveryCharge,
    String? options,
    String? pickupAddress,
    String? rating,
    int? discountPercentage,
    String? shopId,
    String? version,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? discountedPrice,
  }) {
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
      category: category ?? this.category,
      materialType: materialType ?? this.materialType,
      depth: depth ?? this.depth,
      condition: condition ?? this.condition,
      wayagramDeal: wayagramDeal ?? this.wayagramDeal,
      wayagramDealRejectedReason: wayagramDealRejectedReason ?? this.wayagramDealRejectedReason,
      approve: approve ?? this.approve,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      options: options ?? this.options,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      rating: rating ?? this.rating,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      shopId: shopId ?? this.shopId,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      discountedPrice: discountedPrice ?? this.discountedPrice,
    );
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

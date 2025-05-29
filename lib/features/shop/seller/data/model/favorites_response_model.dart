import 'package:wayagram/shared/model/base_model.dart';

class FavoritesResponse {
  final String message;
  final bool status;
  final int statusCode;
  final FavoritesData data;

  FavoritesResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory FavoritesResponse.fromJson(Map<String, dynamic> json) {
    return FavoritesResponse(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: FavoritesData.fromJson(json['data']),
    );
  }
}

class FavoritesData {
  final List<FavoriteItem> favorites;
  final int total;

  FavoritesData({
    required this.favorites,
    required this.total,
  });

  factory FavoritesData.fromJson(Map<String, dynamic> json) {
    return FavoritesData(
      favorites: (json['favorites'] as List)
          .map((item) => FavoriteItem.fromJson(item))
          .toList(),
      total: json['total'],
    );
  }
}

class FavoriteItem extends BaseModel<FavoriteItem> {
  final String id;
  final String categoryId;
  final String? discountTypeId;
  final String name;
  final String description;
  final String price;
  final String discountedPrice;
  final int stockQuantity;
  final List<String> images;
  final int height;
  final int width;
  final String color;
  final String materialType;
  final int depth;
  final String condition;
  final String? wayagramDeal;
  final String? dealStatus;
  final String? wayagramDealRejectedReason;
  final bool approve;
  final bool sellerApprove;
  final bool deliveryCharge;
  final String options;
  final String pickupAddress;
  final dynamic rating;
  final int discountPercentage;
  final String shopId;
  final String v;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String favoriteId;

  FavoriteItem({
    required this.id,
    required this.categoryId,
    this.discountTypeId,
    required this.name,
    required this.description,
    required this.price,
    required this.discountedPrice,
    required this.stockQuantity,
    required this.images,
    required this.height,
    required this.width,
    required this.color,
    required this.materialType,
    required this.depth,
    required this.condition,
    this.wayagramDeal,
    this.dealStatus,
    this.wayagramDealRejectedReason,
    required this.approve,
    required this.sellerApprove,
    required this.deliveryCharge,
    required this.options,
    required this.pickupAddress,
    this.rating,
    required this.discountPercentage,
    required this.shopId,
    required this.v,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.favoriteId,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'],
      categoryId: json['categoryId'],
      discountTypeId: json['discountTypeId'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      discountedPrice: json['discountedPrice'],
      stockQuantity: json['stockQuantity'],
      images: List<String>.from(json['images']),
      height: json['height'],
      width: json['width'],
      color: json['color'],
      materialType: json['materialType'],
      depth: json['depth'],
      condition: json['condition'],
      wayagramDeal: json['wayagramDeal'],
      dealStatus: json['dealStatus'],
      wayagramDealRejectedReason: json['wayagramDealRejectedReason'],
      approve: json['approve'],
      sellerApprove: json['sellerApprove'],
      deliveryCharge: json['deliveryCharge'],
      options: json['options'],
      pickupAddress: json['pickupAddress'],
      rating: json['rating'],
      discountPercentage: json['discountPercentage'],
      shopId: json['shopId'],
      v: json['_v'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      favoriteId: json['favoriteId'],
    );
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
       
      };
}

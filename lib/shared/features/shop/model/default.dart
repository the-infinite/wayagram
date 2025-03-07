import 'package:json_annotation/json_annotation.dart';

part 'default.g.dart';

@JsonSerializable()
class ShopDetailsModel {
  final ShopModel shop;
  final String averageRating;
  final List<ReviewModel> ratings;

  ShopDetailsModel({
    required this.shop,
    required this.averageRating,
    required this.ratings,
  });

  factory ShopDetailsModel.fromJson(Map<String, dynamic> json) => _$ShopDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopDetailsModelToJson(this);
}

@JsonSerializable()
class ReviewModel {
  final String id;
  final int likes;
  final String raterId;
  final String? productId;
  final String shopId;
  final int score;
  final String review;
  final String type;
  final DateTime updatedAt;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.likes,
    required this.raterId,
    this.productId,
    required this.shopId,
    required this.score,
    required this.review,
    required this.type,
    required this.updatedAt,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}

@JsonSerializable()
class ShopModel {
  final String id;
  final String vendorId;
  final String name;
  final String description;
  final bool deactivated;
  final String? logo;
  final String? coverImage;
  final String address;
  final String state;
  final String lga;
  final double? longitude;
  final double? latitude;
  final String country;
  final String town;
  final String phone;
  final String email;
  final double? rating;
  final int totalOrders;
  final int totalProducts;
  final Map<String, dynamic>? socialLinks;
  final Map<String, dynamic>? businessHours;
  @JsonKey(name: '_v')
  final String version;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ShopModel({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.description,
    required this.deactivated,
    this.logo,
    this.coverImage,
    required this.address,
    required this.state,
    required this.lga,
    this.longitude,
    this.latitude,
    required this.country,
    required this.town,
    required this.phone,
    required this.email,
    this.rating,
    required this.totalOrders,
    required this.totalProducts,
    this.socialLinks,
    this.businessHours,
    required this.version,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) => _$ShopModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopModelToJson(this);
}

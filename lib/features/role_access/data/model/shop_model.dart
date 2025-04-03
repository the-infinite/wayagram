import 'package:json_annotation/json_annotation.dart';

part 'shop_model.g.dart';

@JsonSerializable()
class ShopModelBase {
  ShopModelBase({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final Data? data;

  factory ShopModelBase.fromJson(Map<String, dynamic> json) =>
      _$ShopModelBaseFromJson(json);

  Map<String, dynamic> toJson() => _$ShopModelBaseToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    required this.message,
    required this.shops,
  });

  final String? message;
  final List<ShopModel>? shops;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class ShopModel {
  ShopModel({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.description,
    required this.deactivated,
    required this.logo,
    required this.coverImage,
    required this.address,
    required this.state,
    required this.lga,
    required this.longitude,
    required this.latitude,
    required this.country,
    required this.town,
    required this.phone,
    required this.email,
    required this.rating,
    required this.totalOrders,
    required this.totalProducts,
    required this.socialLinks,
    required this.businessHours,
    required this.v,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? vendorId;
  final String? name;
  final String? description;
  final bool? deactivated;
  final String? logo;
  final dynamic coverImage;
  final String? address;
  final String? state;
  final String? lga;
  final String? longitude;
  final String? latitude;
  final String? country;
  final String? town;
  final String? phone;
  final String? email;
  final dynamic rating;
  final int? totalOrders;
  final int? totalProducts;
  final dynamic socialLinks;
  final dynamic businessHours;

  @JsonKey(name: '_v')
  final String? v;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ShopModel.fromJson(Map<String, dynamic> json) =>
      _$ShopModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopModelToJson(this);
}

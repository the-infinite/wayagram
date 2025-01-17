import 'package:dio/dio.dart';

class AddProductModel {
  final String name;
  final String description;
  final String shopId;
  final String categoryId;
  final String condition; // (New, Used)
  final String price;
  final String? color;
  final String? materialType;
  final String options; // (Delivery, Pickup, Both)
  final String? height;
  final String? width;
  final String? depth;
  final String? discountPercentage; // 1-100
  final String? pickupAddress;
  final bool? deliveryCharge;
  final List<MultipartFile> images;
  final bool wayagramDeal;
  final String discountTypeId;

  AddProductModel({
    required this.name,
    required this.description,
    required this.shopId,
    required this.categoryId,
    required this.condition,
    required this.price,
    required this.options,
    required this.wayagramDeal,
    required this.discountTypeId,
    required this.images,
    this.color,
    this.materialType,
    this.height,
    this.width,
    this.depth,
    this.discountPercentage,
    this.pickupAddress,
    this.deliveryCharge,
  });

  // Factory method to parse JSON
  factory AddProductModel.fromJson(Map<String, dynamic> json) {
    return AddProductModel(
      name: json['name'] as String,
      description: json['description'] as String,
      shopId: json['shopId'] as String,
      categoryId: json['categoryId'] as String,
      condition: json['condition'] as String,
      price: json['price'] as String,
      options: json['options'] as String,
      wayagramDeal: json['wayagramDeal'] as bool,
      discountTypeId: json['discountTypeId'] as String,
      images: (json['images'] as List<MultipartFile>),
      color: json['color'] as String?,
      materialType: json['materialType'] as String?,
      height: json['height'] as String?,
      width: json['width'] as String?,
      depth: json['depth'] as String?,
      discountPercentage: json['discountPercentage'] as String?,
      pickupAddress: json['pickupAddress'] as String?,
      deliveryCharge: json['deliveryCharge'] as bool?,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'name': name,
      'description': description,
      'shopId': shopId,
      'categoryId': categoryId,
      'condition': condition,
      'price': price,
      'options': options,
      'wayagramDeal': wayagramDeal,
      'discountTypeId': discountTypeId,
      'images': images,
    };

    if (color != null) json['color'] = color;
    if (materialType != null) json['materialType'] = materialType;
    if (height != null) json['height'] = height;
    if (width != null) json['width'] = width;
    if (depth != null) json['depth'] = depth;
    if (discountPercentage != null) json['discountPercentage'] = discountPercentage;
    if (pickupAddress != null) json['pickupAddress'] = pickupAddress;
    if (deliveryCharge != null) json['deliveryCharge'] = deliveryCharge;

    return json;
  }
}

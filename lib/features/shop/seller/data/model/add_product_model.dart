import 'package:dio/dio.dart';

class AddProductModel {
  final String name;
  final String description;
  final String shopId;
  final String categoryId;
  final String condition; // (New , Used)
  final String price;
  final String? color;
  final String? materialType;
  final String options; //  (Delivery, Pickup, Both)
  final String? height;
  final String? width;
  final String? depth;
  final String? discountPercentage; // 1-100
  final String? pickupAddress;
  final String? deliveryCharge;
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

  factory AddProductModel.fromJson(Map<String, dynamic> json) {
    return AddProductModel(
      name: json['name'] as String,
      description: json['description'] as String,
      shopId: json['shop_id'] as String,
      categoryId: json['category_id'] as String,
      condition: json['condition'] as String,
      price: json['price'] as String,
      options: json['options'] as String,
      wayagramDeal: json['wayagram_deal'] as bool,
      discountTypeId: json['discount_type_id'] as String,
      images: [],
      color: json['color'] as String?,
      materialType: json['material_type'] as String?,
      height: json['height'] as String?,
      width: json['width'] as String?,
      depth: json['depth'] as String?,
      discountPercentage: json['discount_percentage'] as String?,
      pickupAddress: json['pickup_address'] as String?,
      deliveryCharge: json['delivery_charge'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'shop_id': shopId,
      'category_id': categoryId,
      'condition': condition,
      'price': price,
      'color': color,
      'material_type': materialType,
      'options': options,
      'height': height,
      'width': width,
      'depth': depth,
      'discount_percentage': discountPercentage,
      'pickup_address': pickupAddress,
      'delivery_charge': deliveryCharge,
      'wayagram_deal': wayagramDeal,
      'discount_type_id': discountTypeId,
    };
  }
}

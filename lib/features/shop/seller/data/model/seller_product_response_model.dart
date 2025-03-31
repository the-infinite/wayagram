import 'package:wayagram/features/shop/seller/data/model/pagination_model.dart';

class SellerProductResponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final Data data;

  SellerProductResponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory SellerProductResponseModel.fromJson(Map<String, dynamic> json) {
    return SellerProductResponseModel(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: Data.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusCode': statusCode,
      'data': data.toJson(),
    };
  }
}

class Data {
  final List<SellerProduct> products;
  final Pagination pagination;

  Data({
    required this.products,
    required this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    var productList = json['data'] as List;
    List<SellerProduct> productItems =
        productList.map((i) => SellerProduct.fromJson(i)).toList();

    return Data(
      products: productItems,
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': products.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class SellerProduct {
  final String id;
  final String categoryId;
  final String? discountTypeId;
  final String name;
  final String description;
  final String price;
  final List<String> images;
  final int height;
  final int width;
  final String color;
  final String materialType;
  final int depth;
  final String condition;
  final bool? wayagramDeal;
  final String? wayagramDealRejectedReason;
  final bool approve;
  final bool deliveryCharge;
  final String options;
  final String? pickupAddress;
  final int? rating;
  final double discountPercentage;
  final String shopId;
  final String? discountedPrice;
  final String shopName;
  final String shopPhone;
  final String categoryName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final dynamic dealStatus;
  final dynamic shopRating;
  final String? vendorId;

  SellerProduct(
      {required this.id,
      required this.categoryId,
      this.discountTypeId,
      required this.name,
      required this.description,
      required this.price,
      required this.images,
      required this.height,
      required this.width,
      required this.color,
      required this.materialType,
      required this.depth,
      required this.condition,
      required this.wayagramDeal,
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
      required this.createdAt,
      required this.updatedAt,
      required this.isDeleted,
      this.vendorId,
      this.shopRating});

  factory SellerProduct.fromJson(Map<String, dynamic> json) {
    var imageList = json['images'] as List;
    List<String> imageItems = List<String>.from(imageList);

    return SellerProduct(
        id: json['id'],
        categoryId: json['categoryId'] ?? '',
        discountTypeId: json['discountTypeId'],
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        price: json['price'],
        images:
            (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
        height: json['height'],
        width: json['width'],
        color: json['color'] ?? '',
        materialType: json['materialType'] ?? '',
        depth: json['depth'],
        condition: json['condition'] ?? '',
        wayagramDeal: json['wayagramDeal'] ?? false,
        dealStatus: json['dealStatus'] ?? false,
        wayagramDealRejectedReason: json['wayagramDealRejectedReason'],
        approve: json['approve'] ?? false,
        deliveryCharge: json['deliveryCharge'] ?? false,
        options: json['options'] ?? '',
        pickupAddress: json['pickupAddress'] ?? '',
        rating: json['rating'],
        discountPercentage: json['discountPercentage'].toDouble(),
        shopId: json['shopId'] ?? '',
        discountedPrice: json['discountedPrice'],
        shopName: json['shopName'] ?? '',
        shopPhone: json['shopPhone'] ?? '',
        categoryName: json['categoryName'] ?? '',
        isDeleted: json['isDeleted'] ?? false,
        createdAt: DateTime.parse(json['createdAt'] ?? ''),
        updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
        vendorId: json['vendorId'] ?? '',
        shopRating: json['shopRating']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'discountTypeId': discountTypeId,
      'name': name,
      'description': description,
      'price': price,
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
      'dealStatus': dealStatus,
      'deliveryCharge': deliveryCharge,
      'options': options,
      'pickupAddress': pickupAddress,
      'rating': rating,
      'discountPercentage': discountPercentage,
      'shopId': shopId,
      'discountedPrice': discountedPrice,
      'shopName': shopName,
      'shopPhone': shopPhone,
      'categoryName': categoryName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isDeleted': isDeleted,
      'shopRating': shopRating,
      'vendorId': vendorId
    };
  }
}

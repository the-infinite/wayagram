import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/shop/seller/data/model/pagination_model.dart';

class CategoryResponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final ResponseData data;

  CategoryResponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryResponseModel(
      message: json['message'] ?? '',
      status: json['status'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      data: ResponseData.fromJson(json['data']),
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

class ResponseData {
  final List<CategoryData> categories;
  final Pagination pagination;

  ResponseData({
    required this.categories,
    required this.pagination,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      categories: (json['data'] as List)
          .map((categoryJson) => CategoryData.fromJson(categoryJson))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': categories.map((category) => category.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class CategoryData {
  final String id;
  final String name;
  final String image;
  final String description;
  final String? parentCategoryId;
  final bool isDeleted;
  final String version;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryData({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    this.parentCategoryId,
    required this.isDeleted,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      parentCategoryId: json['parentCategoryId'],
      isDeleted: json['isDeleted'] ?? false,
      version: (json['_v']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'parentCategoryId': parentCategoryId,
      'isDeleted': isDeleted,
      '_v': version,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class SelectTypePaginatedResult {
  final List<Select> items;
  final int totalPages;

  SelectTypePaginatedResult(
      {required this.items, required this.totalPages});
}

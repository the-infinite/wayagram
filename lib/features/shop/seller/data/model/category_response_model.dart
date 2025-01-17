

// Model for the entire API response
class CategoryResponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final List<CategoryData> data;

  CategoryResponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

 
  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryResponseModel(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: (json['data'] as List<dynamic>)
          .map((item) => CategoryData.fromJson(item))
          .toList(),
    );
  }

 
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusCode': statusCode,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

// Model for individual category data
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

  // Factory constructor to create a Category instance from JSON
  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      parentCategoryId: json['parentCategoryId'],
      isDeleted: json['isDeleted'],
      version: json['_v'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Convert a Category instance to JSON
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




class ContestCategory2 {
  final String? message;
  final bool? status;
  final int? statusCode;
  final List<CategoryData> data;

  ContestCategory2({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  // Factory method to create an instance from JSON
  factory ContestCategory2.fromJson(Map<String, dynamic> json) {
    return ContestCategory2(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: (json['data'] as List<dynamic>)
          .map((item) => CategoryData.fromJson(item))
          .toList(),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusCode': statusCode,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class CategoryData {
   final String? id;
  final String? name;
  final String? createdAt;
  final String? updatedAt;

  CategoryData({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an instance from JSON
  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      name: json['name'],
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
     
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
     
    };
  }
}

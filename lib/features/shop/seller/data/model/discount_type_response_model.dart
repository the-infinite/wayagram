class DiscountTypeResponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final List<DiscountData> data;

  DiscountTypeResponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  // Factory method to manually serialize from JSON
  factory DiscountTypeResponseModel.fromJson(Map<String, dynamic> json) {
    return DiscountTypeResponseModel(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: (json['data'] as List<dynamic>).map((e) => DiscountData.fromJson(e)).toList(),
    );
  }

  // Method to serialize back to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusCode': statusCode,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class DiscountData {
  final String id;
  final String type;
  final int percentage;
  final bool active;
  final DateTime startDate;
  final DateTime endDate;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  DiscountData({
    required this.id,
    required this.type,
    required this.percentage,
    required this.active,
    required this.startDate,
    required this.endDate,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to manually serialize from JSON
  factory DiscountData.fromJson(Map<String, dynamic> json) {
    return DiscountData(
      id: json['id'],
      type: json['type'],
      percentage: json['percentage'],
      active: json['active'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method to serialize back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'percentage': percentage,
      'active': active,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

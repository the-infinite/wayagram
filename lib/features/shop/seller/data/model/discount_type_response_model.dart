import 'package:wayagram/features/shop/seller/data/model/pagination_model.dart';

class DiscountsResponse {
  final String message;
  final bool status;
  final int statusCode;
  final List<Discount> discounts;
  final Pagination pagination;

  DiscountsResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.discounts,
    required this.pagination,
  });

  factory DiscountsResponse.fromJson(Map<String, dynamic> json) {
    return DiscountsResponse(
      message: json['message'] as String,
      status: json['status'] as bool,
      statusCode: json['statusCode'] as int,
      discounts: (json['data']['data'] as List<dynamic>)
          .map((item) => Discount.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['data']['pagination']),
    );
  }
}

class Discount {
  final String id;
  final String type;
  final int percentage;
  final bool active;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Discount({
    required this.id,
    required this.type,
    required this.percentage,
    required this.active,
    this.startDate,
    this.endDate,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      id: json['id'] as String,
      type: json['type'] as String,
      percentage: json['percentage'] as int,
      active: json['active'] as bool,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : json['startDate'],
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : json['endDate'],
      isDeleted: json['isDeleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

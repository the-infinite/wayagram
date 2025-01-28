import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

//part 'category_model.g.dart';

@JsonSerializable()
class ContestResponse {
  final String? message;
  final List<ContestCategory>? data;
  final String? timestamp;
  final int? statusCode;

  ContestResponse({
    this.message,
    this.data,
    this.timestamp,
    this.statusCode,
  });

  // factory ContestResponse.fromJson(Map<String, dynamic> json) =>
  //     _$ContestResponseFromJson(json);
  //
  // Map<String, dynamic> toJson() => _$ContestResponseToJson(this);
}

@JsonSerializable()
class ContestCategory {
  final String id;
  final String name;
  final String createdAt;
  final String updatedAt;

  ContestCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  // factory ContestCategory.fromJson(Map<String, dynamic> json) =>
  //     _$ContestCategoryFromJson(json);
  //
  // Map<String, dynamic> toJson() => _$ContestCategoryToJson(this);
}

// Utility function to parse JSON
// ContestResponse allCategoryDetailModelFromJson(String str) {
//   return ContestResponse.fromJson(json.decode(str));
// }

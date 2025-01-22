

import 'package:json_annotation/json_annotation.dart';
//part 'category_model.g.dart';

@JsonSerializable()
class ContestResponse {
  final String message;
  final List<ContestCategory> data;
  final String timestamp;
  final int statusCode;

  ContestResponse({
    required this.message,
    required this.data,
    required this.timestamp,
    required this.statusCode,
  });


  // factory ContestResponse.fromJson(Map<String, dynamic> json) => _$ContestResponseFromJson(json);
  // Map<String, dynamic> toJson() => _$ContestResponseToJson(this);

}

@JsonSerializable()
class ContestCategory {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  ContestCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  // factory ContestCategory.fromJson(Map<String, dynamic> json) => _$ContestCategoryFromJson(json);
  // Map<String, dynamic> toJson() => _$ContestCategoryToJson(this);
}
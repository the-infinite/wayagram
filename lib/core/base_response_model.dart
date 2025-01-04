import 'package:json_annotation/json_annotation.dart';

part 'base_response_model.g.dart';

@JsonSerializable()
class BaseResponseModele {
  BaseResponseModele({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final dynamic data;

  factory BaseResponseModele.fromJson(Map<String, dynamic> json) => _$BaseResponseModeleFromJson(json);

  Map<String, dynamic> toJson() => _$BaseResponseModeleToJson(this);
}

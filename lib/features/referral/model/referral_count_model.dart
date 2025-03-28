import 'package:json_annotation/json_annotation.dart';

part 'referral_count_model.g.dart';

@JsonSerializable()
class ReferralCountModel {
  ReferralCountModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
    required this.responseCode,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final int? data;
  final int? responseCode;

  factory ReferralCountModel.fromJson(Map<String, dynamic> json) =>
      _$ReferralCountModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReferralCountModelToJson(this);
}

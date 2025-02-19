import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';
import 'business_account_model.dart';

part 'response_model.g.dart';

@JsonSerializable()
class ResponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final Data data;

  ResponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) => _$ResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}

@JsonSerializable()
class Data {
  final UserDetailsModel user;
  final SocialProfileModel profile;
  final BusinessAccountData? business;

  Data({
    required this.user,
    required this.profile,
    required this.business,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}
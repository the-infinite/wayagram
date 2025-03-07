import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  UserModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final UserModelData? data;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class UserModelData {
  UserModelData({
    required this.userdata,
    required this.token,
  });

  final UserAccountData? userdata;
  final Token? token;

  factory UserModelData.fromJson(Map<String, dynamic> json) => _$UserModelDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelDataToJson(this);
}

@JsonSerializable()
class Token {
  Token({
    required this.token,
    required this.refreshToken,
  });

  final String? token;
  final String? refreshToken;

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);
}

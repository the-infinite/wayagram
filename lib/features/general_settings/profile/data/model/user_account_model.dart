import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
export 'package:wayagram/shared/features/user/models/default.dart';

part 'user_account_model.g.dart';

@JsonSerializable()
class UserAccountModel {
  UserAccountModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final UserData? data;

  factory UserAccountModel.fromJson(Map<String, dynamic> json) => _$UserAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserAccountModelToJson(this);
}

@JsonSerializable()
class UserData {
  UserData({
    required this.userdata,
  });

  final UserAccountData? userdata;

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@JsonSerializable()
class UserAccountData {
  UserAccountData({
    required this.user,
    required this.profile,
    required this.business,
  });

  final UserDetailsModel? user;
  final SocialProfileModel? profile;
  final BusinessDetailsModel? business;

  factory UserAccountData.fromJson(Map<String, dynamic> json) => _$UserAccountDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserAccountDataToJson(this);
}

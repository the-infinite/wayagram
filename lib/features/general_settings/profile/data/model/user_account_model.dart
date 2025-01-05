import 'package:json_annotation/json_annotation.dart';

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
  final UserAccountData? data;

  factory UserAccountModel.fromJson(Map<String, dynamic> json) =>
      _$UserAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserAccountModelToJson(this);
}

@JsonSerializable()
class UserAccountData {
  UserAccountData({
    required this.id,
    required this.phoneNumber,
    required this.email,
    required this.passwordHash,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.countryCode,
    required this.middleName,
    required this.dateOfBirth,
    required this.twoFactorEnabled,
    required this.profilePicture,
    required this.fcmToken,
    required this.emailVerified,
    required this.phoneVerified,
    required this.accountStatus,
    required this.tcAgreement,
    required this.policyAgreement,
    required this.emailVerifiedDate,
    required this.deletedAt,
    required this.roleId,
    required this.accountTypeId,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
  });

  final String? id;
  final String? phoneNumber;
  final String? email;
  final String? passwordHash;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final dynamic countryCode;
  final dynamic middleName;
  final DateTime? dateOfBirth;
  final bool? twoFactorEnabled;
  final dynamic profilePicture;
  final dynamic fcmToken;
  final bool? emailVerified;
  final bool? phoneVerified;
  final String? accountStatus;
  final bool? tcAgreement;
  final bool? policyAgreement;
  final DateTime? emailVerifiedDate;
  final dynamic deletedAt;
  final String? roleId;
  final String? accountTypeId;

  @JsonKey(name: '_v')
  final String? v;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Role? role;

  factory UserAccountData.fromJson(Map<String, dynamic> json) =>
      _$UserAccountDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserAccountDataToJson(this);
}

@JsonSerializable()
class Role {
  Role({
    required this.name,
  });

  final String? name;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  Map<String, dynamic> toJson() => _$RoleToJson(this);
}



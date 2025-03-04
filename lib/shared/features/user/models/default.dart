import 'package:json_annotation/json_annotation.dart';
import 'package:get/get.dart';

part 'default.g.dart';

@JsonSerializable()
class UserRole {
  final String? name;

  UserRole({
    required this.name,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) => _$UserRoleFromJson(json);

  Map<String, dynamic> toJson() => _$UserRoleToJson(this);
}

@JsonSerializable()
class UserDetailsModel {
  final String id;
  final String? phoneNumber;
  final String? email;
  final String firstName;
  final String lastName;
  final String? gender;
  final String? address;
  final String? passwordHash;
  final String? city;
  final String? lga;
  final String? state;
  final String? country;
  final String? countryCode;
  final String? postalCode;
  final String? middleName;
  final DateTime? dateOfBirth;
  final bool? twoFactorEnabled;
  final String? profilePicture;
  final String? fcmToken;
  final bool? emailVerified;
  final bool? phoneVerified;
  final String? accountStatus;
  final bool? tcAgreement;
  final bool? policyAgreement;
  final DateTime? emailVerifiedDate;
  final String? deletedAt;
  final String? roleId;
  final String? accountTypeId;

  @JsonKey(name: '_v')
  final String? v;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserRole? role;
  final String? accountType;

  UserDetailsModel({
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
    required this.accountType,
    required this.lga,
    required this.postalCode,
  });

  String get fullname => "${firstName.capitalizeFirst} ${lastName.capitalizeFirst}";

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) => _$UserDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsModelToJson(this);
}

@JsonSerializable()
class SocialProfileModel {
  final String? id;
  final String? userId;
  final String? avatar;
  final String? coverImage;
  final String? bio;
  final String? username;
  final String? displayName;
  final bool? isPublic;
  final bool? isBanned;
  final DateTime? deletedAt;
  final bool? simulatedUser;
  final bool? isMuted;
  final String? referenceCode;
  final dynamic referredBy;
  final String? streamKey;
  final bool? hasFollowedAll;

  SocialProfileModel({
    required this.id,
    required this.userId,
    required this.avatar,
    required this.coverImage,
    required this.bio,
    required this.username,
    required this.displayName,
    required this.isPublic,
    required this.isBanned,
    required this.deletedAt,
    required this.simulatedUser,
    required this.isMuted,
    required this.referenceCode,
    required this.referredBy,
    required this.streamKey,
    required this.hasFollowedAll,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
  });

  @JsonKey(name: '_v')
  final String? v;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory SocialProfileModel.fromJson(Map<String, dynamic> json) => _$SocialProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocialProfileModelToJson(this);
}

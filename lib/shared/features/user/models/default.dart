import 'package:json_annotation/json_annotation.dart';
import 'package:get/get.dart';

part 'default.g.dart';

enum UserAccountType {
  @JsonValue("PERSONAL")
  personal,

  @JsonValue("BUSINESS")
  business,
}

@JsonSerializable()
class UserRole {
  final String? name;

  UserRole({
    required this.name,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) => _$UserRoleFromJson(json);

  Map<String, dynamic> toJson() => _$UserRoleToJson(this);
}

@JsonSerializable(createFactory: false)
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
  final String? role;
  final UserAccountType? accountType;

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

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      passwordHash: json['passwordHash'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      countryCode: json['countryCode'] as String?,
      middleName: json['middleName'] as String?,
      dateOfBirth: json['dateOfBirth'] == null ? null : DateTime.parse(json['dateOfBirth'] as String),
      twoFactorEnabled: json['twoFactorEnabled'] as bool?,
      profilePicture: json['profilePicture'] as String?,
      fcmToken: json['fcmToken'] as String?,
      emailVerified: json['emailVerified'] as bool?,
      phoneVerified: json['phoneVerified'] as bool?,
      accountStatus: json['accountStatus'] as String?,
      tcAgreement: json['tcAgreement'] as bool?,
      policyAgreement: json['policyAgreement'] as bool?,
      emailVerifiedDate: json['emailVerifiedDate'] == null ? null : DateTime.parse(json['emailVerifiedDate'] as String),
      deletedAt: json['deletedAt'] as String?,
      roleId: json['roleId'] as String?,
      accountTypeId: json['accountTypeId'] as String?,
      v: json['_v'] as String?,
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
      role: json['role'] == null
          ? null
          : json['role'] is Map<String, dynamic>
              ? UserRole.fromJson(json['role']).name
              : json['role'],
      accountType: $enumDecodeNullable(_$UserAccountTypeEnumMap, json['accountType']),
      lga: json['lga'] as String?,
      postalCode: json['postalCode'] as String?,
    );
  }

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

@JsonSerializable()
class BusinessDetailsModel {
  final String id;
  final String userId;
  final String name;
  final String businessTypeId;
  final String? contactEmail;
  final String? contactPhone;
  final String? description;
  final String? logoUrl;
  final String businessId;
  final String? websiteUrl;
  final String address;
  final String city;
  final String lga;
  final String state;
  final String country;
  final bool isActive;
  final DateTime? verifiedAt;
  final DateTime? deletedAt;
  @JsonKey(name: '_v')
  final String version;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BusinessDetailsModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.businessTypeId,
    this.contactEmail,
    this.contactPhone,
    this.description,
    this.logoUrl,
    required this.businessId,
    this.websiteUrl,
    required this.address,
    required this.city,
    required this.lga,
    required this.state,
    required this.country,
    required this.isActive,
    this.verifiedAt,
    this.deletedAt,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusinessDetailsModel.fromJson(Map<String, dynamic> json) => _$BusinessDetailsModelFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessDetailsModelToJson(this);
}

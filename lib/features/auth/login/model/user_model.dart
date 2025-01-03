import 'package:json_annotation/json_annotation.dart';

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

  final Userdata? userdata;
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

@JsonSerializable()
class Userdata {
  Userdata({
    required this.user,
    required this.profile,
  });

  final User? user;
  final Profile? profile;

  factory Userdata.fromJson(Map<String, dynamic> json) => _$UserdataFromJson(json);

  Map<String, dynamic> toJson() => _$UserdataToJson(this);
}

@JsonSerializable()
class Profile {
  Profile({
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

  final String? id;
  final String? userId;
  final dynamic avatar;
  final dynamic coverImage;
  final dynamic bio;
  final String? username;
  final String? displayName;
  final bool? isPublic;
  final bool? isBanned;
  final dynamic deletedAt;
  final bool? simulatedUser;
  final bool? isMuted;
  final String? referenceCode;
  final dynamic referredBy;
  final String? streamKey;
  final bool? hasFollowedAll;

  @JsonKey(name: '_v')
  final String? v;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

@JsonSerializable()
class User {
  User({
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

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

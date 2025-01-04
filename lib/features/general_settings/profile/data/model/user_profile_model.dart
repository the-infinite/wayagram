import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel {
  UserProfileModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final UserProfileData? data;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}

@JsonSerializable()
class UserProfileData {
  UserProfileData({
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
  final String? bio;
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

  factory UserProfileData.fromJson(Map<String, dynamic> json) => _$UserProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileDataToJson(this);
}

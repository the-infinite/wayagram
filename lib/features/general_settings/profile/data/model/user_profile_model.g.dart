// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      message: json['message'] as String?,
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : UserProfileData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'statusCode': instance.statusCode,
      'data': instance.data,
    };

UserProfileData _$UserProfileDataFromJson(Map<String, dynamic> json) =>
    UserProfileData(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      avatar: json['avatar'],
      coverImage: json['coverImage'],
      bio: json['bio'] as String?,
      username: json['username'] as String?,
      displayName: json['displayName'] as String?,
      isPublic: json['isPublic'] as bool?,
      isBanned: json['isBanned'] as bool?,
      deletedAt: json['deletedAt'],
      simulatedUser: json['simulatedUser'] as bool?,
      isMuted: json['isMuted'] as bool?,
      referenceCode: json['referenceCode'] as String?,
      referredBy: json['referredBy'],
      streamKey: json['streamKey'] as String?,
      hasFollowedAll: json['hasFollowedAll'] as bool?,
      v: json['_v'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserProfileDataToJson(UserProfileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'avatar': instance.avatar,
      'coverImage': instance.coverImage,
      'bio': instance.bio,
      'username': instance.username,
      'displayName': instance.displayName,
      'isPublic': instance.isPublic,
      'isBanned': instance.isBanned,
      'deletedAt': instance.deletedAt,
      'simulatedUser': instance.simulatedUser,
      'isMuted': instance.isMuted,
      'referenceCode': instance.referenceCode,
      'referredBy': instance.referredBy,
      'streamKey': instance.streamKey,
      'hasFollowedAll': instance.hasFollowedAll,
      '_v': instance.v,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

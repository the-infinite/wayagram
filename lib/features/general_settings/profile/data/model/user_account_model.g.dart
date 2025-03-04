// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAccountModel _$UserAccountModelFromJson(Map<String, dynamic> json) =>
    UserAccountModel(
      message: json['message'] as String?,
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : UserData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserAccountModelToJson(UserAccountModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'statusCode': instance.statusCode,
      'data': instance.data,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      userdata: json['userdata'] == null
          ? null
          : UserAccountData.fromJson(json['userdata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'userdata': instance.userdata,
    };

UserAccountData _$UserAccountDataFromJson(Map<String, dynamic> json) =>
    UserAccountData(
      user: json['user'] == null
          ? null
          : UserDetailsModel.fromJson(json['user'] as Map<String, dynamic>),
      profile: json['profile'] == null
          ? null
          : SocialProfileModel.fromJson(
              json['profile'] as Map<String, dynamic>),
      business: json['business'] == null
          ? null
          : BusinessDetailsModel.fromJson(
              json['business'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserAccountDataToJson(UserAccountData instance) =>
    <String, dynamic>{
      'user': instance.user,
      'profile': instance.profile,
      'business': instance.business,
    };

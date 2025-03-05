// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      message: json['message'] as String?,
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : UserModelData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'statusCode': instance.statusCode,
      'data': instance.data,
    };

UserModelData _$UserModelDataFromJson(Map<String, dynamic> json) =>
    UserModelData(
      userdata: json['userdata'] == null
          ? null
          : UserAccountData.fromJson(json['userdata'] as Map<String, dynamic>),
      token: json['token'] == null
          ? null
          : Token.fromJson(json['token'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelDataToJson(UserModelData instance) =>
    <String, dynamic>{
      'userdata': instance.userdata,
      'token': instance.token,
    };

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseModel _$ResponseModelFromJson(Map<String, dynamic> json) =>
    ResponseModel(
      message: json['message'] as String,
      status: json['status'] as bool,
      statusCode: (json['statusCode'] as num).toInt(),
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResponseModelToJson(ResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'statusCode': instance.statusCode,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      profile:
          UserProfileData.fromJson(json['profile'] as Map<String, dynamic>),
      business: json['business'] == null
          ? null
          : BusinessAccountData.fromJson(
              json['business'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'user': instance.user,
      'profile': instance.profile,
      'business': instance.business,
    };

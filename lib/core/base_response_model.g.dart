// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponseModele _$BaseResponseModeleFromJson(Map<String, dynamic> json) =>
    BaseResponseModele(
      message: json['message'] as String?,
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      data: json['data'],
    );

Map<String, dynamic> _$BaseResponseModeleToJson(BaseResponseModele instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'statusCode': instance.statusCode,
      'data': instance.data,
    };

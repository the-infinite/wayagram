// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_poll_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePollModel _$CreatePollModelFromJson(Map<String, dynamic> json) =>
    CreatePollModel(
      description: json['description'] as String?,
      type: json['type'] as String?,
      voteLimit: json['voteLimit'] as String?,
      pollCategory: json['pollCategory'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      startTime: (json['startTime'] as num?)?.toInt(),
      endTime: (json['endTime'] as num?)?.toInt(),
      showResult: json['showResult'] as bool?,
      schedule: json['schedule'] as bool?,
      isPaid: json['isPaid'] as bool?,
      amount: json['amount'] as String?,
    );

Map<String, dynamic> _$CreatePollModelToJson(CreatePollModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'type': instance.type,
      'voteLimit': instance.voteLimit,
      'pollCategory': instance.pollCategory,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'showResult': instance.showResult,
      'schedule': instance.schedule,
      'isPaid': instance.isPaid,
      'amount': instance.amount,
    };

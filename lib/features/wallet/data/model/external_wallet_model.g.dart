// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExternalWalletModel _$ExternalWalletModelFromJson(Map<String, dynamic> json) =>
    ExternalWalletModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      provider: json['provider'] as String,
      accountName: json['accountName'] as String,
      accountNumber: json['accountNumber'] as String,
      providerName: json['providerName'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ExternalWalletModelToJson(
        ExternalWalletModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'provider': instance.provider,
      'accountName': instance.accountName,
      'accountNumber': instance.accountNumber,
      'providerName': instance.providerName,
      'type': instance.type,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

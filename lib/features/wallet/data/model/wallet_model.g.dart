// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
      id: json['id'] as String,
      userId: json['userId'] as String,
      balance: json['balance'] as String,
      currency: json['currency'] as String,
      provider: json['provider'] as String,
      isDefault: json['isDefault'] as bool,
      isAdmin: json['isAdmin'] as bool,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'balance': instance.balance,
      'currency': instance.currency,
      'provider': instance.provider,
      'isDefault': instance.isDefault,
      'isAdmin': instance.isAdmin,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

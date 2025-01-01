// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateWalletPin _$CreateWalletPinFromJson(Map<String, dynamic> json) =>
    CreateWalletPin(
      confirmPin: json['confirmPin'] as String,
      pin: json['pin'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$CreateWalletPinToJson(CreateWalletPin instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'pin': instance.pin,
      'confirmPin': instance.confirmPin,
    };

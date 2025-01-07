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

ConfirmWalletPin _$ConfirmWalletPinFromJson(Map<String, dynamic> json) =>
    ConfirmWalletPin(
      pin: json['pin'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$ConfirmWalletPinToJson(ConfirmWalletPin instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'pin': instance.pin,
    };

FundWallet _$FundWalletFromJson(Map<String, dynamic> json) => FundWallet(
      userId: json['userId'] as String,
      fundOptionCode: json['fundOptionCode'] as String,
      amount: (json['amount'] as num).toDouble(),
      email: json['email'] as String,
      description: json['description'] as String,
      callbackUrl: json['callbackUrl'] as String?,
    );

Map<String, dynamic> _$FundWalletToJson(FundWallet instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fundOptionCode': instance.fundOptionCode,
      'amount': instance.amount,
      'email': instance.email,
      'description': instance.description,
      'callbackUrl': instance.callbackUrl,
    };

VerifyTransaction _$VerifyTransactionFromJson(Map<String, dynamic> json) =>
    VerifyTransaction(
      userId: json['userId'] as String,
      fundOptionCode: json['fundOptionCode'] as String,
      transactionId: json['transactionId'] as String,
    );

Map<String, dynamic> _$VerifyTransactionToJson(VerifyTransaction instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fundOptionCode': instance.fundOptionCode,
      'transactionId': instance.transactionId,
    };

PayForService _$PayForServiceFromJson(Map<String, dynamic> json) =>
    PayForService(
      recipientId: json['recipientId'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      purpose: json['purpose'] as String,
      referenceId: json['referenceId'] as String,
      description: json['description'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PayForServiceToJson(PayForService instance) =>
    <String, dynamic>{
      'recipientId': instance.recipientId,
      'userId': instance.userId,
      'amount': instance.amount,
      'purpose': instance.purpose,
      'referenceId': instance.referenceId,
      'description': instance.description,
      'metadata': instance.metadata,
    };

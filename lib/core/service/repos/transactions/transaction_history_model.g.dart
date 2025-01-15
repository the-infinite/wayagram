// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionDetail _$TransactionDetailFromJson(Map<String, dynamic> json) =>
    TransactionDetail(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: json['amount'] as String,
      fees: json['fees'] as String,
      type: json['type'] as String,
      purpose: json['purpose'] as String,
      senderId: json['senderId'] as String?,
      recipientId: json['recipientId'] as String?,
      referenceId: json['referenceId'] as String,
      transactionId: json['transactionId'] as String,
      netAmount: json['netAmount'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
      status: json['status'] as String,
      deletedAt: json['deletedAt'] as String?,
      paymentMethod: json['paymentMethod'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TransactionDetailToJson(TransactionDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'amount': instance.amount,
      'fees': instance.fees,
      'type': instance.type,
      'purpose': instance.purpose,
      'senderId': instance.senderId,
      'recipientId': instance.recipientId,
      'referenceId': instance.referenceId,
      'transactionId': instance.transactionId,
      'netAmount': instance.netAmount,
      'metadata': instance.metadata,
      'status': instance.status,
      'deletedAt': instance.deletedAt,
      'paymentMethod': instance.paymentMethod,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

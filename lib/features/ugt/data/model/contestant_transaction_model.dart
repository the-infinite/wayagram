import 'package:json_annotation/json_annotation.dart';

part 'contestant_transaction_model.g.dart';

@JsonSerializable()
class ContestantTransactionModel {
  ContestantTransactionModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final Data? data;

  factory ContestantTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$ContestantTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContestantTransactionModelToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    required this.totalSum,
    required this.transactions,
  });

  final int? totalSum;
  final List<Transaction>? transactions;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}


@JsonSerializable()
class Transaction {
  Transaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.fees,
    required this.type,
    required this.purpose,
    required this.senderId,
    required this.recipientId,
    required this.referenceId,
    required this.transactionId,
    required this.netAmount,
    required this.metadata,
    required this.status,
    required this.deletedAt,
    required this.paymentMethod,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? userId;
  final String? amount;
  final String? fees;
  final String? type;
  final String? purpose;
  final String? senderId;
  final String? recipientId;
  final String? referenceId;
  final String? transactionId;
  final String? netAmount;
  final Metadata? metadata;
  final String? status;
  final dynamic deletedAt;
  final String? paymentMethod;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable()
class Metadata {
  Metadata({
    required this.contestId,
    required this.contestantId,
  });

  final String? contestId;
  final String? contestantId;

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}

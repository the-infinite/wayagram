import 'package:json_annotation/json_annotation.dart';

part 'transaction_history_model.g.dart';

@JsonSerializable()
class TransactionDetail {
  final String id;
  final String userId;
  final String amount;
  final String fees;
  final String type;
  final String purpose;
  final String? senderId;
  final String? recipientId;
  final String referenceId;
  final String transactionId;
  final String netAmount;
  final Map<String, dynamic>? metadata;
  final String status;
  final String? deletedAt;
  final String paymentMethod;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionDetail({
    required this.id,
    required this.userId,
    required this.amount,
    required this.fees,
    required this.type,
    required this.purpose,
    this.senderId,
    this.recipientId,
    required this.referenceId,
    required this.transactionId,
    required this.netAmount,
    this.metadata,
    required this.status,
    this.deletedAt,
    required this.paymentMethod,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) => _$TransactionDetailFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionDetailToJson(this);
}


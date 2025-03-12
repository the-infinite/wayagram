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
  final List<dynamic>? transactions;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

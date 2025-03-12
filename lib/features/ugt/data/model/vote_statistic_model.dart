import 'package:json_annotation/json_annotation.dart';

part 'vote_statistic_model.g.dart';

@JsonSerializable()
class VoteStatisticModel {
  VoteStatisticModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final Data? data;

  factory VoteStatisticModel.fromJson(Map<String, dynamic> json) =>
      _$VoteStatisticModelFromJson(json);

  Map<String, dynamic> toJson() => _$VoteStatisticModelToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    required this.totalVotes,
    required this.totalPaidAmount,
    required this.totalFreeAmount,
    required this.totalAmount,
    required this.totalVoters,
  });

  final int? totalVotes;
  final int? totalPaidAmount;
  final int? totalFreeAmount;
  final int? totalAmount;
  final int? totalVoters;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

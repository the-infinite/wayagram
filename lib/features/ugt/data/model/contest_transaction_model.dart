import 'package:json_annotation/json_annotation.dart';

part 'contest_transaction_model.g.dart';

@JsonSerializable()
class ContestTransactionModelBase {
  ContestTransactionModelBase({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final Data? data;

  factory ContestTransactionModelBase.fromJson(Map<String, dynamic> json) =>
      _$ContestTransactionModelBaseFromJson(json);

  Map<String, dynamic> toJson() => _$ContestTransactionModelBaseToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.hasNextPage,
    required this.nextPage,
    required this.hasPrevPage,
    required this.prevPage,
    required this.pagingCounter,
    required this.metadata,
  });

  final List<ContestTransactionModel>? docs;
  final int? totalDocs;
  final int? limit;
  final int? page;
  final int? totalPages;
  final bool? hasNextPage;
  final dynamic nextPage;
  final bool? hasPrevPage;
  final dynamic prevPage;
  final int? pagingCounter;
  final Metadata? metadata;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class ContestTransactionModel {
  ContestTransactionModel({
    required this.id,
    required this.contestId,
    required this.userId,
    required this.type,
    required this.status,
    required this.name,
    required this.settledAt,
    required this.totalAmount,
    required this.amountToBePaid,
    required this.commission,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? contestId;
  final String? userId;
  final String? type;
  String? name;
  final String? status;
  final dynamic settledAt;
  final int? totalAmount;
  final dynamic amountToBePaid;
  final dynamic commission;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ContestTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$ContestTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContestTransactionModelToJson(this);
}

@JsonSerializable()
class Metadata {
  Metadata({
    required this.offset,
    required this.searchApplied,
    required this.searchFields,
    required this.appliedFilters,
  });

  final int? offset;
  final bool? searchApplied;
  final List<dynamic>? searchFields;
  final AppliedFilters? appliedFilters;

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}

@JsonSerializable()
class AppliedFilters {
  AppliedFilters({
    required this.contestId,
  });

  final String? contestId;

  factory AppliedFilters.fromJson(Map<String, dynamic> json) =>
      _$AppliedFiltersFromJson(json);

  Map<String, dynamic> toJson() => _$AppliedFiltersToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'payout_history_model.g.dart';

@JsonSerializable()
class PayoutHistoryModelBase {
    PayoutHistoryModelBase({
        required this.message,
        required this.status,
        required this.statusCode,
        required this.data,
        required this.responseCode,
    });

    final String? message;
    final bool? status;
    final int? statusCode;
    final Data? data;
    final int? responseCode;

    factory PayoutHistoryModelBase.fromJson(Map<String, dynamic> json) => _$PayoutHistoryModelBaseFromJson(json);

    Map<String, dynamic> toJson() => _$PayoutHistoryModelBaseToJson(this);

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

    final List<PayoutHistoryModel>? docs;
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
class PayoutHistoryModel {
    PayoutHistoryModel({
        required this.id,
        required this.userId,
        required this.accountNumber,
        required this.accountName,
        required this.bankName,
        required this.bankCode,
        required this.status,
        required this.referenceId,
        required this.metadata,
        required this.totalAmount,
        required this.commission,
        required this.amountToBePaid,
        required this.requestedAt,
        required this.deletedAt,
        required this.completedAt,
        required this.statusHistory,
        required this.userCommissionId,
        required this.purpose,
        required this.createdAt,
        required this.updatedAt,
        required this.payoutMethodId,
    });

    final String? id;
    final String? userId;
    final String? accountNumber;
    final String? accountName;
    final String? bankName;
    final String? bankCode;
    final String? status;
    final String? referenceId;
    final dynamic metadata;
    final String? totalAmount;
    final String? commission;
    final String? amountToBePaid;
    final DateTime? requestedAt;
    final dynamic deletedAt;
    final dynamic completedAt;
    final dynamic statusHistory;
    final String? userCommissionId;
    final String? purpose;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic payoutMethodId;

    factory PayoutHistoryModel.fromJson(Map<String, dynamic> json) => _$PayoutHistoryModelFromJson(json);

    Map<String, dynamic> toJson() => _$PayoutHistoryModelToJson(this);

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

    factory Metadata.fromJson(Map<String, dynamic> json) => _$MetadataFromJson(json);

    Map<String, dynamic> toJson() => _$MetadataToJson(this);

}

@JsonSerializable()
class AppliedFilters {
    AppliedFilters({
        required this.referenceId,
        required this.purpose,
        required this.userId,
        required this.deletedAt,
    });

    final String? referenceId;
    final String? purpose;
    final String? userId;
    final dynamic deletedAt;

    factory AppliedFilters.fromJson(Map<String, dynamic> json) => _$AppliedFiltersFromJson(json);

    Map<String, dynamic> toJson() => _$AppliedFiltersToJson(this);

}

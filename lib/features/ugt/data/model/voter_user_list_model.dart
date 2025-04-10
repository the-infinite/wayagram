import 'package:json_annotation/json_annotation.dart';

part 'voter_user_list_model.g.dart';

@JsonSerializable()
class VoterListBaseModel {
  VoterListBaseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final Data? data;

  factory VoterListBaseModel.fromJson(Map<String, dynamic> json) =>
      _$VoterListBaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$VoterListBaseModelToJson(this);
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

  final List<VoterListModel>? docs;
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
class VoterListModel {
  VoterListModel({
    required this.id,
    required this.hostUserId,
    required this.contestId,
    required this.contestantId,
    required this.amount,
    required this.type,
    required this.numberOfVotes,
    required this.status,
    required this.name,
    required this.profileImageUrl,
    required this.profileId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? hostUserId;
  final String? contestId;
  final String? contestantId;
  final int? amount;
  final String? type;
  String? name;
  String? profileImageUrl;
  final int? numberOfVotes;
  final String? status;
  final String? profileId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory VoterListModel.fromJson(Map<String, dynamic> json) =>
      _$VoterListModelFromJson(json);

  Map<String, dynamic> toJson() => _$VoterListModelToJson(this);
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
    required this.contestantId,
    required this.status,
  });

  final String? contestantId;
  final String? status;

  factory AppliedFilters.fromJson(Map<String, dynamic> json) =>
      _$AppliedFiltersFromJson(json);

  Map<String, dynamic> toJson() => _$AppliedFiltersToJson(this);
}

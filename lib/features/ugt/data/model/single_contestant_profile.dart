import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart';

part 'single_contestant_profile.g.dart';

@JsonSerializable()
class SingleContestProfileBase {
  SingleContestProfileBase({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final Data? data;

  factory SingleContestProfileBase.fromJson(Map<String, dynamic> json) =>
      _$SingleContestProfileBaseFromJson(json);

  Map<String, dynamic> toJson() => _$SingleContestProfileBaseToJson(this);
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

  final List<MyContestContestantModel>? docs;
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
class Metadata {
  Metadata({
    required this.offset,
    required this.searchApplied,
    required this.searchFields,
    required this.appliedFilters,
  });

  final int? offset;
  final bool? searchApplied;
  final List<String>? searchFields;
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

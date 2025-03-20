import 'package:json_annotation/json_annotation.dart';

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

  final List<Doc>? docs;
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
class Doc {
  Doc({
    required this.id,
    required this.profileId,
    required this.contestApplicationId,
    required this.contestId,
    required this.profilePhoto,
    required this.bio,
    required this.expectationFromVoters,
    required this.introVideo,
    required this.hasPaid,
    required this.status,
    required this.stages,
    required this.createdAt,
    required this.updatedAt,
    required this.contestApplicant,
    required this.votes,
  });

  final String? id;
  final String? profileId;
  final String? contestApplicationId;
  final String? contestId;
  final String? profilePhoto;
  final String? bio;
  final String? expectationFromVoters;
  final String? introVideo;
  final bool? hasPaid;
  final String? status;
  final List<dynamic>? stages;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ContestApplicant? contestApplicant;
  final int? votes;

  factory Doc.fromJson(Map<String, dynamic> json) => _$DocFromJson(json);

  Map<String, dynamic> toJson() => _$DocToJson(this);
}

@JsonSerializable()
class ContestApplicant {
  ContestApplicant({
    required this.id,
    required this.contestId,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.state,
    required this.address,
    required this.applicationData,
    required this.status,
    required this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? contestId;
  final String? userId;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final dynamic state;
  final String? address;
  final ApplicationData? applicationData;
  final String? status;
  final String? rejectionReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ContestApplicant.fromJson(Map<String, dynamic> json) =>
      _$ContestApplicantFromJson(json);

  Map<String, dynamic> toJson() => _$ContestApplicantToJson(this);
}

@JsonSerializable()
class ApplicationData {
  ApplicationData({
    required this.birthName,
    required this.birthCertificate,
  });

  @JsonKey(name: 'Birth name')
  final String? birthName;

  @JsonKey(name: 'birth certificate')
  final String? birthCertificate;

  factory ApplicationData.fromJson(Map<String, dynamic> json) =>
      _$ApplicationDataFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationDataToJson(this);
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

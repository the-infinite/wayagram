import 'package:json_annotation/json_annotation.dart';

part 'referral_model.g.dart';

@JsonSerializable()
class ReferralModelBase {
  ReferralModelBase({
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

  factory ReferralModelBase.fromJson(Map<String, dynamic> json) =>
      _$ReferralModelBaseFromJson(json);

  Map<String, dynamic> toJson() => _$ReferralModelBaseToJson(this);
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

  final List<ReferralModel>? docs;
  final int? totalDocs;
  final int? limit;
  final int? page;
  final int? totalPages;
  final bool? hasNextPage;
  final int? nextPage;
  final bool? hasPrevPage;
  final int? prevPage;
  final int? pagingCounter;
  final Metadata? metadata;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class ReferralModel {
  ReferralModel({
    required this.id,
    required this.referredId,
    required this.referrerId,
    required this.referralCode,
    required this.rewardAmount,
    required this.isPaid,
    required this.isEligible,
    required this.createdAt,
    required this.updatedAt,
    required this.referredUser,
  });

  final String? id;
  final String? referredId;
  final String? referrerId;
  final String? referralCode;
  final dynamic rewardAmount;
  final bool? isPaid;
  final bool? isEligible;
  final String? createdAt;
  final String? updatedAt;
  final ReferredUser? referredUser;

  factory ReferralModel.fromJson(Map<String, dynamic> json) =>
      _$ReferralModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReferralModelToJson(this);
}

@JsonSerializable()
class ReferredUser {
  ReferredUser({
    required this.id,
    required this.userId,
    required this.avatar,
    required this.username,
    required this.displayName,
  });

  final String? id;
  final String? userId;
  final String? avatar;
  final String? username;
  final String? displayName;

  factory ReferredUser.fromJson(Map<String, dynamic> json) =>
      _$ReferredUserFromJson(json);

  Map<String, dynamic> toJson() => _$ReferredUserToJson(this);
}

@JsonSerializable()
class Metadata {
  Metadata({
    required this.offset,
    required this.searchApplied,
    required this.searchFields,
  });

  final int? offset;
  final bool? searchApplied;
  final List<dynamic>? searchFields;

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}

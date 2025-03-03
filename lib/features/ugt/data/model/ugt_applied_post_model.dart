import 'package:json_annotation/json_annotation.dart';

part 'ugt_applied_post_model.g.dart';

@JsonSerializable(createToJson: false)
class AppliedContest {
  AppliedContest({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final List<AppliedContestModel>? data;

  factory AppliedContest.fromJson(Map<String, dynamic> json) =>
      _$AppliedContestFromJson(json);
}

@JsonSerializable(createToJson: false)
class AppliedContestModel {
  AppliedContestModel({
    required this.id,
    required this.contestId,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.applicationData,
    required this.status,
    required this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
    required this.contest,
    required this.categoryName,
    required this.applicantCount,
  });

  final String? id;
  final String? contestId;
  final String? userId;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final ApplicationData? applicationData;
  final String? status;
  final String? rejectionReason;
  final String? createdAt;
  final String? updatedAt;
  final Contest? contest;
  final String? categoryName;
  final String? applicantCount;

  factory AppliedContestModel.fromJson(Map<String, dynamic> json) =>
      _$AppliedContestModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class ApplicationData {
  ApplicationData({
    required this.fullName,
    required this.portfolio,
    required this.emailAddress,
  });

  @JsonKey(name: 'Full Name')
  final String? fullName;

  @JsonKey(name: 'Portfolio')
  final String? portfolio;

  @JsonKey(name: 'Email Address')
  final String? emailAddress;

  factory ApplicationData.fromJson(Map<String, dynamic> json) =>
      _$ApplicationDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class Contest {
  Contest({
    required this.id,
    required this.profileId,
    required this.hostId,
    required this.title,
    required this.category,
    required this.state,
    required this.description,
    required this.voteCountToQualify,
    required this.winnerPrize,
    required this.publicity,
    required this.overallResult,
    required this.type,
    required this.amountPerVote,
    required this.numberOfWeeks,
    required this.uploadCoverImages,
    required this.howItWorks,
    required this.entryType,
    required this.amount,
    required this.durationType,
    required this.numberOfDuration,
    required this.participationStartDate,
    required this.descriptionOfAwards,
    required this.startDate,
    required this.endDate,
    required this.multipleStages,
    required this.currentStage,
    required this.contestStatus,
    required this.rejectedReason,
    required this.status,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.applicantCount,
  });

  final String? id;
  final String? profileId;
  final String? hostId;
  final String? title;
  final String? category;
  final String? state;
  final String? description;
  final String? voteCountToQualify;
  final String? winnerPrize;
  final String? publicity;
  final String? overallResult;
  final String? type;
  final int? amountPerVote;
  final int? numberOfWeeks;
  final String? uploadCoverImages;
  final String? howItWorks;
  final String? entryType;
  final int? amount;
  final String? durationType;
  final String? numberOfDuration;
  final String? participationStartDate;
  final String? descriptionOfAwards;
  final String? startDate;
  final String? endDate;
  final String? multipleStages;
  final String? currentStage;
  final String? contestStatus;
  final String? rejectedReason;
  final String? status;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? applicantCount;

  factory Contest.fromJson(Map<String, dynamic> json) =>
      _$ContestFromJson(json);
}

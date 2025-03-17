import 'package:json_annotation/json_annotation.dart';

import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart' as post;

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
  final Data? data;

  factory AppliedContest.fromJson(Map<String, dynamic> json) =>
      _$AppliedContestFromJson(json);
}

@JsonSerializable(createToJson: false)
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
  });

  final List<AppliedContestModel>? docs;
  final int? totalDocs;
  final int? limit;
  final int? page;
  final int? totalPages;
  final bool? hasNextPage;
  final int? nextPage;
  final bool? hasPrevPage;
  final int? prevPage;
  final int? pagingCounter;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
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
    required this.state,
    required this.address,
    required this.applicationData,
    required this.status,
    required this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
    required this.contest,
    required this.categoryName,
    required this.likeCount,
    required this.shareCount,
    required this.followCount,
    required this.applicantCount,
    required this.contestSettings,
  });

  final String? id;
  final String? contestId;
  final String? userId;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? state;
  final String? address;
  final ApplicationData? applicationData;
  final String? status;
  final String? rejectionReason;
  final String? createdAt;
  final String? updatedAt;
  final Contest? contest;
  final String? categoryName;
  final int? likeCount;
  final int? shareCount;
  final int? followCount;
  final int? applicantCount;
  final ContestSettings? contestSettings;

  factory AppliedContestModel.fromJson(Map<String, dynamic> json) =>
      _$AppliedContestModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class ApplicationData {
  ApplicationData({
    required this.ggggggg,
    required this.fullName,
    required this.applicationDataPortfolio,
    required this.emailAddress,
    required this.phoneSpec,
    required this.portfolio,
  });

  final String? ggggggg;

  @JsonKey(name: 'Full Name')
  final String? fullName;
  final String? applicationDataPortfolio;

  @JsonKey(name: 'Email Address')
  final String? emailAddress;

  @JsonKey(name: 'Phone spec')
  final String? phoneSpec;

  @JsonKey(name: 'Portfolio')
  final String? portfolio;

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
    required this.winnerPrize,
    required this.publicity,
    required this.overallResult,
    required this.amountPerVote,
    required this.uploadCoverImages,
    required this.howItWorks,
    required this.entryType,
    required this.amount,
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
  });

  final String? id;
  final String? profileId;
  final String? hostId;
  final String? title;
  final String? category;
  final String? state;
  final String? description;
  final String? winnerPrize;
  final String? publicity;
  final String? overallResult;
  final int? amountPerVote;
  final String? uploadCoverImages;
  final String? howItWorks;
  final String? entryType;
  final int? amount;
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

  factory Contest.fromJson(Map<String, dynamic> json) =>
      _$ContestFromJson(json);
}

@JsonSerializable(createToJson: false)
class ContestSettings {
  ContestSettings({
    required this.id,
    required this.stages,
    required this.formRequirements,
    required this.contestId,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final String? id;
  final List<Stage>? stages;
  final List<FormRequirement>? formRequirements;
  final String? contestId;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  factory ContestSettings.fromJson(Map<String, dynamic> json) =>
      _$ContestSettingsFromJson(json);
}

@JsonSerializable(createToJson: false)
class FormRequirement {
  FormRequirement({
    required this.requirementType,
    required this.requirementName,
    required this.textDescription,
    required this.isRequired,
  });

  final String? requirementType;
  final String? requirementName;
  final String? textDescription;
  @JsonKey(name: 'required')
  final bool? isRequired;

  factory FormRequirement.fromJson(Map<String, dynamic> json) =>
      _$FormRequirementFromJson(json);
}

@JsonSerializable(createToJson: false)
class Stage {
  Stage({
    required this.stageName,
    required this.entryType,
    required this.entryAmount,
    required this.voteCountToQualify,
    required this.numberOfPostPerWeek,
    required this.priceOfTheWinner,
    required this.startDate,
    required this.isActive,
    required this.endDate,
    required this.approveBeforeLive,
  });

  final String? stageName;
  final String? entryType;
  final dynamic entryAmount;
  final dynamic voteCountToQualify;
  final dynamic numberOfPostPerWeek;
  final int? priceOfTheWinner;
  final bool? isActive;
  final String? startDate;
  final String? endDate;
  final bool? approveBeforeLive;

  factory Stage.fromJson(Map<String, dynamic> json) => _$StageFromJson(json);
}

post.Contest mergeContest(AppliedContestModel model) {
  return post.Contest(
      id: model.contest?.id,
      profileId: model.contest?.profileId,
      hostId: model.contest?.hostId,
      title: model.contest?.title,
      category: model.contest?.category,
      state: model.state ?? model.contest?.state,
      description: model.contest?.description,
      // voteCountToQualify:
      winnerPrize: model.contest?.winnerPrize,
      publicity: model.contest?.publicity,
      overallResult: model.contest?.overallResult,
      categoryName: model.categoryName,
      amountPerVote: model.contest?.amountPerVote,
      uploadCoverImages: model.contest?.uploadCoverImages,
      howItWorks: model.contest?.howItWorks,
      entryType: model.contest?.entryType,
      amount: model.contest?.amount,
      likeCount: 0,
      hasLiked: false,
      isFollowing: false,
      shareCount: 0,
      followCount: 0,
      applicantCount: 0,
     // numberOfDuration: model.contest?.numberOfDuration,
      participationStartDate: model.contest?.participationStartDate,
      descriptionOfAwards: model.contest?.descriptionOfAwards,
      startDate: model.contest?.startDate,
      endDate: model.contest?.endDate,
      multipleStages: model.contest?.multipleStages,
      currentStage: model.contest?.currentStage,
      contestStatus: model.contest?.contestStatus,
      rejectedReason: model.contest?.rejectedReason,
      status: model.contest?.status,
      isDeleted: model.contest?.isDeleted,
      createdAt: model.contest?.createdAt,
      updatedAt: model.contest?.updatedAt,
      deletedAt: model.contest?.deletedAt,
      contestSettings: post.ContestSettings(
        id: model.contestSettings?.id,
        deletedAt: "",
        stages: model.contestSettings?.stages
            ?.map((e) => post.Stage(
                  stageName: e.stageName,
                  entryType: e.entryType,
                  entryAmount: e.entryAmount,
                  voteCountToQualify: e.voteCountToQualify,
                  numberOfPostPerWeek: e.numberOfPostPerWeek,
                  priceOfTheWinner: e.priceOfTheWinner,
                  startDate: e.startDate,
                  
                  isActive: e.isActive,
                  endDate: e.endDate,
                  approveBeforeLive: e.approveBeforeLive,
                ))
            .toList(),
        formRequirements: model.contestSettings?.formRequirements
            ?.map((e) => post.FormRequirement(
                  requirementType: e.requirementType,
                  requirementName: e.requirementName,
                  textDescription: e.textDescription,
                  required: e.isRequired,
                ))
            .toList(),
        contestId: model.contestSettings?.contestId,
        isDeleted: model.contestSettings?.isDeleted,
        createdAt: model.contestSettings?.createdAt,
        updatedAt: model.contestSettings?.updatedAt,
        // deletedAt: model.contestSettings!.deletedAt,
      ));
}

import 'package:json_annotation/json_annotation.dart';

part 'ugt_post_model.g.dart';

@JsonSerializable()
class ContestResponse {
  ContestResponse({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final Data? data;

  ContestResponse copyWith({
    String? message,
    bool? status,
    int? statusCode,
    Data? data,
  }) {
    return ContestResponse(
      message: message ?? this.message,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
    );
  }

  factory ContestResponse.fromJson(Map<String, dynamic> json) =>
      _$ContestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ContestResponseToJson(this);
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
  });

  final List<Contest>? docs;
  final int? totalDocs;
  final int? limit;
  final int? page;
  final int? totalPages;
  final bool? hasNextPage;
  final dynamic nextPage;
  final bool? hasPrevPage;
  final dynamic prevPage;
  final int? pagingCounter;

  Data copyWith({
    List<Contest>? docs,
    int? totalDocs,
    int? limit,
    int? page,
    int? totalPages,
    bool? hasNextPage,
    dynamic nextPage,
    bool? hasPrevPage,
    dynamic prevPage,
    int? pagingCounter,
  }) {
    return Data(
      docs: docs ?? this.docs,
      totalDocs: totalDocs ?? this.totalDocs,
      limit: limit ?? this.limit,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      nextPage: nextPage ?? this.nextPage,
      hasPrevPage: hasPrevPage ?? this.hasPrevPage,
      prevPage: prevPage ?? this.prevPage,
      pagingCounter: pagingCounter ?? this.pagingCounter,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
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
    required this.participationStartDate,
    required this.participationEndDate,
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
    required this.categoryName,
    required this.likeCount,
    required this.hasLiked,
    required this.isFollowing,
    required this.hasApplied,
    required this.shareCount,
    required this.followCount,
    required this.applicantCount,
    required this.contestSettings,
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
  final String? participationStartDate;
  final String? participationEndDate;
  final String? descriptionOfAwards;
  final String? startDate;
  final String? endDate;
  final String? multipleStages;
  final String? currentStage;
  final String? contestStatus;
  final dynamic rejectedReason;
  final String? status;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;
  final String? categoryName;
  final int? likeCount;
  final bool? hasLiked;
  final bool? isFollowing;
  final bool? hasApplied;
  final int? shareCount;
  final int? followCount;
  final int? applicantCount;
  final ContestSettings? contestSettings;

  Contest copyWith({
    String? id,
    String? profileId,
    String? hostId,
    String? title,
    String? category,
    String? state,
    String? description,
    String? winnerPrize,
    String? publicity,
    String? overallResult,
    int? amountPerVote,
    String? uploadCoverImages,
    String? howItWorks,
    String? entryType,
    int? amount,
    String? participationStartDate,
    String? participationEndDate,
    String? descriptionOfAwards,
    String? startDate,
    String? endDate,
    String? multipleStages,
    String? currentStage,
    String? contestStatus,
    dynamic rejectedReason,
    String? status,
    bool? isDeleted,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    String? categoryName,
    int? likeCount,
    bool? hasLiked,
    bool? isFollowing,
    bool? hostApproved,
    int? shareCount,
    int? followCount,
    int? applicantCount,
    ContestSettings? contestSettings,
  }) {
    return Contest(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      hostId: hostId ?? this.hostId,
      title: title ?? this.title,
      category: category ?? this.category,
      state: state ?? this.state,
      description: description ?? this.description,
      winnerPrize: winnerPrize ?? this.winnerPrize,
      publicity: publicity ?? this.publicity,
      overallResult: overallResult ?? this.overallResult,
      amountPerVote: amountPerVote ?? this.amountPerVote,
      uploadCoverImages: uploadCoverImages ?? this.uploadCoverImages,
      howItWorks: howItWorks ?? this.howItWorks,
      entryType: entryType ?? this.entryType,
      amount: amount ?? this.amount,
      participationStartDate:participationStartDate ?? this.participationStartDate,
      participationEndDate:participationEndDate ?? this.participationEndDate,
      descriptionOfAwards: descriptionOfAwards ?? this.descriptionOfAwards,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      multipleStages: multipleStages ?? this.multipleStages,
      currentStage: currentStage ?? this.currentStage,
      contestStatus: contestStatus ?? this.contestStatus,
      rejectedReason: rejectedReason ?? this.rejectedReason,
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      categoryName: categoryName ?? this.categoryName,
      likeCount: likeCount ?? this.likeCount,
      hasLiked: hasLiked ?? this.hasLiked,
      isFollowing: isFollowing ?? this.isFollowing,
      hasApplied: hasApplied ?? hasApplied,
      shareCount: shareCount ?? this.shareCount,
      followCount: followCount ?? this.followCount,
      applicantCount: applicantCount ?? this.applicantCount,
      contestSettings: contestSettings ?? this.contestSettings,
    );
  }

  factory Contest.fromJson(Map<String, dynamic> json) =>
      _$ContestFromJson(json);

  Map<String, dynamic> toJson() => _$ContestToJson(this);
}

@JsonSerializable()
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
  final dynamic deletedAt;

  ContestSettings copyWith({
    String? id,
    List<Stage>? stages,
    List<FormRequirement>? formRequirements,
    String? contestId,
    bool? isDeleted,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
  }) {
    return ContestSettings(
      id: id ?? this.id,
      stages: stages ?? this.stages,
      formRequirements: formRequirements ?? this.formRequirements,
      contestId: contestId ?? this.contestId,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory ContestSettings.fromJson(Map<String, dynamic> json) =>
      _$ContestSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$ContestSettingsToJson(this);
}

@JsonSerializable()
class FormRequirement {
  FormRequirement({
    required this.requirementType,
    required this.requirementName,
    required this.textDescription,
    required this.required,
  });

  final String? requirementType;
  final String? requirementName;
  final String? textDescription;
  final bool? required;

  FormRequirement copyWith({
    String? requirementType,
    String? requirementName,
    String? textDescription,
    bool? required,
  }) {
    return FormRequirement(
      requirementType: requirementType ?? this.requirementType,
      requirementName: requirementName ?? this.requirementName,
      textDescription: textDescription ?? this.textDescription,
      required: required ?? this.required,
    );
  }

  factory FormRequirement.fromJson(Map<String, dynamic> json) =>
      _$FormRequirementFromJson(json);

  Map<String, dynamic> toJson() => _$FormRequirementToJson(this);
}

@JsonSerializable()
class Stage {
  Stage({
    required this.stageName,
    required this.entryType,
    required this.entryAmount,
    required this.numberOfPostPerWeek,
    required this.priceOfTheWinner,
    required this.startDate,
    required this.endDate,
    required this.approveBeforeLive,
    required this.isActive,
    required this.voteCountToQualify,
  });

  final String? stageName;
  final String? entryType;
  final dynamic entryAmount;
  final dynamic numberOfPostPerWeek;
  final int? priceOfTheWinner;
  final String? startDate;
  final String? endDate;
  final bool? approveBeforeLive;
  bool? isActive;
  final dynamic voteCountToQualify;

  Stage copyWith({
    String? stageName,
    String? entryType,
    dynamic entryAmount,
    dynamic numberOfPostPerWeek,
    int? priceOfTheWinner,
    String? startDate,
    String? endDate,
    bool? approveBeforeLive,
    bool? isActive,
    dynamic voteCountToQualify,
  }) {
    return Stage(
      stageName: stageName ?? this.stageName,
      entryType: entryType ?? this.entryType,
      entryAmount: entryAmount ?? this.entryAmount,
      numberOfPostPerWeek: numberOfPostPerWeek ?? this.numberOfPostPerWeek,
      priceOfTheWinner: priceOfTheWinner ?? this.priceOfTheWinner,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      approveBeforeLive: approveBeforeLive ?? this.approveBeforeLive,
      isActive: isActive ?? this.isActive,
      voteCountToQualify: voteCountToQualify ?? this.voteCountToQualify,
    );
  }

  factory Stage.fromJson(Map<String, dynamic> json) => _$StageFromJson(json);

  Map<String, dynamic> toJson() => _$StageToJson(this);
}

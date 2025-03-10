import 'package:json_annotation/json_annotation.dart';

part 'contest_contestant_model.g.dart';

@JsonSerializable()
class ContestContestantModelMean {
  ContestContestantModelMean({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final List<MyContestContestantModel>? data;

  ContestContestantModelMean copyWith({
    String? message,
    bool? status,
    int? statusCode,
    List<MyContestContestantModel>? data,
  }) {
    return ContestContestantModelMean(
      message: message ?? this.message,
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
    );
  }

  factory ContestContestantModelMean.fromJson(Map<String, dynamic> json) =>
      _$ContestContestantModelMeanFromJson(json);

  Map<String, dynamic> toJson() => _$ContestContestantModelMeanToJson(this);
}

@JsonSerializable()
class MyContestContestantModel {
  MyContestContestantModel({
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
  final List<Stage>? stages;
  final String? createdAt;
  final String? updatedAt;
  final ContestApplicant? contestApplicant;
  final int? votes;

  MyContestContestantModel copyWith({
    String? id,
    String? profileId,
    String? contestApplicationId,
    String? contestId,
    String? profilePhoto,
    String? bio,
    String? expectationFromVoters,
    String? introVideo,
    bool? hasPaid,
    String? status,
    List<Stage>? stages,
    String? createdAt,
    String? updatedAt,
    ContestApplicant? contestApplicant,
    int? votes,
  }) {
    return MyContestContestantModel(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      contestApplicationId: contestApplicationId ?? this.contestApplicationId,
      contestId: contestId ?? this.contestId,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      bio: bio ?? this.bio,
      expectationFromVoters:
          expectationFromVoters ?? this.expectationFromVoters,
      introVideo: introVideo ?? this.introVideo,
      hasPaid: hasPaid ?? this.hasPaid,
      status: status ?? this.status,
      stages: stages ?? this.stages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contestApplicant: contestApplicant ?? this.contestApplicant,
      votes: votes ?? this.votes,
    );
  }

  factory MyContestContestantModel.fromJson(Map<String, dynamic> json) =>
      _$MyContestContestantModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyContestContestantModelToJson(this);
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
  final String? state;
  final String? address;
  final Map<String, dynamic>? applicationData;
  final String? status;
  final String? rejectionReason;
  final String? createdAt;
  final String? updatedAt;

  ContestApplicant copyWith({
    String? id,
    String? contestId,
    String? userId,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? state,
    String? address,
    Map<String, dynamic>? applicationData,
    String? status,
    String? rejectionReason,
    String? createdAt,
    String? updatedAt,
  }) {
    return ContestApplicant(
      id: id ?? this.id,
      contestId: contestId ?? this.contestId,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      state: state ?? this.state,
      address: address ?? this.address,
      applicationData: applicationData ?? this.applicationData,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ContestApplicant.fromJson(Map<String, dynamic> json) =>
      _$ContestApplicantFromJson(json);

  Map<String, dynamic> toJson() => _$ContestApplicantToJson(this);
}

/* @JsonSerializable()
class ApplicationData {
  ApplicationData({
    required this.ggggggg,
  });

  final String? ggggggg;

  ApplicationData copyWith({
    String? ggggggg,
  }) {
    return ApplicationData(
      ggggggg: ggggggg ?? this.ggggggg,
    );
  }

  factory ApplicationData.fromJson(Map<String, dynamic> json) =>
      _$ApplicationDataFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationDataToJson(this);
} */

@JsonSerializable()
class Stage {
  Stage({
    required this.stageName,
    required this.entryType,
    required this.entryAmount,
    required this.voteCountToQualify,
    required this.numberOfPostPerWeek,
    required this.priceOfTheWinner,
    required this.startDate,
    required this.endDate,
    required this.approveBeforeLive,
    required this.isActive,
    required this.hasPaid,
    required this.hasAccepted,
    required this.noOfVotes,
    required this.amountEarned,
    required this.position,
  });

  final String? stageName;
  final String? entryType;
  final int? entryAmount;
  final int? voteCountToQualify;
  final int? numberOfPostPerWeek;
  final int? priceOfTheWinner;
  final String? startDate;
  final String? endDate;
  final bool? approveBeforeLive;
  final bool? isActive;
  final bool? hasPaid;
  final bool? hasAccepted;
  final int? noOfVotes;
  final int? amountEarned;
  final int? position;

  Stage copyWith({
    String? stageName,
    String? entryType,
    int? entryAmount,
    int? voteCountToQualify,
    int? numberOfPostPerWeek,
    int? priceOfTheWinner,
    String? startDate,
    String? endDate,
    bool? approveBeforeLive,
    bool? isActive,
    bool? hasPaid,
    bool? hasAccepted,
    int? noOfVotes,
    int? amountEarned,
    int? position,
  }) {
    return Stage(
      stageName: stageName ?? this.stageName,
      entryType: entryType ?? this.entryType,
      entryAmount: entryAmount ?? this.entryAmount,
      voteCountToQualify: voteCountToQualify ?? this.voteCountToQualify,
      numberOfPostPerWeek: numberOfPostPerWeek ?? this.numberOfPostPerWeek,
      priceOfTheWinner: priceOfTheWinner ?? this.priceOfTheWinner,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      hasAccepted: hasAccepted ?? this.hasAccepted,
      approveBeforeLive: approveBeforeLive ?? this.approveBeforeLive,
      isActive: isActive ?? this.isActive,
      hasPaid: hasPaid ?? this.hasPaid,
      noOfVotes: noOfVotes ?? this.noOfVotes,
      amountEarned: amountEarned ?? this.amountEarned,
      position: position ?? this.position,
    );
  }

  factory Stage.fromJson(Map<String, dynamic> json) => _$StageFromJson(json);

  Map<String, dynamic> toJson() => _$StageToJson(this);
}

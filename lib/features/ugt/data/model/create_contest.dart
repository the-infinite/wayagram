import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';


part 'create_contest.g.dart';



@JsonSerializable()
class CreateContestModel {
  String title;
  String profileId;
  String category;
  String state;
  String winnerPrize;
  String description;
  String voteCountToQualify;
  String amount;
  String durationType;
  String numberOfDuration;
  String descriptionOfAwards;
  String amountPerVote;
  String type;
  String overallResult;
  String multipleStages;
  String publicity;
  String status;
  String howItWorks;
  String numberOfWeeks;
  String currentStage;
  String participationStartDate;
  String startDate;
  String endDate;
  String entryType;
  ContestSettings contestSettings;

  CreateContestModel({
    required this.title,
    required this.profileId,
    required this.category,
    required this.state,
    required this.winnerPrize,
    required this.description,
    required this.voteCountToQualify,
    required this.amount,
    required this.durationType,
    required this.numberOfDuration,
    required this.descriptionOfAwards,
    required this.amountPerVote,
    required this.type,
    required this.overallResult,
    required this.multipleStages,
    required this.publicity,
    required this.status,
    required this.howItWorks,
    required this.numberOfWeeks,
    required this.currentStage,
    required this.participationStartDate,
    required this.startDate,
    required this.endDate,
    required this.entryType,
    required this.contestSettings,
  });

   factory CreateContestModel.fromJson(Map<String, dynamic> json) => _$CreateContestModelFromJson(json);
   Map<String, dynamic> toJson() => _$CreateContestModelToJson(this);
}

@JsonSerializable()
class ContestSettings {
  List<dynamic> stages;
  List<dynamic> formRequirements;

  ContestSettings({
    required this.stages,
    required this.formRequirements,
  });

   factory ContestSettings.fromJson(Map<String, dynamic> json) => _$ContestSettingsFromJson(json);
   Map<String, dynamic> toJson() => _$ContestSettingsToJson(this);
}

@JsonSerializable()
class Stage {
  String stageName;
  String entryType;
  int entryAmount;
  int numberOfPostPerWeek;
  int priceOfTheWinner;
  DateTime startDate;
  DateTime endDate;
  bool approveBeforeLive;

  Stage({
    required this.stageName,
    required this.entryType,
    required this.entryAmount,
    required this.numberOfPostPerWeek,
    required this.priceOfTheWinner,
    required this.startDate,
    required this.endDate,
    required this.approveBeforeLive,
  });

   factory Stage.fromJson(Map<String, dynamic> json) => _$StageFromJson(json);
   Map<String, dynamic> toJson() => _$StageToJson(this);
}

@JsonSerializable()
class FormRequirement {
  String requirementType;
  String requirementName;
  String textDescription;
  bool required;

  FormRequirement({
    required this.requirementType,
    required this.requirementName,
    required this.textDescription,
    required this.required,
  });


  factory FormRequirement.fromJson(Map<String, dynamic> json) => _$FormRequirementFromJson(json);
  Map<String, dynamic> toJson() => _$FormRequirementToJson(this);
}


extension CreateContestModelCopyWith on CreateContestModel {
  CreateContestModel copyWith({
    String? title,
    String? profileId,
    String? category,
    String? state,
    String? winnerPrize,
    String? description,
    String? voteCountToQualify,
    String? amount,
    String? durationType,
    String? numberOfDuration,
    String? descriptionOfAwards,
    String? amountPerVote,
    String? type,
    String? overallResult,
    String? multipleStages,
    String? publicity,
    String? status,
    String? howItWorks,
    String? numberOfWeeks,
    String? currentStage,
    String? participationStartDate,
    String? startDate,
    String? endDate,
    String? entryType,
    ContestSettings? contestSettings,
  }) {
    return CreateContestModel(
      title: title ?? this.title,
      profileId: profileId ?? this.profileId,
      category: category ?? this.category,
      state: state ?? this.state,
      winnerPrize: winnerPrize ?? this.winnerPrize,
      description: description ?? this.description,
      voteCountToQualify: voteCountToQualify ?? this.voteCountToQualify,
      amount: amount ?? this.amount,
      durationType: durationType ?? this.durationType,
      numberOfDuration: numberOfDuration ?? this.numberOfDuration,
      descriptionOfAwards: descriptionOfAwards ?? this.descriptionOfAwards,
      amountPerVote: amountPerVote ?? this.amountPerVote,
      type: type ?? this.type,
      overallResult: overallResult ?? this.overallResult,
      multipleStages: multipleStages ?? this.multipleStages,
      publicity: publicity ?? this.publicity,
      status: status ?? this.status,
      howItWorks: howItWorks ?? this.howItWorks,
      numberOfWeeks: numberOfWeeks ?? this.numberOfWeeks,
      currentStage: currentStage ?? this.currentStage,
      participationStartDate: participationStartDate ??
          this.participationStartDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      entryType: entryType ?? this.entryType,
      contestSettings: contestSettings ?? this.contestSettings,
    );
  }

 /* CreateContestModel get addContestModel {
    return CreateContestModel(title: title,
        profileId: profileId,
        category: category,
        state: state,
        winnerPrize: winnerPrize,
        description: description,
        voteCountToQualify: voteCountToQualify,
        amount: amount,
        durationType: durationType,
        numberOfDuration: numberOfDuration,
        descriptionOfAwards: descriptionOfAwards,
        amountPerVote: amountPerVote,
        type: type,
        overallResult: overallResult,
        multipleStages: multipleStages,
        publicity: publicity,
        status: status,
        howItWorks: howItWorks,
        numberOfWeeks: numberOfWeeks,
        currentStage: currentStage,
        participationStartDate: participationStartDate,
        startDate: startDate,
        endDate: endDate,
        entryType: entryType,
        contestSettings: contestSettings);
  }*/


}







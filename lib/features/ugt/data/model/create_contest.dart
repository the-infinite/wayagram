
import 'package:json_annotation/json_annotation.dart';
//part 'create_contest.g.dart';

@JsonSerializable()
class CreateContestModel {
  String title;
  String profileId;
  String category;
  String state;
  String winnerPrize;
  String description;
  String voteCountToQualify;
  int amount;
  String durationType;
  String numberOfDuration;
  String descriptionOfAwards;
  int amountPerVote;
  String type;
  String overallResult;
  String multipleStages;
  String publicity;
  String status;
  String howItWorks;
  String numberOfWeeks;
  String currentStage;
  DateTime participationStartDate;
  DateTime startDate;
  DateTime endDate;
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

  // factory CreateContestModel.fromJson(Map<String, dynamic> json) => _$CreateContestModelFromJson(json);
  // Map<String, dynamic> toJson() => _$CreateContestModelToJson(this);
}

@JsonSerializable()
class ContestSettings {
  List<Stage> stages;
  List<FormRequirement> formRequirements;

  ContestSettings({
    required this.stages,
    required this.formRequirements,
  });

  // factory ContestSettings.fromJson(Map<String, dynamic> json) => _$ContestSettingsFromJson(json);
  // Map<String, dynamic> toJson() => _$ContestSettingsToJson(this);
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

  // factory Stage.fromJson(Map<String, dynamic> json) => _$StageFromJson(json);
  // Map<String, dynamic> toJson() => _$StageToJson(this);
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



  // factory FormRequirement.fromJson(Map<String, dynamic> json) => _$FormRequirementFromJson(json);
  // Map<String, dynamic> toJson() => _$FormRequirementToJson(this);
}
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:wayagram/core/data/model/stage_pref_model.dart';
import '/core/data/model/model.dart';
import 'create_contest.dart';

class ContestState {
  final TextEditingController title;
  final TextEditingController contestStatus;
  final TextEditingController winnerPrize;
  final TextEditingController description;
  final TextEditingController voteCountToQualify;
  final TextEditingController durationType;
  final TextEditingController numberOfDuration;
  final TextEditingController descriptionOfAwards;
  final TextEditingController amountPerVote;
  final TextEditingController amount;
  final TextEditingController multipleStages;
  final TextEditingController publicity;
  final TextEditingController status;
  final TextEditingController howItWorks;
  final TextEditingController numberOfWeeks;
  final TextEditingController currentStage;
  final TextEditingController participationStartDate;
  final TextEditingController entryType;
  final List<Map<String, dynamic>> stages;
  final List<Map<String, dynamic>> formRequirements;
  final List<Select> category;
  final TextEditingController stageName;
  final TextEditingController entryAmount;
  final TextEditingController numberOfPostPerWeek;
  /*final TextEditingController fullName;
  final TextEditingController email;
  final TextEditingController phone;
  final TextEditingController address;*/
  final TextEditingController requirementName;
  final TextEditingController requirementText;
  final String requirementType;
  final bool isLoading;
  final String startDate;
  final String endDate;
  final String endDateIsoFormat;
  final String dateIsoFormat;
  final bool overallResult;
  final String contestPrivatePublic;
  final String contestFreePaid;
  final String profileId;
  final String categorys;
  final String categoryId;
  final String image;
  final String state;
  final String type;
  final Select? selectedCategory;
  bool approveBeforeLive;

  //Participation Details
  final String entrySelectType;
  final String durationSelectType;
  // Contest timeline
  final String contestTimelineStartDate;
  final String contestTimelineEndDate;
  final String contestTimelineMultipleStage;
  final String contestTimelineCurrentStage;
  //Edit Stage Preference
  final List<StagePrefModel>? stagePrefModels;
  final StagePrefModel? stagePrefModel;

  ContestState({
    TextEditingController? title,
    TextEditingController? contestStatus,
    TextEditingController? winnerPrize,
    TextEditingController? description,
    TextEditingController? voteCountToQualify,
    TextEditingController? durationType,
    TextEditingController? numberOfDuration,
    TextEditingController? descriptionOfAwards,
    TextEditingController? amountPerVote,
    TextEditingController? amount,
    TextEditingController? multipleStages,
    TextEditingController? publicity,
    TextEditingController? status,
    TextEditingController? howItWorks,
    TextEditingController? numberOfWeeks,
    TextEditingController? currentStage,
    TextEditingController? participationStartDate,
    TextEditingController? entryType,
    TextEditingController? stageName,
    TextEditingController? entryAmount,
    TextEditingController? numberOfPostPerWeek,
    TextEditingController? requirementName,
    TextEditingController? requirementText,
    this.profileId = '',
    this.categorys = '',
    this.categoryId = '',
    this.formRequirements = const [],
    this.stages = const [],
    this.category = const [],
    this.isLoading = false,
    this.state = '',
    this.image = '',
    this.endDate = '',
    this.entrySelectType = 'Free',
    this.durationSelectType = '',
    this.contestTimelineStartDate = '',
    this.contestTimelineEndDate = '',
    this.contestTimelineCurrentStage = '',
    this.contestTimelineMultipleStage = '',
    this.requirementType = '',
    this.dateIsoFormat = '',
    this.startDate = '',
    this.selectedCategory,
    this.endDateIsoFormat = '',
    this.overallResult = false,
    this.contestPrivatePublic = 'PRIVATE',
    this.contestFreePaid = 'Paid',
    this.type = 'Paid',
    this.stagePrefModels,
    this.stagePrefModel,
    this.approveBeforeLive = false,
  })  : title = title ?? TextEditingController(),
        winnerPrize = winnerPrize ?? TextEditingController(),
        description = description ?? TextEditingController(),
        voteCountToQualify = voteCountToQualify ?? TextEditingController(),
        durationType = durationType ?? TextEditingController(),
        numberOfDuration = numberOfDuration ?? TextEditingController(),
        descriptionOfAwards = descriptionOfAwards ?? TextEditingController(),
        stageName = stageName ?? TextEditingController(),
        entryAmount = entryAmount ?? TextEditingController(),
        numberOfPostPerWeek = numberOfPostPerWeek ?? TextEditingController(),
        multipleStages = multipleStages ?? TextEditingController(),
        publicity = publicity ?? TextEditingController(),
        status = status ?? TextEditingController(),
        amount = amount ?? TextEditingController(),
        requirementText = requirementText ?? TextEditingController(),
        requirementName = requirementName ?? TextEditingController(),
        contestStatus = contestStatus ?? TextEditingController(),
        amountPerVote = amountPerVote ?? TextEditingController(),
        howItWorks = howItWorks ?? TextEditingController(),
        numberOfWeeks = numberOfWeeks ?? TextEditingController(),
        currentStage = currentStage ?? TextEditingController(),
        participationStartDate =
            participationStartDate ?? TextEditingController(),
        entryType = entryType ?? TextEditingController();

  ContestState copyWith({
    TextEditingController? title,
    TextEditingController? contestStatus,
    TextEditingController? winnerPrize,
    TextEditingController? description,
    TextEditingController? voteCountToQualify,
    TextEditingController? durationType,
    TextEditingController? numberOfDuration,
    TextEditingController? descriptionOfAwards,
    TextEditingController? amountPerVote,
    TextEditingController? amount,
    TextEditingController? multipleStages,
    TextEditingController? publicity,
    TextEditingController? status,
    TextEditingController? howItWorks,
    TextEditingController? numberOfWeeks,
    TextEditingController? currentStage,
    TextEditingController? participationStartDate,
    TextEditingController? stageName,
    TextEditingController? entryAmount,
    TextEditingController? numberOfPostPerWeek,
    TextEditingController? requirementName,
    TextEditingController? requirementText,
    TextEditingController? entryType,
    List<Map<String, dynamic>>? stages,
    List<Map<String, dynamic>>? formRequirements,
    List<Select>? category,
    String? categorys,
    String? categoryId,
    String? image,
    String? profileId,
    String? type,
    bool? approveBeforeLive,
    String? state,
    String? endDate,
    String? requirementType,
    String? startDate,
    bool? overallResult,
    String? contestPrivatePublic,
    String? contestFreePaid,
    String? dateIsoFormat,
    String? endDateIsoFormat,
    List<Select>? categories,
    bool? isLoading,
    List<Select>? states,
    bool? isFocused,
    Select? selectedCategory,
    //participation details
    String? entrySelectType,
    String? durationSelectType,
    // Contest timeline
    String? contestTimelineStartDate,
    String? contestTimelineEndDate,
    String? contestTimelineMultipleStage,
    String? contestTimelineCurrentStage,
    // Edit Stage Pref
    List<StagePrefModel>? stagePrefModels,
    StagePrefModel? stagePrefModel,
  }) {
    return ContestState(
      title: title ?? this.title,
      amount: amount ?? this.amount,
      amountPerVote: amountPerVote ?? this.amountPerVote,
      category: category ?? this.category,
      contestStatus: contestStatus ?? this.contestStatus,
      currentStage: currentStage ?? this.currentStage,
      description: description ?? this.description,
      descriptionOfAwards: descriptionOfAwards ?? this.descriptionOfAwards,
      durationType: durationType ?? this.durationType,
      endDate: endDate ?? this.endDate,
      entryType: entryType ?? this.entryType,
      howItWorks: howItWorks ?? this.howItWorks,
      isLoading: isLoading ?? this.isLoading,
      multipleStages: multipleStages ?? this.multipleStages,
      numberOfDuration: numberOfDuration ?? this.numberOfDuration,
      numberOfWeeks: numberOfWeeks ?? this.numberOfWeeks,
      /* 
       bool? overallResult,
    bool? contestPrivatePublic,
    bool? contestFreePaid,
       */
      overallResult: overallResult ?? this.overallResult,
      contestPrivatePublic: contestPrivatePublic ?? this.contestPrivatePublic,
      contestFreePaid: contestFreePaid ?? this.contestFreePaid,
      participationStartDate:
          participationStartDate ?? this.participationStartDate,
      profileId: profileId ?? this.profileId,
      categorys: categorys ?? this.categorys,
      categoryId: categoryId ?? this.categoryId,
      image: image ?? this.image,
      stagePrefModels: stagePrefModels ?? stagePrefModels,
      stagePrefModel: stagePrefModel ?? this.stagePrefModel,
      contestTimelineStartDate:
          contestTimelineStartDate ?? this.contestTimelineStartDate,
      contestTimelineEndDate:
          contestTimelineEndDate ?? this.contestTimelineEndDate,
      contestTimelineMultipleStage:
          contestTimelineMultipleStage ?? this.contestTimelineMultipleStage,
      contestTimelineCurrentStage:
          contestTimelineCurrentStage ?? this.contestTimelineCurrentStage,
      entrySelectType: entrySelectType ?? this.entrySelectType,
      durationSelectType: durationSelectType ?? this.durationSelectType,
      publicity: publicity ?? this.publicity,
      stages: stages ?? this.stages,
      dateIsoFormat: dateIsoFormat ?? this.dateIsoFormat,
      endDateIsoFormat: endDateIsoFormat ?? this.endDateIsoFormat,
      startDate: startDate ?? this.startDate,
      status: status ?? this.status,
      state: state ?? this.state,
      numberOfPostPerWeek: numberOfDuration ?? this.numberOfPostPerWeek,
      stageName: stageName ?? this.stageName,
      entryAmount: entryAmount ?? this.entryAmount,
      requirementName: requirementName ?? this.requirementName,
      requirementText: requirementText ?? this.requirementText,
      requirementType: requirementType ?? this.requirementType,
      approveBeforeLive: approveBeforeLive ?? this.approveBeforeLive,
      type: type ?? this.type,
    );
  }

  CreateContestModel get addContestModel {
    return CreateContestModel(
      title: title.text,
      profileId: profileId,
      // categorys: categorys,
      category: category.toString(),
      winnerPrize: winnerPrize.text,
      description: description.toString(),
      voteCountToQualify: voteCountToQualify.text,
      amount: amount.text,
      durationType: durationType.text,
      numberOfDuration: numberOfDuration.text,
      descriptionOfAwards: descriptionOfAwards.text,
      amountPerVote: amountPerVote.text,
      type: type,
      overallResult: "",
      multipleStages: multipleStages.text,
      publicity: publicity.text,
      status: status.text,
      howItWorks: howItWorks.text,
      numberOfWeeks: numberOfWeeks.text,
      currentStage: currentStage.text,
      participationStartDate: participationStartDate.text,
      startDate: startDate,
      endDate: endDate,
      entryType: entryType.text,
      contestSettings:
          ContestSettings(stages: stages, formRequirements: formRequirements),
      state: state,
    );
  }
}

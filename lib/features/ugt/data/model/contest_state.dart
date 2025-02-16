import 'dart:io';

import 'package:flutter/cupertino.dart';
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
  final String overallResult;
  final String profileId;
  final String categorys;
  final String state;
  final String type;
  final Select? selectedCategory;
  bool approveBeforeLive;

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
    this.formRequirements = const [],
    this.stages = const [],
    this.category = const [],
    this.isLoading = false,
    this.state = '',
    this.endDate = '',
    this.requirementType = '',
    this.dateIsoFormat = '',
    this.startDate = '',
    this.selectedCategory,
    this.endDateIsoFormat = '',
    this.overallResult = '',
    this.type = 'Paid',
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
    String? profileId,
    String? type,
    bool? approveBeforeLive,
    String? state,
    String? endDate,
    String? requirementType,
    String? startDate,
    String? overallResult,
    String? dateIsoFormat,
    String? endDateIsoFormat,
    List<Select>? categories,
    bool? isLoading,
    List<Select>? states,
    bool? isFocused,
    Select? selectedCategory,
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
      overallResult: overallResult ?? this.overallResult,
      participationStartDate:
          participationStartDate ?? this.participationStartDate,
      profileId: profileId ?? this.profileId,
      categorys: categorys ?? this.categorys,
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
      overallResult: overallResult,
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

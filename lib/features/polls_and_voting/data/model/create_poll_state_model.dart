import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/polls_and_voting/data/model/cast_vote_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/get_my_poll.dart';
import 'package:wayagram/features/polls_and_voting/data/model/get_poll_model.dart';

import 'poll_dashboard_model.dart';

class CreatePollVotingState {
  final TextEditingController pollTitle;
  final TextEditingController pollDescription;
  final TextEditingController pollCompanyDescription;
  final TextEditingController votePrice;
  final TextEditingController voteNumber;
  final TextEditingController firstChoice;
  final TextEditingController secondChoice;
  final TextEditingController firstChoiceDescription;
  final TextEditingController secondChoiceDescription;
  final List<DocType> uploadedDocuments;
  final List<Choice> choices;

  final String startDate;
  final String endDate;
  final String pollType;
  File? candidateImage;
  final String dateIsoFormat;
  final bool isFocused;
  final bool isLoading;
  bool? isPersonalNotUpgradedToBusiness;
  List<GetPollData> getPollModel;
  List<PollData> getMyPollModel;
  List<Votes> pollDashboardModel;
  List<CastVoteData> castVoteModel;
  List<PollDashboardModel> dashboard;

  CreatePollVotingState({
    TextEditingController? pollTitle,
    TextEditingController? pollDescription,
    TextEditingController? pollCompanyDescription,
    TextEditingController? votePrice,
    TextEditingController? voteNumber,
    TextEditingController? firstChoice,
    TextEditingController? secondChoice,
    TextEditingController? firstChoiceDescription,
    TextEditingController? secondChoiceDescription,
    this.pollType = '',
    this.startDate = '',
    this.endDate = '',
    this.dateIsoFormat = '',
    this.isFocused = false,
    this.isLoading = false,
    this.candidateImage,
    this.choices =const [],
    this.getPollModel = const [],
    this.getMyPollModel = const [],
    this.pollDashboardModel = const [],
    this.castVoteModel = const [],
    this.dashboard = const [],
    this.uploadedDocuments = const [],
    this.isPersonalNotUpgradedToBusiness = false,
  })  : pollTitle = pollTitle ?? TextEditingController(),
        pollDescription = pollDescription ?? TextEditingController(),
        pollCompanyDescription =
            pollCompanyDescription ?? TextEditingController(),
        votePrice = votePrice ?? TextEditingController(),
        voteNumber = voteNumber ?? TextEditingController(),
        firstChoice = firstChoice ?? TextEditingController(),
        secondChoice = secondChoice ?? TextEditingController(),
        firstChoiceDescription =
            firstChoiceDescription ?? TextEditingController(),
        secondChoiceDescription =
            secondChoiceDescription ?? TextEditingController();

  CreatePollVotingState copyWith({
    TextEditingController? pollTitle,
    TextEditingController? pollDescription,
    TextEditingController? pollCompanyDescription,
    TextEditingController? votePrice,
    TextEditingController? voteNumber,
    TextEditingController? firstChoice,
    TextEditingController? secondChoice,
    TextEditingController? firstChoiceDescription,
    TextEditingController? secondChoiceDescription,
    List<DocType>? uploadedDocuments,
    String? startDate,
    String? endDate,
    String? pollType,
    File? candidateImage,
    String? dateIsoFormat,
    bool? isFocused,
    bool? isLoading,
    List<GetPollData>? getPollModel,
    List<PollData>? getMyPollModel,
    List<Votes>? pollDashboardModel,
    List<CastVoteData>? castVoteModel,
    List<PollDashboardModel>? dashboard,
    List<Choice>? choices
  }) {
    return CreatePollVotingState(
      isPersonalNotUpgradedToBusiness: isPersonalNotUpgradedToBusiness ?? this.isPersonalNotUpgradedToBusiness,
      pollTitle: pollTitle ?? this.pollTitle,
      pollDescription: pollDescription ?? this.pollDescription,
      pollCompanyDescription:
          pollCompanyDescription ?? this.pollCompanyDescription,
      votePrice: votePrice ?? this.votePrice,
      voteNumber: voteNumber ?? this.voteNumber,
      firstChoice: firstChoice ?? this.firstChoice,
      secondChoice: secondChoice ?? this.secondChoice,
      firstChoiceDescription:
          firstChoiceDescription ?? this.firstChoiceDescription,
      secondChoiceDescription:
          secondChoiceDescription ?? this.secondChoiceDescription,
      pollType: pollType ?? this.pollType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      candidateImage: candidateImage ?? this.candidateImage,
      dateIsoFormat: dateIsoFormat ?? this.dateIsoFormat,
      isFocused: isFocused ?? this.isFocused,
      isLoading: isLoading ?? this.isLoading,
      getPollModel: getPollModel ?? this.getPollModel,

      getMyPollModel : getMyPollModel ?? this.getMyPollModel,
      pollDashboardModel: pollDashboardModel ?? this.pollDashboardModel,
      castVoteModel: castVoteModel ?? this.castVoteModel,
      dashboard: dashboard ?? this.dashboard,

      uploadedDocuments: uploadedDocuments ?? this.uploadedDocuments,
      choices: choices ?? this.choices
    );
  }
}

class Choice {
  final TextEditingController text;
  final TextEditingController description;
  final File? image;

  Choice(
      {TextEditingController? text,
      TextEditingController? description,
      this.image})
      : text = text ?? TextEditingController(),
        description = description ?? TextEditingController();

  Choice copyWith(
      {TextEditingController? text,
      TextEditingController? description,
      File? image}) {
    return Choice(
        text: text ?? this.text,
        description: description ?? this.description,
        image: image ?? this.image);
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/polls_and_voting/data/model/cast_vote_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/fetch_all_polls.dart';
import 'package:wayagram/features/polls_and_voting/data/model/get_all_poll_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/get_my_poll.dart';
import 'package:wayagram/features/polls_and_voting/data/model/get_poll_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/poll_dashboard.dart';
import 'package:wayagram/features/polls_and_voting/data/model/single_dashboard_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/vote_url_model.dart';

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
  final List<SingleDashboardVotes>? votes;
  final List<Select> pollTypes;
  final VoteUrlData? voteUrlData;
  final List<PollDashboardModelDocs>? pollDashboardModelDocs;
  //final List<VoteUrlChoices> voteUrlChoices;


  final String moneyGenerated;
  final String voteCount;
  final String numberOfPeopleVoted;
  final String startDate;
  final String endDate;
  final String startDateString;
  final String endDateString;
  final String pollType;
  final String pollTypeId;
  File? candidateImage;
  final String dateIsoFormat;
  final bool isFocused;
  final bool isLoading;
  final bool isLoadingPollWithStatus;
  bool? isPersonalNotUpgradedToBusiness;
  List<Docs> fetchAllPols;
  List<GetPollData> getPollModel;
  List<GetAllPollData> getAllPollModel;
  List<PollData> getMyPollModel;
  List<CastVoteData> castVoteModel;

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
    this.voteCount = '',
    this.moneyGenerated ='',
    this.numberOfPeopleVoted  = '',
    this.pollType = '',
    this.startDate = '',
    this.endDate = '',
    this.startDateString = '',
    this.endDateString = '',
    this.dateIsoFormat = '',
    this.pollTypeId = '',
    this.isFocused = false,
    this.isLoading = false,
    this.isLoadingPollWithStatus = false,
    this.candidateImage,
    this.voteUrlData ,
    this.choices = const [],
    this.pollDashboardModelDocs = const [],
    //this.voteUrlChoices = const [],
    this.fetchAllPols =  const [],
    this.getPollModel = const [],
    this.getAllPollModel = const [],
    this.getMyPollModel = const [],
    this.votes = const [],
    this.castVoteModel = const [],
    this.pollTypes = const [],
    this.uploadedDocuments = const [],
    this.isPersonalNotUpgradedToBusiness = false,
  })  : pollTitle = pollTitle ?? TextEditingController(),
        pollDescription = pollDescription ?? TextEditingController(),
        pollCompanyDescription = pollCompanyDescription ?? TextEditingController(),
        votePrice = votePrice ?? TextEditingController(),
        voteNumber = voteNumber ?? TextEditingController(),
        firstChoice = firstChoice ?? TextEditingController(),
        secondChoice = secondChoice ?? TextEditingController(),
        firstChoiceDescription = firstChoiceDescription ?? TextEditingController(),
        secondChoiceDescription = secondChoiceDescription ?? TextEditingController();

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
    String? moneyGenerated,
    String? voteCount,
    String? numberOfPeopleVoted,
    String? startDate,
    String? startDateString,
    String? endDateString,
    String? dateIsoFormat,
    String? endDate,
    String? pollType,
    File? candidateImage,
    VoteUrlData? voteUrlData,
    String? pollTypeId,
    bool? isFocused,
    bool? isLoading,
    bool? isLoadingPollWithStatus,
    List<Docs>? fetchAllPols,
    List<GetPollData>? getPollModel,
    List<GetAllPollData>? getAllPollModel,
    List<PollDashboardModelDocs>? pollDashboardModelDocs,
    List<PollData>? getMyPollModel,
    List<SingleDashboardVotes>? votes,
    List<CastVoteData>? castVoteModel,
    List<Choice>? choices,
    List<Select>? pollTypes,
  }) {
    return CreatePollVotingState(
      isPersonalNotUpgradedToBusiness: isPersonalNotUpgradedToBusiness ?? this.isPersonalNotUpgradedToBusiness,
      pollTitle: pollTitle ?? this.pollTitle,
      pollDescription: pollDescription ?? this.pollDescription,
      pollCompanyDescription: pollCompanyDescription ?? this.pollCompanyDescription,
      votePrice: votePrice ?? this.votePrice,
      voteNumber: voteNumber ?? this.voteNumber,
      firstChoice: firstChoice ?? this.firstChoice,
      secondChoice: secondChoice ?? this.secondChoice,
      firstChoiceDescription: firstChoiceDescription ?? this.firstChoiceDescription,
      secondChoiceDescription: secondChoiceDescription ?? this.secondChoiceDescription,
      pollType: pollType ?? this.pollType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startDateString: startDateString ?? this.startDateString,
      endDateString: endDateString ?? this.endDateString,
      candidateImage: candidateImage ?? this.candidateImage,
      dateIsoFormat: dateIsoFormat ?? this.dateIsoFormat,
      isFocused: isFocused ?? this.isFocused,
      isLoading: isLoading ?? this.isLoading,
      isLoadingPollWithStatus: isLoadingPollWithStatus ?? this.isLoadingPollWithStatus,
      fetchAllPols: fetchAllPols  ?? this.fetchAllPols,
      getPollModel: getPollModel ?? this.getPollModel,
      getAllPollModel: getAllPollModel ?? this.getAllPollModel,
      getMyPollModel : getMyPollModel ?? this.getMyPollModel,
      pollDashboardModelDocs: pollDashboardModelDocs ?? this.pollDashboardModelDocs,
      votes: votes ?? this.votes,
        castVoteModel: castVoteModel ?? this.castVoteModel,
      uploadedDocuments: uploadedDocuments ?? this.uploadedDocuments,
      choices: choices ?? this.choices,
      voteUrlData: voteUrlData ?? this.voteUrlData,
      pollTypes: pollTypes ?? this.pollTypes,
      pollTypeId: pollTypeId ?? this.pollTypeId,
        voteCount: voteCount  ?? this.voteCount,
      numberOfPeopleVoted: numberOfPeopleVoted  ?? this.numberOfPeopleVoted,
      moneyGenerated: moneyGenerated ?? this.moneyGenerated,

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

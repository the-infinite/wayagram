import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/polls_and_voting/data/model/cast_vote_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/fetch_all_polls.dart';
import 'package:wayagram/features/polls_and_voting/data/model/get_all_payout_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/get_all_poll_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/get_my_poll.dart';
import 'package:wayagram/features/polls_and_voting/data/model/get_poll_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/poll_dashboard.dart';
import 'package:wayagram/features/polls_and_voting/data/model/single_dashboard_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/single_poll_model.dart';
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
  final List<PollPayoutDocs> pollPayoutDocs;
  final VoteUrlData? voteUrlData;
  final List<PollDashboardModelDocs> pollDashboardModelDocs;
  final List<PollDashboardChoices> pollDashboardChoices;
  List<SinglePollChoices> singlePollChoices;

  final String desc;
  final String fName;
  final String lName;
  final String question;
  final String picture;
  final String pollUrl;
  final String pollId;
  final String pollFee;
  final String? hoursLeft;

  final String totalAmount;
  final String kycStatus;
  final String wayaCommission;
  final String dueAmount;
  final String moneyGenerated;
  final String voteCount;
  final String? accountType;
  final String numberOfPeopleVoted;
  final String createdAt;
  final String startDate;
  final String endDate;
  final String startDateString;
  final String endDateString;
  final String pollType;
  final String pollTypeId;
  final String? commission;
  final String pollStatus;
  File? candidateImage;
  final String dateIsoFormat;
  final bool isFocused;
  final bool isLoading;
  final bool isLoadingPollWithStatus;
  bool? isPersonalNotUpgradedToBusiness;
  List<Docs> fetchAllPols;
  final List<Docs> feedPolls;
  List<GetPollData> getPollModel;
  List<GetAllPollData> getAllPollModel;
  List<PollData> getMyPollModel;
  List<CastVoteData> castVoteModel;
  List<Docs> activePolls;

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
    this.desc = '',
    this.fName = '',
    this.lName = '',
    this.picture = '',
    this.question = '',
    this.pollUrl = '',
    this.pollId = '',
    this.createdAt = '',
    this.hoursLeft = '',
    this.totalAmount = '',
    this.wayaCommission = '',
    this.dueAmount = '',
    this.voteCount = '',
    this.pollFee = '',
    this.kycStatus = '',
    this.moneyGenerated = '',
    this.numberOfPeopleVoted = '',
    this.pollType = '',
    this.pollStatus = '',
    this.startDate = '',
    this.endDate = '',
    this.accountType = '',
    this.startDateString = '',
    this.endDateString = '',
    this.dateIsoFormat = '',
    this.pollTypeId = '',
    this.commission = '',
    this.isFocused = false,
    this.isLoading = false,
    this.isLoadingPollWithStatus = false,
    this.candidateImage,
    this.voteUrlData,
    this.choices = const [],
    this.pollPayoutDocs = const [],
    this.pollDashboardModelDocs = const [],
    this.pollDashboardChoices = const [],
    this.fetchAllPols = const [],
    this.getPollModel = const [],
    this.getAllPollModel = const [],
    this.getMyPollModel = const [],
    this.votes = const [],
    this.castVoteModel = const [],
    this.pollTypes = const [],
    this.singlePollChoices = const [],
    //this.singlePollDocs = const [],
    this.feedPolls = const [],
    this.uploadedDocuments = const [],
    this.activePolls = const [],
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
    String? desc,
    String? fName,
    String? lName,
    String? picture,
    String? question,
    String? pollUrl,
    String? pollId,
    String? totalAmount,
    String? wayaCommission,
    String? dueAmount,
    String? moneyGenerated,
    String? voteCount,
    String? commission,
    String? accountType,
    String? kycStatus,
    String? hoursLeft,
    String? createdAt,
    String? numberOfPeopleVoted,
    String? startDate,
    String? startDateString,
    String? pollStatus,
    String? endDateString,
    String? dateIsoFormat,
    String? endDate,
    String? pollType,
    String? pollFee,
    File? candidateImage,
    VoteUrlData? voteUrlData,
    String? pollTypeId,
    bool? isFocused,
    bool? isLoading,
    bool? isLoadingPollWithStatus,
    List<PollPayoutDocs>? pollPayoutDocs,
    List<Docs>? fetchAllPols,
    List<Docs>? activePolls,
    List<GetPollData>? getPollModel,
    List<GetAllPollData>? getAllPollModel,
    List<PollDashboardModelDocs>? pollDashboardModelDocs,
    List<PollData>? getMyPollModel,
    List<SingleDashboardVotes>? votes,
    List<CastVoteData>? castVoteModel,
    List<Choice>? choices,
    List<Select>? pollTypes,
    List<Docs>? feedPolls,
    List<PollDashboardChoices>? pollDashboardChoices,
    List<SinglePollChoices>? singlePollChoices,
  }) {
    return CreatePollVotingState(
        activePolls: activePolls ?? this.activePolls,
        isPersonalNotUpgradedToBusiness:
            isPersonalNotUpgradedToBusiness ?? isPersonalNotUpgradedToBusiness,
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
        pollPayoutDocs: pollPayoutDocs ?? this.pollPayoutDocs,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        totalAmount: totalAmount ?? this.totalAmount,
        wayaCommission: wayaCommission ?? this.wayaCommission,
        dueAmount: dueAmount ?? this.dueAmount,
        startDateString: startDateString ?? this.startDateString,
        endDateString: endDateString ?? this.endDateString,
        candidateImage: candidateImage ?? this.candidateImage,
        dateIsoFormat: dateIsoFormat ?? this.dateIsoFormat,
        isFocused: isFocused ?? this.isFocused,
        isLoading: isLoading ?? this.isLoading,
        pollStatus: pollStatus ?? this.pollStatus,
        commission: commission ?? this.commission,
        kycStatus: kycStatus ?? this.kycStatus,
        isLoadingPollWithStatus:
            isLoadingPollWithStatus ?? this.isLoadingPollWithStatus,
        fetchAllPols: fetchAllPols ?? this.fetchAllPols,
        getPollModel: getPollModel ?? this.getPollModel,
        getAllPollModel: getAllPollModel ?? this.getAllPollModel,
        getMyPollModel: getMyPollModel ?? this.getMyPollModel,
        pollDashboardModelDocs:
            pollDashboardModelDocs ?? this.pollDashboardModelDocs,
        votes: votes ?? this.votes,
        accountType: accountType ?? this.accountType,
        castVoteModel: castVoteModel ?? this.castVoteModel,
        uploadedDocuments: uploadedDocuments ?? this.uploadedDocuments,
        choices: choices ?? this.choices,
        voteUrlData: voteUrlData ?? this.voteUrlData,
        pollTypes: pollTypes ?? this.pollTypes,
        pollTypeId: pollTypeId ?? this.pollTypeId,
        voteCount: voteCount ?? this.voteCount,
        feedPolls: feedPolls ?? this.feedPolls,
        numberOfPeopleVoted: numberOfPeopleVoted ?? this.numberOfPeopleVoted,
        moneyGenerated: moneyGenerated ?? this.moneyGenerated,
        pollDashboardChoices: pollDashboardChoices ?? this.pollDashboardChoices,
        singlePollChoices: singlePollChoices ?? this.singlePollChoices,
        desc: desc ?? this.desc,
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      question: question ?? this.question,
      picture: picture ?? this.picture,
      pollUrl: pollUrl ?? this.pollUrl,
      pollFee: pollFee ?? this.pollFee,
      pollId: pollId ?? this.pollId,
      createdAt: createdAt ?? this.createdAt,
      hoursLeft: hoursLeft ?? this.hoursLeft
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

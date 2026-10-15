import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/model/stage_pref_model.dart';

import '../model/category_model.dart';

// State model for ContestController
class ContestControllerState {
  final List<StagePrefModel> contestStages;
  final int selectedIndex;
  final int selectedIndexSignUPRequire;
  final bool creating;
  final bool loadingAllCategory;
  final ContestResponse loadedGetAllCategory;
  final List<Map<String, dynamic>> contestSignUpRequirement;
  final Map<String, dynamic> stage;
  final Map<String, dynamic> contestSignUp;

  ContestControllerState({
    this.contestStages = const [],
    this.selectedIndex = 0,
    this.selectedIndexSignUPRequire = 0,
    this.creating = false,
    this.loadingAllCategory = false,
    ContestResponse? loadedGetAllCategory,
    this.contestSignUpRequirement = const [],
    Map<String, dynamic>? stage,
    Map<String, dynamic>? contestSignUp,
  }) : loadedGetAllCategory = loadedGetAllCategory ?? ContestResponse(),
       stage = stage ?? {
         'stageName': 'Qualification Stage',
         'entryType': 'FREE',
         'entryAmount': 0,
         'numberOfPostPerWeek': 1,
         'priceOfTheWinner': 100,
         'startDate': null,
         'endDate': null,
         'approveBeforeLive': true,
       },
       contestSignUp = contestSignUp ?? {
         'requirementType': 'Document',
         'requirementName': 'free name',
         'textDescription': 'Participant full name',
         'required': true,
       };

  ContestControllerState copyWith({
    List<StagePrefModel>? contestStages,
    int? selectedIndex,
    int? selectedIndexSignUPRequire,
    bool? creating,
    bool? loadingAllCategory,
    ContestResponse? loadedGetAllCategory,
    List<Map<String, dynamic>>? contestSignUpRequirement,
    Map<String, dynamic>? stage,
    Map<String, dynamic>? contestSignUp,
  }) {
    return ContestControllerState(
      contestStages: contestStages ?? this.contestStages,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedIndexSignUPRequire: selectedIndexSignUPRequire ?? this.selectedIndexSignUPRequire,
      creating: creating ?? this.creating,
      loadingAllCategory: loadingAllCategory ?? this.loadingAllCategory,
      loadedGetAllCategory: loadedGetAllCategory ?? this.loadedGetAllCategory,
      contestSignUpRequirement: contestSignUpRequirement ?? this.contestSignUpRequirement,
      stage: stage ?? this.stage,
      contestSignUp: contestSignUp ?? this.contestSignUp,
    );
  }
}

// StateNotifier for ContestController
class ContestController extends StateNotifier<ContestControllerState> {
  ContestController() : super(ContestControllerState());


  ///Create Your Ultimate Talent Contest
  TextEditingController contestTitleTextController = TextEditingController();
  TextEditingController contestCategoryTextController = TextEditingController();
  TextEditingController contestSelectDateTextController =
      TextEditingController();
  TextEditingController contestDescriptionTextController =
      TextEditingController();
  TextEditingController contestVoteCountQualifyTextController =
      TextEditingController();
  TextEditingController contestWinnerAwardTextController =
      TextEditingController();
  TextEditingController contestVisibilityTextController =
      TextEditingController();

  ///Participation Details
  TextEditingController contestHideOrShowResultTextController =
      TextEditingController();
  TextEditingController contestFreeOrPaidTextController =
      TextEditingController();
  TextEditingController contestAmountPerVoteTextController =
      TextEditingController();
  TextEditingController contestDurationWeekTextController =
      TextEditingController();
  TextEditingController contestHowItWorksTextController =
      TextEditingController();
  TextEditingController contestEntryTypeTextController =
      TextEditingController();
  TextEditingController contestDurationTypeTextController =
      TextEditingController();
  TextEditingController contestNumberOfDurationTextController =
      TextEditingController();

  ///Contest Timeline & Stages
  TextEditingController contestSelectStartDateTextController =
      TextEditingController();
  TextEditingController contestDescriptionOfAwardsTextController =
      TextEditingController();
  TextEditingController contestSelectStartDateStageTextController =
      TextEditingController();
  TextEditingController contestSelectEndDateStageTextController =
      TextEditingController();
  TextEditingController contestMultipleStagesTextController =
      TextEditingController();
  TextEditingController contestCurrentStageTextController =
      TextEditingController();

  ///Edit stage
  TextEditingController contestStageNameTextController =
      TextEditingController();
  TextEditingController contestMaxVoteTextController = TextEditingController();
  TextEditingController contestEntryTypeStageTextController =
      TextEditingController();
  TextEditingController contestSelectStartDateStage2TextController =
      TextEditingController();
  TextEditingController contestSelectEndDateTextController =
      TextEditingController();
  TextEditingController contestNumberPostsPerWeekTextController =
      TextEditingController();
  TextEditingController contestPrizeWinnerTextController =
      TextEditingController();
  TextEditingController entryAmountController = TextEditingController();
  TextEditingController contestvoteCountToQualifyTextController =
      TextEditingController();

  // true missing

  ///Contest sign up requirement
  TextEditingController contestEnterFullNameTextController =
      TextEditingController();
  TextEditingController contestEmailAddressTextController =
      TextEditingController();
  TextEditingController contestPhoneNumberTextController =
      TextEditingController();
  TextEditingController contestAddressTextController = TextEditingController();

  ///Add New Requirements
  TextEditingController contestRequirementTypeTextController =
      TextEditingController();
  TextEditingController contestEnterRequirementNameController =
      TextEditingController();
  TextEditingController contestEnterTextFieldOptionalController =
      TextEditingController();

  void addStage(StagePrefModel model) {
    final updatedStages = List<StagePrefModel>.from(state.contestStages);
    updatedStages.add(model);
    state = state.copyWith(contestStages: updatedStages);
  }

  void removeStage(int index) {
    if (index >= 0 && index < state.contestStages.length) {
      final updatedStages = List<StagePrefModel>.from(state.contestStages);
      updatedStages.removeAt(index);
      state = state.copyWith(contestStages: updatedStages);
    }
  }

  void updateSelectedIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }

  void updateSelectedIndexSignUPRequire(int index) {
    state = state.copyWith(selectedIndexSignUPRequire: index);
  }

  void updateCreating(bool value) {
    state = state.copyWith(creating: value);
  }

  void updateLoadingAllCategory(bool value) {
    state = state.copyWith(loadingAllCategory: value);
  }

  ///Contest sign up requirement
  void addContestSignUpRequirement() {
    final updatedRequirements = List<Map<String, dynamic>>.from(state.contestSignUpRequirement);
    updatedRequirements.add(state.contestSignUp);
    state = state.copyWith(contestSignUpRequirement: updatedRequirements);
  }

  ///Contest sign up requirement
  void removeContestSignUpRequirement(int index) {
    if (index >= 0 && index < state.contestSignUpRequirement.length) {
      final updatedRequirements = List<Map<String, dynamic>>.from(state.contestSignUpRequirement);
      updatedRequirements.removeAt(index);
      state = state.copyWith(contestSignUpRequirement: updatedRequirements);
    }
  }
}

// Separate class for TextEditingControllers
class ContestFormControllers {
  ///Create Your Ultimate Talent Contest
  final TextEditingController contestTitleTextController = TextEditingController();
  final TextEditingController contestCategoryTextController = TextEditingController();
  final TextEditingController contestSelectDateTextController = TextEditingController();
  final TextEditingController contestDescriptionTextController = TextEditingController();
  final TextEditingController contestVoteCountQualifyTextController = TextEditingController();
  final TextEditingController contestWinnerAwardTextController = TextEditingController();
  final TextEditingController contestVisibilityTextController = TextEditingController();

  ///Participation Details
  final TextEditingController contestHideOrShowResultTextController = TextEditingController();
  final TextEditingController contestFreeOrPaidTextController = TextEditingController();
  final TextEditingController contestAmountPerVoteTextController = TextEditingController();
  final TextEditingController contestDurationWeekTextController = TextEditingController();
  final TextEditingController contestHowItWorksTextController = TextEditingController();
  final TextEditingController contestEntryTypeTextController = TextEditingController();
  final TextEditingController contestDurationTypeTextController = TextEditingController();
  final TextEditingController contestNumberOfDurationTextController = TextEditingController();

  ///Contest Timeline & Stages
  final TextEditingController contestSelectStartDateTextController = TextEditingController();
  final TextEditingController contestDescriptionOfAwardsTextController = TextEditingController();
  final TextEditingController contestSelectStartDateStageTextController = TextEditingController();
  final TextEditingController contestSelectEndDateStageTextController = TextEditingController();
  final TextEditingController contestMultipleStagesTextController = TextEditingController();
  final TextEditingController contestCurrentStageTextController = TextEditingController();

  ///Edit stage
  final TextEditingController contestStageNameTextController = TextEditingController();
  final TextEditingController contestMaxVoteTextController = TextEditingController();
  final TextEditingController contestEntryTypeStageTextController = TextEditingController();
  final TextEditingController contestSelectStartDateStage2TextController = TextEditingController();
  final TextEditingController contestSelectEndDateTextController = TextEditingController();
  final TextEditingController contestNumberPostsPerWeekTextController = TextEditingController();
  final TextEditingController contestPrizeWinnerTextController = TextEditingController();
  final TextEditingController entryAmountController = TextEditingController();
  final TextEditingController contestvoteCountToQualifyTextController = TextEditingController();

  ///Contest sign up requirement
  final TextEditingController contestEnterFullNameTextController = TextEditingController();
  final TextEditingController contestEmailAddressTextController = TextEditingController();
  final TextEditingController contestPhoneNumberTextController = TextEditingController();
  final TextEditingController contestAddressTextController = TextEditingController();

  ///Add New Requirements
  final TextEditingController contestRequirementTypeTextController = TextEditingController();
  final TextEditingController contestEnterRequirementNameController = TextEditingController();
  final TextEditingController contestEnterTextFieldOptionalController = TextEditingController();

  void dispose() {
    contestTitleTextController.dispose();
    contestCategoryTextController.dispose();
    contestSelectDateTextController.dispose();
    contestDescriptionTextController.dispose();
    contestVoteCountQualifyTextController.dispose();
    contestWinnerAwardTextController.dispose();
    contestVisibilityTextController.dispose();
    contestHideOrShowResultTextController.dispose();
    contestFreeOrPaidTextController.dispose();
    contestAmountPerVoteTextController.dispose();
    contestDurationWeekTextController.dispose();
    contestHowItWorksTextController.dispose();
    contestEntryTypeTextController.dispose();
    contestDurationTypeTextController.dispose();
    contestNumberOfDurationTextController.dispose();
    contestSelectStartDateTextController.dispose();
    contestDescriptionOfAwardsTextController.dispose();
    contestSelectStartDateStageTextController.dispose();
    contestSelectEndDateStageTextController.dispose();
    contestMultipleStagesTextController.dispose();
    contestCurrentStageTextController.dispose();
    contestStageNameTextController.dispose();
    contestMaxVoteTextController.dispose();
    contestEntryTypeStageTextController.dispose();
    contestSelectStartDateStage2TextController.dispose();
    contestSelectEndDateTextController.dispose();
    contestNumberPostsPerWeekTextController.dispose();
    contestPrizeWinnerTextController.dispose();
    entryAmountController.dispose();
    contestvoteCountToQualifyTextController.dispose();
    contestEnterFullNameTextController.dispose();
    contestEmailAddressTextController.dispose();
    contestPhoneNumberTextController.dispose();
    contestAddressTextController.dispose();
    contestRequirementTypeTextController.dispose();
    contestEnterRequirementNameController.dispose();
    contestEnterTextFieldOptionalController.dispose();
  }
}

// Riverpod providers
final contestControllerProvider = StateNotifierProvider<ContestController, ContestControllerState>((ref) {
  return ContestController();
});

final contestFormControllersProvider = Provider<ContestFormControllers>((ref) {
  final controllers = ContestFormControllers();
  ref.onDispose(() => controllers.dispose());
  return controllers;
});

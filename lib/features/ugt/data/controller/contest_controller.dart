import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:wayagram/core/data/model/stage_pref_model.dart';
import 'package:wayagram/features/ugt/data/repository/ContestRepo.dart';

import '../../../../core/service/snackbar_service.dart';
import '../model/category_model.dart';

class ContestController extends GetxController {
  //final contestRepo = ContestRepo();
  //var contestStages = [];
  var contestStages = <StagePrefModel>[].obs;
  var selectedIndex = 0;
  var selectedIndexSignUPRequire = 0;
  RxBool creating = RxBool(false);
  RxBool loadingAllCategory = RxBool(false);
  var loadedGetAllCategory = ContestResponse().obs;

  ///Contest sign up requirement
  var contestSignUpRequirement = [];
  var stage = {
    'stageName': 'Qualification Stage',
    'entryType': 'FREE',
    'entryAmount': 0,
    'numberOfPostPerWeek': 1,
    'priceOfTheWinner': 100,
    'startDate': DateTime(2024, 1, 10),
    'endDate': DateTime(2024, 1, 14),
    'approveBeforeLive': true,
  };

  ///Contest sign up requirement
  var contestSignUp = {
    'requirementType': 'Document',
    'requirementName': 'free name',
    'textDescription': 'Participant full name',
    'required': true,
  };

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
    contestStages.add(model);
  }

  void removeStage(int index) {
    if (index >= 0 && index < contestStages.length) {
      contestStages.removeAt(index);
    }
  }

  ///Contest sign up requirement
  void addContestSignUpRequirement() {
    contestSignUpRequirement.add(contestSignUp);
  }

  ///Contest sign up requirement
  void removeContestSignUpRequirement(int index) {
    if (index >= 0 && index < contestSignUpRequirement.length) {
      contestSignUpRequirement.removeAt(index);
    }
  }

  @override
  void onInit() {
    //  getAllCategoryController();
    super.onInit();
  }
/*
  Future getAllCategoryController() async {
    try {
      loadingAllCategory(true);
      var result = await contestRepo.getCategory();

      loadingAllCategory(false);
      print("allCategoryFred ${result.toString()}");

      loadedGetAllCategory.value = allCategoryDetailModelFromJson(result.toString());
      print("allCategoryFred ${loadedGetAllCategory.value.data![0].name}");
    } catch (e) {
      loadingAllCategory(false);
    }
  }*/

  /* Future createContestController(contestStatus, profileId, title, category,
      state, winnerPrize, description, voteCountToQualify, amount, durationType,
      numberOfDuration, descriptionOfAwards, amountPerVote, type, overallResult,
      multipleStages, publicity, status, howItWorks, numberOfWeeks,
      currentStage, participationStartDate, startDate, endDate, entryType,
      contestStages, formRequirements) async {
    try {
      creating(true);
      await contestRepo.createContestController(contestStatus: contestStatus,
          profileId: profileId,
          title: title,
          category: category,
          state: state,
          winnerPrize:
          winnerPrize,
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
          stages: contestStages,
          formRequirements: formRequirements);
         creating(false);

      print("successFred");

    } catch (e) {
      creating(false);
      print("failed ${e.toString()}");
    }
  }*/
}

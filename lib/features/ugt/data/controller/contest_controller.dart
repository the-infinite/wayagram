import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/data/model/stage_pref_model.dart';

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
   TextEditingController contestMaxVoteTextController =
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


 
}

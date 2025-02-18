import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/model/new_requirement_model.dart';
import 'package:wayagram/core/data/model/stage_pref_model.dart';
import 'package:wayagram/features/ugt/data/model/contest_state.dart';
import 'package:wayagram/features/ugt/data/model/create_contest.dart';
import 'package:wayagram/features/ugt/data/repository/ContestRepo.dart';
import 'package:wayagram/shared/features/file/repo/default.dart';
import '../../../core/data/local_data_source.dart';
import '../../../core/data/model/model.dart';
import '../../../core/service/logger_service.dart';
import '../../quotation/data/model/model.dart';
import '../data/controller/contest_controller.dart';
import '../data/model/category_model.dart';

class CreateContestNotifier extends StateNotifier<ContestState> {
  final ContestRepo _contestRepository;
  final WayaLocalDataSource _localDataSource;
  final ContestResponse _contestRespons;
  final _logger = getLogger('ContestRepo');

  CreateContestNotifier(
    this._contestRepository,
    this._localDataSource,
    this._contestController,
    this._contestRespons,
  ) : super(ContestState());

  final ContestController _contestController;

  // var contestStages = [];

  var contestStages = [
    {
      'stageName': 'Qualification Stage',
      'entryType': 'FREE',
      'entryAmount': 2000,
      'numberOfPostPerWeek': 1,
      'priceOfTheWinner': 100,
      'startDate': "2025, 1, 10",
      'endDate': "2025, 1, 14",
      'approveBeforeLive': true,
    }
  ];

  var contestSignUpRequirement = [
    {
      'requirementType': 'TEXT',
      'requirementName': 'Portfolio',
      'textDescription': 'Participant full name',
      'required': true,
    }
  ];

  //var contestSignUpRequirement = [];

  Future<void> onSubmit(List<NewRequirementModel> newRequirementList,
      List<StagePrefModel> stageList) async {
    print(' sss ${_localDataSource.getUserId().toString()}');
    //final userTypeProvider = ref.watch(localDataSourceProvider);

     final profileImageUrl = await WayaFileRepository.instance.uploadFile(File(state.image),);
    try {
      state = state.copyWith(isLoading: true);
      var map = {
        "title": state.title.text,
        "profileId": _localDataSource.getUserId().toString(),
        "category": state.categorys,
        "state": state.state,
        "description": state.description.text,
        "voteCountToQualify": state.voteCountToQualify.text,
        "winnerPrize": state.winnerPrize.text,
        "contestPrivatePublic": "unkown",
        "contestFreePaid": "unkown",
        "showOverAllResult": state.overallResult,
        "amountPerVote": state.amountPerVote.text,
        "numberOfWeeks": state.numberOfWeeks.text,
        "image": profileImageUrl,
        //participation details
        "howItWorks": state.howItWorks.text,
        "entryType": state.entrySelectType,
        "amount": state.amount.text,
        "durationType": state.durationSelectType,
        "numberOfDuration": state.numberOfDuration.text,
        "stateDate": state.startDate,
        "contestDescription": state.descriptionOfAwards.text,
        //contest timeline & Stages
        "timeStartDate": state.contestTimelineStartDate,
        "timeEndDate": state.contestTimelineEndDate,
        "timeMultipleStage": state.contestTimelineMultipleStage,
        "timeCurrentStage": state.contestTimelineCurrentStage,
        //Stage Settings
        "stages": stageList,
        //Contest signup requirement
        "contestRequirement": newRequirementList,
      };
      print(map.toString());
      final response = await _contestRepository.createContest(map);

      /*  final response = await _contestRepository.createContest(
        CreateContestModel(
            title: state.title.text,
            profileId: _localDataSource.getUserId().toString(),
            category: 'db201982-1c25-4c51-b183-cb9e5ddf2a8e',
            state: 'Lagos',
            winnerPrize: state.winnerPrize.text,
            description: state.description.text,
            voteCountToQualify: state.voteCountToQualify.text,
            amount: state.amount.text,
            durationType: state.durationType.text,
            numberOfDuration: state.numberOfDuration.text,
            descriptionOfAwards: state.descriptionOfAwards.text,
            amountPerVote: state.amountPerVote.toString(),
            type: 'Free',
            overallResult: 'Yes',
            multipleStages: state.multipleStages.text,
            publicity: 'Yes',
            status: state.status.text,
            howItWorks: state.howItWorks.text,
            numberOfWeeks: state.numberOfWeeks.text,
            currentStage: state.currentStage.text,
            participationStartDate: state.participationStartDate.text,
            startDate: state.startDate,
            endDate: state.endDate,
            entryType: 'Free',
            contestSettings: ContestSettings(
                stages: contestStages,
                formRequirements: contestSignUpRequirement)),
      ); */

      print("fredGo:  $response");
      if (response.success) {
        print("fredGo:  $response");
        // final responseModel = ResponseModel.fromJson(response.data);
        //final contestDetails = responseModel.data.user;
        // state = state.copyWith(respose: contestDetails);
      }
    } catch (e) {
      _logger.e(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> showDatePickerDialog(BuildContext context) async {
    try {
      final response = await pickerDialog(context);

      if (response != null) {
        final startDate = "${response.year}-${response.month}-${response.day}";
        final dateIsoFormat = response.toIso8601String();
        state =
            state.copyWith(startDate: startDate, dateIsoFormat: dateIsoFormat);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<DateTime?> pickerDialog(BuildContext context) async {
    try {
      final response = await showDatePicker(
          context: context,
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          initialDate: DateTime.now());

      if (response != null) {
        return response;
      }
    } catch (error) {
      print(error);
    }
    return null;
  }

  void focusChanged2(bool hasFocus) {
    state = state.copyWith(isFocused: hasFocus);
  }

  Future<void> showDatePickerDialogEndDate(BuildContext context) async {
    try {
      final response = await showDatePicker(
          context: context,
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          initialDate: DateTime.now());
      if (response != null) {
        final endDate = "${response.year}-${response.month}-${response.day}";
        final dateIsoFormat = response.toIso8601String();
        state =
            state.copyWith(endDate: endDate, endDateIsoFormat: dateIsoFormat);
      }
    } catch (error) {
      print(error);
    }
  }

/*  Future<void> fetchStates() async {
    try {
      final response = await _contestRepository.getAllStates();

      if (response.success) {
        StatesResponseModel responseModel =
        StatesResponseModel.fromJson(response.data);

        final List<Select> allStates = responseModel.data.map((val) {
          return Select(label: val.name, value: val.isoCode);
        }).toList();
        state = state.copyWith(states: allStates);
      }
    } catch (e) {
      _logger.e(e);
    }
  }*/

  List<Select> ugtCategory() {
    return categories.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(), label: entries.value.category);
    }).toList();
  }

  List<Select> ugtStates() {
    return states.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(), label: entries.value.state);
    }).toList();
  }

  List<Select> ugtCategoryStat() {
    return ugtCategoryStates.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(),
          label: entries.value.ugtCategoryState);
    }).toList();
  }

  List<Select> ugtPaymentType() {
    return paymentTypes.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(), label: entries.value.paymentType);
    }).toList();
  }

  void update(Select value, String name) {
    switch (name) {
      case "contestCat":
        state = state.copyWith(categorys: value.label);
        state = state.copyWith(selectedCategory: value);
    }
  }

  List<Select> ugtDurationType() {
    return durationTypes.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(),
          label: entries.value.durationType);
    }).toList();
  }

  List<Select> ugtWinnerPrize() {
    return winnerPrizes.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(), label: entries.value.winnerPrize);
    }).toList();
  }

  List<Select> ugtMultipleStages() {
    return multipleStages.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(),
          label: entries.value.multipleStage);
    }).toList();
  }

  List<Select> ugtCurrentStage() {
    return currentStages.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(),
          label: entries.value.currentStage);
    }).toList();
  }

  Future<void> selectState(Select value) async {
    //  String state = state.state;
    state = state.copyWith(state: value.label);

    /*  if (state.isNotEmpty && value.label != state) {
      state.copyWith(states: []);
      state = state.copyWith(state: '');
    } */

    await allCategories();
  }

  List<Select> ugtRequirementType() {
    return requirementTypes.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(),
          label: entries.value.requirementType);
    }).toList();
  }

  Future<void> allCategories() async {
    try {
      final response = await _contestRepository.getCategory();
      if (response.success) {
        print('Na Gadus: ${response.data}');

        //ContestResponse responseModel = allCategoryDetailModelFromJson(response.data);

        // print('Nyash Message: ${responseModel.message}');
        // final List<ContestCategory>? categories = responseModel.data;

        // print('categories ${categories![0].name}');
        // final List<Select> selectCategories = categories.map((val) {
        //   return Select(label: val.name, value: val.id);
        // }).toList();

        //state = state.copyWith(categories: selectCategories);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateImage(String name) {
    state = state.copyWith(image: name);
  }

  //Participation Details
  void updateEntryType(String name) {
    state = state.copyWith(entrySelectType: name);
  }

  void updateDurationType(String name) {
    state = state.copyWith(durationSelectType: name);
  }

  //Contest timeline
  void updateContestTimeStartDate(String name) {
    state = state.copyWith(contestTimelineStartDate: name);
  }

  void updateContestTimeEndDate(String name) {
    state = state.copyWith(contestTimelineEndDate: name);
  }

  void updateContestTimeMultipleStage(String name) {
    state = state.copyWith(contestTimelineMultipleStage: name);
  }
    void updateOverAllResult(bool name) {
    state = state.copyWith(overallResult: name);
  }

  void updateContestTimeCurrentStage(String name) {
    state = state.copyWith(contestTimelineCurrentStage: name);
  }

  Future<void> showDateContestStart(BuildContext context) async {
    try {
      final response = await pickerDialog(context);

      if (response != null) {
        final startDate = "${response.year}-${response.month}-${response.day}";
        final dateIsoFormat = response.toIso8601String();
        state = state.copyWith(
            contestTimelineStartDate: startDate, dateIsoFormat: dateIsoFormat);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> showDateContestEnd(BuildContext context) async {
    try {
      final response = await pickerDialog(context);

      if (response != null) {
        final startDate = "${response.year}-${response.month}-${response.day}";
        final dateIsoFormat = response.toIso8601String();
        state = state.copyWith(
            contestTimelineEndDate: startDate, dateIsoFormat: dateIsoFormat);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<String?> showDatePickerMain(BuildContext context) async {
    try {
      final response = await pickerDialog(context);

      if (response != null) {
        final startDate = "${response.year}-${response.month}-${response.day}";
        final dateIsoFormat = response.toIso8601String();
        return startDate;
      }
    } catch (error) {
      print(error);
    }
    return null;
  }

  //Stage Preference
  List<StagePrefModel>? getEditStageList() {
    return state.stagePrefModels;
  }

  void updateEditStagePrefName(String name) {
    state = state.copyWith(stagePrefModel: StagePrefModel(stageName: name));
  }

  void updateEditStagePrefList() {
    state.copyWith(stagePrefModels: [
      ...state.stagePrefModels ?? [],
      state.stagePrefModel!
    ]);
  }

  void updateEditStagePrefListValue(StagePrefModel model) {
    state.copyWith(stagePrefModels: [...state.stagePrefModels ?? [], model]);
  }
}

final authRepositoryProvider = Provider((ref) => ContestRepo());
final contestControllerProvider = Provider((ref) => ContestController());
final stateContactProvider = StateProvider<List<StagePrefModel>>((ref) => [
      StagePrefModel(id: 0, stageName: "Qualification Stage"),
      StagePrefModel(id: 1, stageName: "Contest"),
      StagePrefModel(id: 2, stageName: "Contest"),
      StagePrefModel(id: 3, stageName: "Contest"),
      StagePrefModel(id: 4, stageName: "Contest"),
    ]);

final stateRequirementProvider =
    StateProvider<List<NewRequirementModel>>((ref) => []);
final categoryData = Provider((ref) => ContestResponse());

final contestNotifierProvider =
    StateNotifierProvider<CreateContestNotifier, ContestState>(
  (ref) {
    // final contestRepository = ref.watch(authRepositoryProvider);
    final contestNotifierProvider2 = ref.watch(contestControllerProvider);
    final categoryProvider = ref.watch(categoryData);

    return CreateContestNotifier(ContestRepo(), WayaLocalDataSource(),
        contestNotifierProvider2, categoryProvider);
  },
);

final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

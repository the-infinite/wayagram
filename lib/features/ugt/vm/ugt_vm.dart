import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/model/new_requirement_model.dart';
import 'package:wayagram/core/data/model/stage_pref_model.dart';
import 'package:wayagram/features/auth/account_creation/data/model/location_response_model.dart';
import 'package:wayagram/features/ugt/data/model/category_response.dart';
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
  late TextEditingController title;

  late TextEditingController winnerPrize;
  late TextEditingController description;
  late TextEditingController voteCountToQualify;

  late TextEditingController amountPerVote;
  late TextEditingController numberOfWeeks;

  CreateContestNotifier(
    this._contestRepository,
    this._localDataSource,
    this._contestController,
    this._contestRespons,
  ) : super(ContestState()) {
    title = TextEditingController();
    winnerPrize = TextEditingController();
    description = TextEditingController();
    voteCountToQualify = TextEditingController();
    amountPerVote = TextEditingController();
    numberOfWeeks = TextEditingController();
  }

  final ContestController _contestController;

  // var contestStages = [];
  @override
  void dispose() {
    // TODO: implement dispose
    title.dispose();
    winnerPrize.dispose();
    description.dispose();
    voteCountToQualify.dispose();
    amountPerVote.dispose();
    numberOfWeeks.dispose();
    super.dispose();
  }

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
    //  print(' sss ${_localDataSource.getUserId().toString()}');
    //final userTypeProvider = ref.watch(localDataSourceProvider);
    /* 
      "requirementType": "TEXT",
        "requirementName": "Full Name",
        "textDescription": "Participant's full name",
        "required": true
     */
    List<Map<String, dynamic>> mapRequireList = newRequirementList
        .map(
          (user) => <String, dynamic>{
            "requirementType": user.requirementType,
            "requirementName": user.requirementName,
            "textDescription": user.requirementOptional,
            "required": user.isRequired
          },
        )
        .toList();
    List<Map<String, dynamic>> mapStageList = stageList
        .map(
          (model) => <String, dynamic>{
            "stageName": model.stageName,
            "entryType": model.entryType,
            "entryAmount": model.entryAmount
                ?.split('.')
                .first
                .replaceAll(",", "")
                .substring(3),
            "numberOfPostPerWeek": model.numPostPerWeek,
            "priceOfTheWinner": model.priceWinner,
            "startDate": model.startDate,
            "endDate": model.endDate,
            "approveBeforeLive": model.reviewApprovePost
          },
        )
        .toList();

    final profileImageUrl = await WayaFileRepository.instance.uploadFile(
      File(state.image),
    );
    try {
      state = state.copyWith(isLoading: true);
      var map = {
        "title": title.text,
        "profileId": _localDataSource.getUserId().toString(),
        "category": state.categoryId,
        "state": state.state,
        "winnerPrize": 500, //state.winnerPrize.text,
        "description": description.text,
        "voteCountToQualify": 5, //voteCountToQualify.text,
        "amount":
            state.amount.text.split('.').first.replaceAll(",", "").substring(3),
        "durationType": state.durationSelectType.toUpperCase(),
        "numberOfDuration": state.numberOfDuration.text,
        "descriptionOfAwards": state.descriptionOfAwards.text,
        "amountPerVote": state.amountPerVote.text
            .split('.')
            .first
            .replaceAll(",", "")
            .substring(3),
        "type": state.contestFreePaid.toUpperCase(),
        "overallResult": state.overallResult == true ? "Yes" : "No",
        "multipleStages": state.contestTimelineMultipleStage,
        "publicity": state.contestPrivatePublic.toUpperCase(),
        "status": "ACTIVE",
        "howItWorks": state.howItWorks.text,
        "numberOfWeeks": state.numberOfWeeks.text,
        "currentStage": state.contestTimelineCurrentStage,
        "participationStartDate": "2024-01-01T00:00:00Z", //state.startDate,
        "startDate": "2024-01-01T00:00:00Z", //state.contestTimelineStartDate,
        "endDate": "2024-01-01T00:00:00Z", //state.contestTimelineEndDate,
        "entryType": state.entrySelectType,

        "contestSettings": {
          "stages": mapStageList,
          "formRequirements": mapRequireList
        }
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
    return state.category.asMap().entries.map((entries) {
      return Select(
          value: entries.value.value.toString(), label: entries.value.label);
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
    print('were ${value.toJson()}');
    state = state.copyWith(categorys: value.label);
    state = state.copyWith(categoryId: value.value);
    state = state.copyWith(
        selectedCategory: Select(label: value.label, value: value.value));
    print('were ${state.categoryId}');
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
        ContestCategory2 responseModel =
            ContestCategory2.fromJson(response.data);

        final List<Select> allCategory = responseModel.data.map((val) {
          print('Error: ${val.id}');
          return Select(
              label: val.name ?? "", value: val.id ?? "", image: val.id ?? "");
        }).toList();
        state = state.copyWith(category: allCategory);
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

  void updatePrivatePublic(String name) {
    state = state.copyWith(contestPrivatePublic: name);
  }

  void updateContestFreePaid(String name) {
    state = state.copyWith(contestFreePaid: name);
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

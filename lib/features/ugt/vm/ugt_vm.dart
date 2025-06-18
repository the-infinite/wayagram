import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/data/model/new_requirement_model.dart';
import 'package:wayagram/core/data/model/stage_pref_model.dart';
import 'package:wayagram/core/helpers/debug.dart';
import 'package:wayagram/core/helpers/value.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_routes.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/ugt/create_contest/steps/create_ultimate.dart';
import 'package:wayagram/features/ugt/data/model/category_response.dart';
import 'package:wayagram/features/ugt/data/model/contest_state.dart';
import 'package:wayagram/features/ugt/data/repository/ContestRepo.dart';
import 'package:wayagram/features/ugt/my_contest_details/admin_contest_details.dart';
import 'package:wayagram/features/ugt/ugt_buttomsheet_modal/successful_modal.dart';
import 'package:wayagram/features/ugt/ugt_home.dart';
import 'package:wayagram/features/ugt/vm/ugt_aplied_contest_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/shared/features/file/repo/default.dart';
import '../../../core/data/local_data_source.dart';
import '../../../core/data/model/model.dart';
import '../../../core/service/logger_service.dart';
import '../../quotation/data/model/model.dart';
import '../data/controller/contest_controller.dart';
import '../data/model/category_model.dart';

String _convertToISO(String dateString) {
  DateTime dateTime = DateFormat("yyyy-M-d").parse(dateString);
  DateTime futureDate = dateTime.add(Duration(days: 1));

  // Convert to UTC ISO 8601 format
  return "${futureDate.toUtc().toIso8601String().split('.')[0].replaceAll("T23", "T00")}Z";
}

class CreateContestNotifier extends StateNotifier<ContestState> {
  final ContestRepo _contestRepository;
  final WayaLocalDataSource _localDataSource;
  //final ContestResponse _contestRespons;
  final _logger = getLogger('ContestRepo');
  late TextEditingController title;
  late TextEditingController maxVote;

  late TextEditingController winnerPrize;
  late TextEditingController description;
  late TextEditingController voteCountToQualify;

  late TextEditingController amountPerVote;
  late TextEditingController numberOfWeeks;

  CreateContestNotifier(
    this._contestRepository,
    this._localDataSource,
    //this._contestController,
  ) : super(ContestState()) {
    title = TextEditingController();
    maxVote = TextEditingController();
    winnerPrize = TextEditingController();
    description = TextEditingController();
    voteCountToQualify = TextEditingController();
    amountPerVote = TextEditingController();
    numberOfWeeks = TextEditingController();
  }

  //final ContestController _contestController;

  // var contestStages = [];
  @override
  void dispose() {
    title.dispose();
    maxVote.dispose();
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
      'priceOfTheWinner': "100",
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

  Future<void> onSubmit(
      WidgetRef ref,
      BuildContext context,
      ValueNotifier<bool> isLoading,
      List<NewRequirementModel> newRequirementList,
      List<StagePrefModel> stageList,
      bool isEditing) async {
    //  debugPrint(' sss ${_localDataSource.getUserId().toString()}');
    //final userTypeProvider = ref.watch(localDataSourceProvider);
    /* 
      "requirementType": "TEXT",
        "requirementName": "Full Name",
        "textDescription": "Participant's full name",
        "required": true
     */
    debugPrint("eeeeee ${state.startDate}");
    var contestViewModel = ref.watch(selectedContestProvider.notifier).state;
    isLoading.value = true;
    state = state.copyWith(isLoading: true);

    List<Map<String, dynamic>> mapRequireList = newRequirementList
        .map(
          (user) => <String, dynamic>{
            "requirementType": user.requirementType,
            "requirementName": user.requirementName,
            "textDescription": "ef", //user.requirementOptional,
            "required": user.isRequired
          },
        )
        .toList();

    List<Map<String, dynamic>> mapStageList = stageList.map(
      (model) {
        String stageEndDate = _convertToISO(model.endDate!) ==
                _convertToISO(model.startDate!)
            ? _convertToISO(model.endDate!).replaceAll("T00:00:00", "T23:59:59")
            : _convertToISO(model.endDate!);

        return <String, dynamic>{
          "stageName": model.stageName,
          "entryType": model.entryType?.toUpperCase(),
          "entryAmount": model.entryAmount!.contains("NGN")
              ? model.entryAmount!
                  .split(".")
                  .first
                  .substring(3)
                  .replaceAll(",", "")
              : model.entryAmount,
          "voteCountToQualify": model.voteCountToQualify ?? "",
          "numberOfPostPerWeek": model.numPostPerWeek,
          "maxVote": model.maxVote,
          "priceOfTheWinner": model
              .priceWinner /* !.contains("NGN")
              ? int.parse(model.priceWinner!
                  .split(".")
                  .first
                  .substring(3)
                  .replaceAll(",", ""))
              : int.parse(model.priceWinner ?? "0") */
          ,
          "startDate": _convertToISO(model.startDate!), // model.startDate,
          "endDate": stageEndDate, // model.endDate,
          "approveBeforeLive": model.reviewApprovePost
        };
      },
    ).toList();
    String? profileImageUrl = "";
    if (isEditing) {
      if (state.image.trim().isEmpty) {
        // use the defualt url
        profileImageUrl = contestViewModel?.uploadCoverImages ?? "";
      }
    } else {
      String mimeTypeImage =
          WayaHelpers.getContentTypeFromPath(state.image) ?? "";
      profileImageUrl = await WayaFileRepository.instance.uploadFile(
        File(state.image),
        "ugt-image-${Uuid().v4()}.${mimeTypeImage.split("/").last}",
      );
    }

    //NGN8.00
    try {
      //  debugPrint("wwwww ${amountPerVote.text}");
      String participationEndDate = _convertToISO(state.endDate) ==
              _convertToISO(state.startDate)
          ? _convertToISO(state.endDate).replaceAll("T00:00:00", "T23:59:59")
          : _convertToISO(state.endDate);

      String contestTimeLineEndDate =
          _convertToISO(state.contestTimelineEndDate) ==
                  _convertToISO(state.contestTimelineStartDate)
              ? _convertToISO(state.contestTimelineEndDate)
                  .replaceAll("T00", "T23")
              : _convertToISO(state.contestTimelineEndDate);

      var map = {
        "title": title.text,
        "profileId": _localDataSource.getUserId().toString(),
        "category": state.categoryId,
        // "categoryName": state.categorys,
        "state": state.state,
        //  "numberOfWeeks":numberOfWeeks.text,
        "winnerPrize": winnerPrize
            .text /* .contains("NGN")
            ? winnerPrize.text.split(".").first.substring(3).replaceAll(",", "")
            : winnerPrize.text */
        ,
        "description": description.text,
        //  "voteCountToQualify": voteCountToQualify.text,
        "amount": state.amount.text.contains("NGN")
            ? state.amount.text
                .split(".")
                .first
                .substring(3)
                .replaceAll(",", "")
            : state.amount.text,

        //  "durationType": state.entrySelectType.toUpperCase(),
        // "numberOfDuration": state.numberOfDuration.text,
        "descriptionOfAwards": state.descriptionOfAwards.text,
        "amountPerVote": amountPerVote.text.contains("NGN")
            ? amountPerVote.text
                .split(".")
                .first
                .substring(3)
                .replaceAll(",", "")
            : amountPerVote.text,
        //   "type": state.contestFreePaid.toUpperCase(),
        "overallResult": state.overallResult == true ? "YES" : "NO",
        "multipleStages": state.contestTimelineMultipleStage.toUpperCase(),
        "publicity": state.contestPrivatePublic.toUpperCase(),
        "status": "ACTIVE",
        "howItWorks": state.howItWorks.text,
        //  "numberOfWeeks": numberOfWeeks.text,
        "currentStage": state.contestTimelineCurrentStage.trim().isEmpty
            ? "Nill"
            : state.contestTimelineCurrentStage,
        "participationStartDate": _convertToISO(state.startDate),
        "participationEndDate": participationEndDate,

        "startDate": _convertToISO(state.contestTimelineStartDate),
        "uploadCoverImages": profileImageUrl,
        "endDate":
            contestTimeLineEndDate, //_convertToISO(state.contestTimelineEndDate),

        "entryType": state.entrySelectType.toUpperCase(),

        "contestSettings": {
          "stages": mapStageList,
          "formRequirements": mapRequireList
        }
      };
      debugPrint(map.toString());
      WayaRequestResponse? response;
      if (isEditing) {
        response = await _contestRepository.editContest(
            contestViewModel?.id ?? "", map);
      } else {
        response = await _contestRepository.createContest(map);
      }
      // response = await _contestRepository.createContest(map);
      isLoading.value = false;

      if (response.success) {
        ref.read(postProvider.notifier).fetchContestForYou(true);
        //  ref.read(postProvider.notifier).fetchPosts();
        // ref.read(postProvider.notifier).fetchPosts();
        WayaUtils.showModalSheetUgt(
          context,
          child: SuccessfulModal(
              title: "Contest created Successfully",
              subtitle:
                  "Your contest is now live and visible to the public. Manage or share your contest details from your dashboard.",
              showCopyLink: true,
              buttonText: null,
              onShareTap: () async {
                await Share.share(
                  WayaValueHelper.getShareableUrl(
                      WayaAppRoutes.getContestDetailRoute(
                          response?.data["data"]["contest"]["id"] ?? "")),
                  subject: "Share Contest",

                  /* Uri.parse(
                          "http://wayagram.ng/upcoming-manage-contest-details?id=${widget.post.id}") */
                );
              },
              onTap: (_, __) {
                // WayaNav.removeUntilNamed("/ugt-home");
                WayaNav.removeAllUntil(UgtHome(), '/ugt-home');
              }),
        );
      } else {
        WayaSnackBar.showToast(response.data["message"]);
      }
    } catch (e) {
      _logger.e(e.toString());
    } finally {
      isLoading.value = false;
      state = state.copyWith(isLoading: false);
    }
  }

  void createContestProfile(
    BuildContext context,
    ValueNotifier<bool> isLoading,
    WidgetRef ref,
    String imagePath,
    String videoPath,
    String bio,
    String expectationFromVoters,
    String contestID,
  ) async {
    print("Here heeee");
    isLoading.value = true;
    String mimeTypeImage = WayaHelpers.getContentTypeFromPath(imagePath) ?? "";
    final imageUrl = await WayaFileRepository.instance.uploadFile(
        File(imagePath),
        "ugt-image-${Uuid().v4()}.${mimeTypeImage.split("/").last}");

    String mimeTypeVideo = WayaHelpers.getContentTypeFromPath(videoPath) ?? "";
    final videoUrl = await WayaFileRepository.instance.uploadFile(
        File(videoPath),
        "ugt-video-${Uuid().v4()}.${mimeTypeVideo.split("/").last}");
    var model = ref.read(selectedAppliedContestProvider.notifier).state;
    var map = {
      "profileId": _localDataSource.getUserId().toString(),
      "contestId": contestID,
      "bio": bio,
      "expectationFromVoters": expectationFromVoters,
      if (model!.id!.trim().isNotEmpty) "contestApplicationId": model.id ?? "",
      "introVideo": videoUrl,
      "profilePhoto": imageUrl
    };
    print("Here");
    print(map.toString());
    print("here2");
    final response = await _contestRepository.createProfile(map);
    isLoading.value = false;
    if (response.success) {
      WayaNav.goBack();
    } else {
      WayaSnackBar.showToast(response.data["message"]);
    }
  }

  void editContestProfile(
    BuildContext context,
    ValueNotifier<bool> isLoading,
    WidgetRef ref,
    String imagePath,
    String videoPath,
    String bio,
    String expectationFromVoters,
    String id,
    bool pickAnotherImage,
    bool pickAnotherVideo,
    String oldImagePath,
    String oldVideoPath,
  ) async {
    isLoading.value = true;
    String? imageUrl = oldImagePath;
    String? videoUrl = oldVideoPath;

    if (pickAnotherImage) {
      String mimeTypeImage =
          WayaHelpers.getContentTypeFromPath(imagePath) ?? "";
      imageUrl = await WayaFileRepository.instance.uploadFile(File(imagePath),
          "ugt-image-${Uuid().v4()}.${mimeTypeImage.split("/").last}");
    }

    if (pickAnotherVideo) {
      String mimeTypeVideo =
          WayaHelpers.getContentTypeFromPath(imagePath) ?? "";
      videoUrl = await WayaFileRepository.instance.uploadFile(File(videoPath),
          "ugt-video-${Uuid().v4()}.${mimeTypeVideo.split("/").last}");
    }

    var model = ref.read(selectedAppliedContestProvider.notifier).state;
    var map = {
      "profileId": _localDataSource.getUserId().toString(),
      "contestId": model!.contestId,
      "bio": bio,
      "expectationFromVoters": expectationFromVoters,
      "contestApplicationId": model.id,
      "introVideo": videoUrl,
      "profilePhoto": imageUrl
    };

    //debugPrint("My Map $map");
    final response = await _contestRepository.editProfile(id, map);

    isLoading.value = false;
    if (response.success) {
      ref
          .read(votersContestNotifier.notifier)
          .getContestantProfileVoteDetails(model.contestId ?? "");

      ref
          .read(votersContestNotifier.notifier)
          .fetchAllContestPosts(model.contestId ?? "");
      ref
          .read(votersContestNotifier.notifier)
          .fetchAllContestApplicant(model.contestId ?? "");
      WayaNav.removeUntilNamed(AdminContestDetails.route);
    } else {
      WayaSnackBar.showToast(response.data["message"]);
    }
  }

    Future<void> requestPayout(ctx, String contestId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _contestRepository.requestPayout(contestId);
      state = state.copyWith(isLoading: false);
      if (response.success && ctx.mounted) {
        WayaNav.toNamed('/admin-transaction-page');
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Payout request was sent successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> showDatePickerDialog(BuildContext context) async {
    try {
      final response = await pickerDialog(context, firtDate: DateTime.now());

      if (response != null) {
        final startDate = "${response.year}-${response.month}-${response.day}";
        final dateIsoFormat = response.toIso8601String();
        state =
            state.copyWith(startDate: startDate, dateIsoFormat: dateIsoFormat);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> showDatePickerDialog2(BuildContext context) async {
    try {
      final response = await pickerDialog(context);

      if (response != null) {
        final endDate = "${response.year}-${response.month}-${response.day}";
        final dateIsoFormat = response.toIso8601String();
        state = state.copyWith(endDate: endDate, dateIsoFormat: dateIsoFormat);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<DateTime?> pickerDialog(BuildContext context,
      {DateTime? firtDate, DateTime? lastDate}) async {
    try {
      final response = await showDatePicker(
          context: context,
          firstDate: firtDate ?? DateTime(1800),
          lastDate: lastDate ?? DateTime(2050),
          initialDate: firtDate ?? DateTime.now());

      if (response != null) {
        return response;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    return null;
  }

  Future<DateTime?> pickerDialog2(BuildContext context,
      {DateTime? firtDate, DateTime? lastDate}) async {
    try {
      final response = await showDatePicker(
          context: context,
          firstDate: firtDate ?? DateTime(1800),
          lastDate: lastDate ?? DateTime(2050),
          initialDate: lastDate ?? DateTime.now());

      if (response != null) {
        return response;
      }
    } catch (error) {
      debugPrint(error.toString());
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
          firstDate: DateTime(1800),
          lastDate: DateTime(2050),
          initialDate: DateTime.now());
      if (response != null) {
        final endDate = "${response.year}-${response.month}-${response.day}";
        final dateIsoFormat = response.toIso8601String();
        state =
            state.copyWith(endDate: endDate, endDateIsoFormat: dateIsoFormat);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

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

  List<Select> ugtStatesExcludedAllState() {
    var list = states.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(), label: entries.value.state);
    }).toList();
    list.removeAt(0);
    return list;
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
    debugPrint('were ${value.toJson()}');
    state = state.copyWith(categorys: value.label);
    state = state.copyWith(categoryId: value.value);
    state = state.copyWith(
        selectedCategory: Select(label: value.label, value: value.value));
    debugPrint('were ${state.categoryId}');
  }

  updateEdit(String value) {
    var returnedState = state.category
        .asMap()
        .entries
        .firstWhere((entries) => entries.value.label == value);

    state = state.copyWith(categorys: returnedState.value.label);
    state = state.copyWith(categoryId: returnedState.value.value.toString());
    state = state.copyWith(
        selectedCategory: Select(
            label: returnedState.value.value.toString(),
            value: returnedState.value.label));
    /*    .map((entries) {
      return Select(
          value: entries.value.value.toString(), label: entries.value.label);
    }).toList(); */
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

  selectStateEdit(String value) {
    var selectedState = states
        .asMap()
        .entries
        .firstWhere((entries) => entries.value.state == value);
    state = state.copyWith(state: selectedState.value.state);

    /*  .map((entries) {
      return Select(
          value: entries.value.id.toString(), label: entries.value.state);
    }).toList(); */
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
          debugPrint('Error: ${val.id}');
          return Select(
              label: val.name ?? "", value: val.id ?? "", image: val.id ?? "");
        }).toList();
        state = state.copyWith(category: allCategory);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void updateImage(String name) {
    state = state.copyWith(image: name);
  }

  String getImage() {
    return state.image;
  }

  //Participation Details
  void updateEntryType(String name) {
    state = state.copyWith(entrySelectType: name);
  }

  void updateDurationType(String name) {
    state = state.copyWith(durationSelectType: name);
  }

  void updateParticipationDate(String name) {
    state = state.copyWith(startDate: name);
  }

  void updateParticipationEndDate(String name) {
    state = state.copyWith(endDate: name);
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
      DateTime now = DateTime.now();
      final response = await pickerDialog(context, firtDate: now);

      if (response != null) {
        final startDate = "${response.year}-${response.month}-${response.day}";
        final dateIsoFormat = response.toIso8601String();
        state = state.copyWith(
            contestTimelineStartDate: startDate, dateIsoFormat: dateIsoFormat);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> showDateContestEnd(BuildContext context) async {
    try {
      var date = convertToUsableDate(
          state.contestTimelineStartDate.trim().isEmpty
              ? "2050-1-1"
              : state.contestTimelineStartDate);

      final response = await pickerDialog(context, firtDate: date);

      if (response != null) {
        final startDate = "${response.year}-${response.month}-${response.day}";
        final dateIsoFormat = response.toIso8601String();
        state = state.copyWith(
            contestTimelineEndDate: startDate, dateIsoFormat: dateIsoFormat);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<String?> showDatePickerMain(BuildContext context,
      {DateTime? firstDate, DateTime? lastDate}) async {
    try {
      final response =
          await pickerDialog(context, firtDate: firstDate, lastDate: lastDate);

      if (response != null) {
        final startDate = "${response.year}-${response.month}-${response.day}";
        //final dateIsoFormat = response.toIso8601String();
        return startDate;
      }
    } catch (error) {
      debugPrint(error.toString());
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
      StagePrefModel(id: 1, stageName: "Contest Stage"),
      StagePrefModel(id: 2, stageName: "Contest Stage"),
      StagePrefModel(id: 3, stageName: "Contest Stage"),
      StagePrefModel(id: 4, stageName: "Contest Stage"),
    ]);

final stateIsEditingContestProvider = StateProvider<bool>((ref) => false);

final stateRequirementProvider =
    StateProvider<List<NewRequirementModel>>((ref) => []);
final categoryData = Provider((ref) => ContestResponse());
//final loadingProvider = StateProvider<bool>((ref) => false);
final contestNotifierProvider =
    StateNotifierProvider<CreateContestNotifier, ContestState>(
  (ref) {
    // final contestRepository = ref.watch(authRepositoryProvider);
    // final contestNotifierProvider2 = ref.watch(contestControllerProvider);
    // final categoryProvider = ref.watch(categoryData);
    return CreateContestNotifier(ContestRepo(), WayaLocalDataSource());
  },
);

final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

invalidateUGTVm(WidgetRef ref) {
  ref.invalidate(contestNotifierProvider);
  ref.invalidate(stateRequirementProvider);
  ref.invalidate(stateContactProvider);
  ref.read(stateIsEditingContestProvider.notifier).state = false;
}

bool isDateInFuture(String dateString) {
  DateTime givenDate = DateTime.parse(dateString).toUtc(); // Convert to UTC

  DateTime now = DateTime.now().toUtc();

  return givenDate.isAfter(now);
}

bool isPresentIsPast(String dateString) {
  DateTime givenDate = DateTime.parse(dateString).toUtc(); // Convert to UTC

  DateTime now = DateTime.now().toUtc();

  return now.isAfter(givenDate);
}

bool isDateBefore(String dateString) {
  DateTime givenDate = DateTime.parse(dateString).toUtc(); // Convert to UTC

  DateTime now = DateTime.now().toUtc();
  debugPrint("Given Date: $givenDate");
  debugPrint("Now: $now");
  debugPrint("Now: ${givenDate.isBefore(now)}");

  return givenDate.isBefore(now);
}

bool isInPast(String dateString) {
  // Convert the string to a DateTime object
  DateTime inputDate = DateTime.parse(dateString.split("T").first);

  // Get the current date (without time for accurate date-only comparison)
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime oldDate = DateTime(inputDate.year, inputDate.month, inputDate.day);

  // Compare the dates
  debugPrint("Input Date: $inputDate");
  debugPrint("Input Date: $today");
  debugPrint("Input Date: ${oldDate.isBefore(today)}");
  if (oldDate.isBefore(today)) {
    return true;
  }
  return false; /* else if (inputDate.isAtSameMomentAs(today)) {
    debugPrint("The date is today.");
  } else {
    debugPrint("The date is in the future.");
  } */
}

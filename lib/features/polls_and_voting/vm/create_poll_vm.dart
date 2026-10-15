import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/components/modals/error.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/polls_and_voting/data/model/account_type_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/create_poll_response.dart';
import 'package:wayagram/features/polls_and_voting/data/model/get_all_payout_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/payout_commission_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/poll_dashboard.dart';

import 'package:wayagram/features/polls_and_voting/data/model/single_dashboard_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/single_poll_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/vote_url_model.dart';
import 'package:wayagram/features/polls_and_voting/state/create_poll_state.dart';
import 'package:wayagram/features/polls_and_voting/data/model/fetch_all_polls.dart';
import 'package:wayagram/features/polls_and_voting/data/model/model.dart';

import 'package:wayagram/features/polls_and_voting/data/repo/poll_and_voting_repository.dart';
import 'package:wayagram/features/polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';

import '../data/model/get_all_poll_model.dart';

class CreatePollVotingVm extends StateNotifier<CreatePollVotingState> {
  final Ref ref;
  final PollAndVotingRepository _pollAndVotingRepository;
  final ImagePicker _picker;

  final _logger = getLogger('CreatePollVm');
  CreatePollVotingVm(this.ref, this._picker, this._pollAndVotingRepository)
      : super(CreatePollVotingState()) {
    state = state.copyWith(choices: [
      Choice(
          image: null,
          description: TextEditingController(text: ''),
          text: TextEditingController(text: ''))
    ]);

    state = state.copyWith(pollTitle: TextEditingController(text: ''));
    state = state.copyWith(pollDescription: TextEditingController(text: ''));
    state =
        state.copyWith(pollCompanyDescription: TextEditingController(text: ''));
    state = state.copyWith(voteNumber: TextEditingController(text: ''));
    state = state.copyWith(votePrice: TextEditingController(text: ''));
    state = state.copyWith(firstChoice: TextEditingController(text: ''));
    state =
        state.copyWith(firstChoiceDescription: TextEditingController(text: ''));
    state = state.copyWith(secondChoice: TextEditingController(text: ''));
    state = state.copyWith(
        secondChoiceDescription: TextEditingController(text: ''));
  }

  void focusChanged(bool hasFocus) {
    state = state.copyWith(isFocused: hasFocus);
  }

  void selectPollType(String value) {
    state = state.copyWith(pollType: value.toLowerCase());
  }

  void selectStartDate({required String date, required String iso}) {
    state = state.copyWith(startDateString: date, startDate: date);
  }

  void selectEndDate({required String date, required String iso}) {
    state = state.copyWith(endDateString: date, endDate: date);
  }

  void addChoice() {
    List<Choice> allChoices = [];
    allChoices = List.from(state.choices);

    allChoices.add(Choice(
        image: null,
        description: TextEditingController(text: ''),
        text: TextEditingController(text: '')));

    state = state.copyWith(choices: allChoices);
  }

  void removeChoice(int index) {
    List<Choice> allChoices = [];
    allChoices = List.from(state.choices);

    allChoices.removeAt(index);

    state = state.copyWith(choices: allChoices);
  }

  void reset() {
    state = CreatePollVotingState();
  }

  Future<void> showDatePickerDialog(BuildContext context) async {
    try {
      final response = await showDatePicker(
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime.now(),
          initialDate: DateTime.now());

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

  Future<void> showDatePickerDialogTwo(BuildContext context) async {
    try {
      final response = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2026),
        initialDate: DateTime.now(),
      );

      if (response != null) {
        final endDate = "${response.year}-${response.month}-${response.day}";
        final dateIsoFormat = response.toIso8601String();
        state = state.copyWith(endDate: endDate, dateIsoFormat: dateIsoFormat);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

// i feel we should create a single uploadimage function here
// state = state.copyWith(candidateImage: file);
  Future<File?> uploadImage() async {
    return await _picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        File file = File(value.path);
        return file;
      } else {
        return null;
      }
    });
  }

// added fn to remove a choice
  void removeChoiceAtindex(int i) {
    List<Choice> allChoices = [];
    allChoices = List.from(state.choices);

    allChoices.remove(allChoices[i]);
  }

  void addChoiceImage(int i) async {
    File? image = await uploadImage();
    List<Choice> allChoices = [];
    allChoices = List.from(state.choices);
    if (image != null && i >= 0 && i < allChoices.length) {
      allChoices[i] =
          allChoices[i].copyWith(image: image); // Update the image at index i
    }
    state = state.copyWith(choices: allChoices);
  }

  List<Select> restructuredPollType() {
    return pollTypes.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(), label: entries.value.pollType);
    }).toList();
  }

  void update(Select value, String name) {
    switch (name) {
      case "pollType":
        state = state.copyWith(pollType: value.value);
      case "startDate":
        state = state.copyWith(startDate: value.value);
      case "endDate":
        state = state.copyWith(endDate: value.value);
      default:
        state = state.copyWith(dateIsoFormat: value.value);
    }
  }

  bool _isStartDateAfterEndDate(String startDate, String endDate) {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);

    return start.isAfter(end);
  }

  @override
  dispose() {
    state.firstChoice.dispose();
    state.firstChoiceDescription.dispose();
    state.pollTitle.dispose();
    state.pollDescription.dispose();
    state.pollCompanyDescription.dispose();
    state.voteNumber.dispose();
    state.votePrice.dispose();
    super.dispose();
  }

  Future<void> createFreePoll(
      BuildContext context,
      String question,
      String startDate,
      String endDate,
      String maxVotes,
      String choiceText,
      String description,
      String feePerVote,
      String pollType,
      String desc) async {
    //final List<Map<String, dynamic>> choices = [];

    final Map<String, dynamic> choiceMap = {};

    for (var i = 0; i < state.choices.length; i++) {
      choiceMap["choices[$i][text]"] = state.choices[i].text.text;
      choiceMap["choices[$i][image]"] = state.choices[i].image != null
          ? await MultipartFile.fromFile(state.choices[i].image!.path,
              contentType: MediaType.parse('image/*'))
          : null;

      ///choiceMap["choices[$i].image"] = await MultipartFile.fromFile(state.choices[i].image!.path, contentType: MediaType.parse('image/*'));
      choiceMap["choices[$i][description]"] = state.choices[i].description.text;
    }

    final formdata = {
      'question': question,
      'startDate': startDate,
      'endDate': endDate,
      'description': desc,
      //'feePerVote': feePerVote,
      'maxVotesPerUser': maxVotes,
      //'ispaid': true,
      'pollType': pollType,

      ...choiceMap
    };

    try {
      // validate date
      if (_isStartDateAfterEndDate(state.startDate, state.endDate)) {
        WayaSnackBar.showToast("Start date must be before the end date");
        return;
      }

      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.createPoll(formdata);
      if (response.success && context.mounted) {
        CreatePollResponse createPollResponse =
            CreatePollResponse.fromJson(response.data);
        await getAllPolls(page: 1);
        await getMyPolls(page: 1);
        if (!context.mounted) return;
        if (response.success) {
          WayaUtils.showModalSheet(
            context,
            child: PollsModal(url: '${createPollResponse.data!.url}'),
          );
        } else {
          WayaUtils.showModalSheet(context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> createPoll(
      BuildContext context,
      String question,
      String startDate,
      String endDate,
      String maxVotes,
      String choiceText,
      String description,
      String feePerVote,
      String pollType,
      String desc) async {
    //final List<Map<String, dynamic>> choices = [];

    final Map<String, dynamic> choiceMap = {};

    for (var i = 0; i < state.choices.length; i++) {
      choiceMap["choices[$i][text]"] = state.choices[i].text.text;
      choiceMap["choices[$i][image]"] = state.choices[i].image != null
          ? await MultipartFile.fromFile(state.choices[i].image!.path,
              contentType: MediaType.parse('image/*'))
          : null;

      ///choiceMap["choices[$i].image"] = await MultipartFile.fromFile(state.choices[i].image!.path, contentType: MediaType.parse('image/*'));
      choiceMap["choices[$i][description]"] = state.choices[i].description.text;
    }

    final formdata = {
      'question': question,
      'startDate': startDate,
      'endDate': endDate,
      'feePerVote': feePerVote,
      'maxVotesPerUser': maxVotes,
      'description': desc,
      //'ispaid': true,
      'pollType': pollType,
      ...choiceMap
    };

    try {
      // validate date
      if (_isStartDateAfterEndDate(state.startDate, state.endDate)) {
        WayaSnackBar.showToast("Start date must be before the end date");
        return;
      }

      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.createPoll(formdata);
      if (response.success) {
        await getAllPolls(page: 1);
        await getMyPolls(page: 1);
        if (!context.mounted) return;
        showDialog(
            useRootNavigator: false,
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return PaymentDialog();
            });
      } else {
        if (context.mounted) {
          WayaUtils.showModalSheet(context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> castYourVote(String amountPaid, String qty, String choiceId,
      String pollId, ctx, candidateName, votingLink) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.castVote(
          amountPaid, qty, choiceId, pollId);
      state = state.copyWith(isLoading: false);
      if (response.success && ctx.mounted) {
        await getAllPolls(page: 1);
        WayaNav.goBack();
        WayaUtils.showModalSheet(
          ctx,
          child: VoteSuccessModal(
            candidateName: candidateName,
            votingLink: votingLink,
            pollId: pollId,
          ),
        );

        _logger.i(response.data['data']);
      } else if (response.data['responseCode'] == 1620) {
        WayaUtils.showModalSheet(ctx, child: VoteInsufficientModal());
      } else {
        if (ctx.mounted) {
          WayaUtils.showModalSheet(ctx,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.polls,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> verifyWalletPin(String pin, ctx) async {
    final response = await _pollAndVotingRepository.confirmWalletPin(
        ConfirmWalletPin(userId: ConversationState.self.id, pin: pin));
    if (response.success) {
      return true;
    } else if (response.data['error'] == 'User hasn\'t set wallet pin yet') {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            'Kindly set your wallet pin',
            style: TextStyle(
                fontFamily: WayaConstants.fontFamily, fontSize: 12.sp),
          ),
          backgroundColor: WayaColors.primary,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      return false;
    }
    return false;
  }

  Future<void> castFreeVote(num qty, String choiceId, String pollId, ctx,
      candidateName, votingLink) async {
    try {
      //state = state.copyWith(isLoading: true);
      final response =
          await _pollAndVotingRepository.castFreeVote(qty, choiceId, pollId);
      state = state.copyWith(isLoading: false);
      if (response.success && ctx.mounted) {
        await getAllPolls(page: 1);
        await WayaUtils.showModalSheet(
          ctx,
          child: VoteSuccessModalTwo(
            candidateName: candidateName,
            votingLink: votingLink,
            pollId: pollId,
          ),
        );

        _logger.i(response.data['data']);
      } else if (response.data['responseCode'] == 1620) {
        WayaUtils.showModalSheet(ctx, child: VoteInsufficientModal());
      } else {
        if (ctx.mounted) {
          WayaUtils.showModalSheet(ctx,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.polls,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchAccountType() async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.getAccountType();
      state = state.copyWith(isLoading: false);

      if (response.success) {
        AccountTypeModel responseModel =
            AccountTypeModel.fromJson(response.data);
        state = state.copyWith(accountType: responseModel.data?[0].name);
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  Future<void> getActivePolls(int page) async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.getActivePolls(
          ConversationState.self.id, page);
      state = state.copyWith(isLoading: false);

      if (response.success) {
        FetchAllPolls responseModel = FetchAllPolls.fromJson(response.data);
        state = state.copyWith(fetchAllPols: responseModel.data?.docs);
        state = state.copyWith(activePolls: responseModel.data?.docs);
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  Future<void> getInActivePolls(int page) async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.getInActivePolls(
          ConversationState.self.id, page);
      state = state.copyWith(isLoading: false);

      if (response.success) {
        FetchAllPolls responseModel = FetchAllPolls.fromJson(response.data);
        state = state.copyWith(fetchAllPols: responseModel.data?.docs);
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  Future<void> deletePoll(BuildContext ctx, {required String postId}) async {
    try {
      final response = await _pollAndVotingRepository.deletePoll(postId);
      if (response.success && ctx.mounted) {
        getMyPolls(
          page: 1,
        );
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              'Poll deleted successfully!',
              style: TextStyle(
                  fontFamily: WayaConstants.fontFamily, fontSize: 12.sp),
            ),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        if (ctx.mounted) {
          WayaUtils.showModalSheet(ctx,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<PaginatedResult<Docs>?> getMyPolls({required int page}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.getMyPolls(
          ConversationState.self.id, page);
      List<Docs>? fetchAllPols = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        FetchAllPolls responseModel = FetchAllPolls.fromJson(response.data);
        fetchAllPols = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(fetchAllPols: fetchAllPols);
        state = state.copyWith(fetchAllPols: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items: fetchAllPols!);
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.polls,
        WayaDebugHelpers.getStackTrace(e),
      );
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> requestSettlement(BuildContext ctx, String pollId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.requestSettlement(pollId);
      state = state.copyWith(isLoading: false);
      if (response.success && ctx.mounted) {
        WayaNav.toNamed('/pollRequestPayout');
        //WayaNav.removeUntilNamed(BottomView.route, arguments: 0);
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Payout request was sent successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        if (ctx.mounted) {
          WayaUtils.showModalSheet(ctx,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
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

  Future<void> getAllRequestPayout(int page) async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.getAllRequestPayout(page);
      state = state.copyWith(isLoading: false);

      if (response.success) {
        FetchAllPolls responseModel = FetchAllPolls.fromJson(response.data);
        state = state.copyWith(fetchAllPols: responseModel.data?.docs);
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  Future<PaginatedResult<Docs>?> getAllPolls({required int page}) async {
    try {
      //state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.getAllPolls(page);
      List<Docs>? fetchAllPols = [];
      bool? hasNextPage = false;
      if (response.success) {
        FetchAllPolls responseModel = FetchAllPolls.fromJson(response.data);
        fetchAllPols = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(fetchAllPols: fetchAllPols);
        state = state.copyWith(fetchAllPols: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items: fetchAllPols!);
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.polls,
        WayaDebugHelpers.getStackTrace(e),
      );
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getAllPendingPolls(int page) async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.getAllPendingPolls(
          page, ConversationState.self.id);
      state = state.copyWith(isLoading: false);

      if (response.success) {
        FetchAllPolls responseModel = FetchAllPolls.fromJson(response.data);
        state = state.copyWith(fetchAllPols: responseModel.data?.docs);
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  Future<void> getPollsByUrl(String pollUrl) async {
    state = state.copyWith(isLoading: true);
    final response = await _pollAndVotingRepository.getAPollsByUrl(pollUrl);
    state = state.copyWith(isLoading: false);
    if (response.statusCode == 200) {
      VoteUrlModel responseModel = VoteUrlModel.fromJson(response.data);
      _logger.i('GENERATED ${responseModel.data}');

      state = state.copyWith(voteUrlData: responseModel.data
          //voteUrlChoices: responseModel.data?.choices
          );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<GetAllPollModel?> getPrivatePollsById(String pollId) async {
    state = state.copyWith(isLoading: true);
    final response = await _pollAndVotingRepository.getPrivatePollsById(pollId);
    state = state.copyWith(isLoading: false);
    if (response.statusCode == 200) {
      SinglePollModel responseModel = SinglePollModel.fromJson(response.data);
      _logger.i('GENERATED ${responseModel.data}');

      state = state.copyWith(
          singlePollChoices: responseModel.data?.choices,
          desc: responseModel.data?.description,
          question: responseModel.data?.question,
          fName: responseModel.data?.userData?.firstName,
          lName: responseModel.data?.userData?.lastName,
          picture: responseModel.data?.userData?.profilePicture,
          startDate: responseModel.data?.startDate,
          endDate: responseModel.data?.endDate,
          pollUrl: responseModel.data?.url,
          pollId: responseModel.data?.id,
          voteCount: '${responseModel.data?.voteCount}',
          hoursLeft:
              '${DateTime.parse('${responseModel.data?.endDate}').difference(DateTime.parse('${responseModel.data?.startDate}')).inDays}');
    } else {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<GetAllPollModel?> getPublicPollsById(String pollId) async {
    state = state.copyWith(isLoading: true);
    final response = await _pollAndVotingRepository.getPublicPollsById(pollId);
    state = state.copyWith(isLoading: false);
    if (response.statusCode == 200) {
      SinglePollModel responseModel = SinglePollModel.fromJson(response.data);
      _logger.i('GENERATED ${responseModel.data}');

      state = state.copyWith(
          singlePollChoices: responseModel.data?.choices,
          desc: responseModel.data?.description,
          question: responseModel.data?.question,
          fName: responseModel.data?.userData?.firstName,
          lName: responseModel.data?.userData?.lastName,
          picture: responseModel.data?.userData?.profilePicture,
          startDate: responseModel.data?.startDate,
          endDate: responseModel.data?.endDate,
          pollUrl: responseModel.data?.url,
          pollId: responseModel.data?.id,
          voteCount: '${responseModel.data?.voteCount}',
          hoursLeft:
              '${DateTime.parse('${responseModel.data?.endDate}').difference(DateTime.parse('${responseModel.data?.startDate}')).inDays}');
    } else {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<void> getSinglePollDashboard(String pollId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.getDashboardPolls(pollId);
      state = state.copyWith(isLoading: false);

      if (response.success) {
        SingleDashboardModel responseModel =
            SingleDashboardModel.fromJson(response.data);

        state = state.copyWith(
            votes: responseModel.data?.votes,
            voteCount: responseModel.data?.voteCount.toString(),
            moneyGenerated: responseModel.data?.moneyGenerated.toString(),
            numberOfPeopleVoted:
                responseModel.data?.numberOfPeopleVoted.toString());
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.polls,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {}
  }

  Future<void> getDashboard(String pollId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.getDashboard(pollId);
      state = state.copyWith(isLoading: false);

      if (response.success) {
        PollDashboardModel responseModel =
            PollDashboardModel.fromJson(response.data);
        state = state.copyWith(
            pollDashboardChoices: responseModel.data?.docs?[0].choices,
            voteCount: responseModel.data?.docs?[0].voteCount.toString(),
            moneyGenerated: responseModel.data?.docs?[0].amountGenerated,
            numberOfPeopleVoted:
                responseModel.data?.docs?[0].numberOfVoters.toString());
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.polls,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {}
  }

  Future<void> getPayoutCommission() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.getPayoutCommission();
      state = state.copyWith(isLoading: false);

      if (response.success) {
        PayoutCommissionModel responseModel =
            PayoutCommissionModel.fromJson(response.data);
        state = state.copyWith(commission: responseModel.data?.docs?[2].rate);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.polls,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {}
  }

  Future<void> getPollPayoutRequest() async {
    try {
      final response = await _pollAndVotingRepository.getPollPayoutRequest();

      if (response.success) {
        GetAllPayoutModel responseModel =
            GetAllPayoutModel.fromJson(response.data);

        state = state.copyWith(
          pollPayoutDocs: responseModel.data?.docs,
        );
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.polls,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

  Future<void> getFeedPolls() async {
    try {
      final response = await _pollAndVotingRepository.getAllFeedPolls();

      if (response.success) {
        FetchAllPolls responseModel = FetchAllPolls.fromJson(response.data);

        state = state.copyWith(feedPolls: responseModel.data?.docs);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.polls,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

  Future<Docs?> getPollById(String id) async {
    try {
      final response = await _pollAndVotingRepository.getSinglePollById(id: id);
      Docs? poll;
      if (response.success) {
        poll = Docs.fromJson(response.data['data']);
      }

      return poll;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }
}

final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

final createPollVotingProvider = StateNotifierProvider.autoDispose<
    CreatePollVotingVm, CreatePollVotingState>((ref) {
  final pollAndVotingRepository = ref.watch(pollAndVotingRepositoryProvider);
  return CreatePollVotingVm(ref, ImagePicker(), pollAndVotingRepository);
});

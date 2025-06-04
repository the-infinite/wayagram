import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/polls_and_voting/data/model/create_poll_response.dart';
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

  bool isDateBefore(String dateString) {
    DateTime givenDate = DateTime.parse(dateString).toUtc(); // Convert to UTC

    DateTime now = DateTime.now().toUtc();
    debugPrint("Given Date: $givenDate");
    debugPrint("Now: $now");
    debugPrint("Now: ${givenDate.isBefore(now)}");

    return givenDate.isBefore(now);
  }

  bool isStartDateAfterEndDate(String startDate, String endDate) {
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

  formatDate(String inputDate) {
    // Parse the input date string
    DateTime parsedDate = DateTime.parse(inputDate);

    // Get the day, month, and year
    int day = parsedDate.day;
    String month = DateFormat('MMMM').format(parsedDate);
    int year = parsedDate.year;

    // Determine the suffix for the day
    String suffix;
    if (day >= 11 && day <= 13) {
      suffix = 'th'; // Special case for 11th, 12th, 13th
    } else {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
      }
    }

    // Return the formatted date string
    return '$day$suffix of $month, $year';
  }

  static getMonthName(String mon) {
    var def = '';
    if (mon == '01' || mon == '1') {
      def = 'January,';
    } else if (mon == '02' || mon == '2') {
      def = 'February,';
    } else if (mon == '03' || mon == '3') {
      def = 'March,';
    } else if (mon == '04' || mon == '4') {
      def = 'April,';
    } else if (mon == '05' || mon == '5') {
      def = 'May,';
    } else if (mon == '06' || mon == '6') {
      def = 'June,';
    } else if (mon == '07' || mon == '7') {
      def = 'July,';
    } else if (mon == '08' || mon == '8') {
      def = 'August,';
    } else if (mon == '09' || mon == '9') {
      def = 'September,';
    } else if (mon == '10') {
      def = 'October,';
    } else if (mon == '11') {
      def = 'November,';
    } else if (mon == '12') {
      def = 'December,';
    }
    return def;
  }

  static getMonthNameMini(String mon) {
    var def = '';
    if (mon == '01' || mon == '1') {
      def = 'Jan';
    } else if (mon == '02' || mon == '2') {
      def = 'Feb';
    } else if (mon == '03' || mon == '3') {
      def = 'Mar';
    } else if (mon == '04' || mon == '4') {
      def = 'Apr';
    } else if (mon == '05' || mon == '5') {
      def = 'May';
    } else if (mon == '06' || mon == '6') {
      def = 'Jun';
    } else if (mon == '07' || mon == '7') {
      def = 'Jul';
    } else if (mon == '08' || mon == '8') {
      def = 'Aug';
    } else if (mon == '09' || mon == '9') {
      def = 'Sep';
    } else if (mon == '10') {
      def = 'Oct';
    } else if (mon == '11') {
      def = 'Nov';
    } else if (mon == '12') {
      def = 'Dec';
    }
    return def;
  }

  static getDayAbbreviation(String day) {
    var def = '';
    if (day == '01' || day == '1') {
      def = '1st';
    } else if (day == '02' || day == '2') {
      def = '2nd';
    } else if (day == '03' || day == '3') {
      def = '3rd';
    } else if (day == '04' || day == '4') {
      def = '4th';
    } else if (day == '05' || day == '5') {
      def = '5th';
    } else if (day == '06' || day == '6') {
      def = '6th';
    } else if (day == '07' || day == '7') {
      def = '7th';
    } else if (day == '08' || day == '8') {
      def = '8th';
    } else if (day == '09' || day == '9') {
      def = '9th';
    } else if (day == '10') {
      def = '10th';
    } else if (day == '21') {
      def = '21st';
    } else if (day == '22') {
      def = '22nd';
    } else if (day == '23') {
      def = '23rd';
    } else if (day == '31') {
      def = '31st';
    } else {
      def = '${day}th';
    }
    return def;
  }

  formatDt(j) {
    String dt = '';
    if (j != null) {
      if (j.contains('-')) {
        String a = j.split('-')[0];
        String b = j.split('-')[1];
        String c = j.split('-')[2];

        dt = '${getDayAbbreviation(c)} ${getMonthNameMini(b)} $a';
      } else {
        dt = j;
      }
    }
    return dt;
  }

  formatDonationDate(j) {
    String dt = '';
    if (j != null) {
      if (j.toString().contains('T')) {
        String x = j.toString().split('T')[0];
        if (x.contains('-')) {
          String a = x.split('-')[0];
          String b = x.split('-')[1];
          String c = x.split('-')[2];

          dt = '${getDayAbbreviation(c)} ${getMonthName(b)}\n$a';
        } else {
          dt = x;
        }
      } else {
        dt = j;
      }
    }
    return dt;
  }

  formatDt1(j) {
    String dt = '';
    if (j != null) {
      if (j.toString().contains('T')) {
        String x = j.toString().split('T')[0];
        if (x.contains('-')) {
          String a = x.split('-')[0];
          String b = x.split('-')[1];
          String c = x.split('-')[2];

          dt = '${getDayAbbreviation(c)} ${getMonthName(b)} $a';
        } else {
          dt = x;
        }
      } else {
        dt = j;
      }
    }
    return dt;
  }

  formatDt2(j) {
    String dt = '';
    if (j != null) {
      if (j.toString().contains('T')) {
        String x = j.toString().split('T')[0];
        if (x.contains('-')) {
          String a = x.split('-')[0];
          String b = x.split('-')[1];
          String c = x.split('-')[2];

          dt = '${getMonthNameMini(b)} ${getDayAbbreviation(c)}, $a';
        } else {
          dt = x;
        }
      } else {
        dt = j;
      }
    }
    return dt;
  }

  formatAm(j) {
    String am = '';
    if (j != '' && j != null) {
      if (j == '0') {
        am = j;
      } else {
        j = j.toString().replaceAll(' ', '').replaceAll(',', '');
        if (j.toString().contains('.')) {
          j = (double.parse(j)).toStringAsFixed(2);
          if (j.toString().split('.')[0].length == 4) {
            String a = j.toString().substring(0, 1);
            String b = j.toString().substring(1, 4);
            am = '$a,$b.${j.toString().split('.')[1]}';
          } else if (j.toString().split('.')[0].length == 5) {
            String a = j.toString().substring(0, 2);
            String b = j.toString().substring(2, 5);
            am = '$a,$b.${j.toString().split('.')[1]}';
          } else if (j.toString().split('.')[0].length == 6) {
            String a = j.toString().substring(0, 3);
            String b = j.toString().substring(3, 6);
            am = '$a,$b.${j.toString().split('.')[1]}';
          } else if (j.toString().split('.')[0].length == 7) {
            String a = j.toString().substring(0, 1);
            String b = j.toString().substring(1, 4);
            String c = j.toString().substring(4, 7);
            am = '$a,$b,$c.${j.toString().split('.')[1]}';
          } else if (j.toString().split('.')[0].length == 8) {
            String a = j.toString().substring(0, 3);
            String b = j.toString().substring(3, 5);
            String c = j.toString().substring(5, 8);
            am = '$a,$b,$c.${j.toString().split('.')[1]}';
          } else if (j.toString().split('.')[0].length == 9) {
            String a = j.toString().substring(0, 3);
            String b = j.toString().substring(3, 6);
            String c = j.toString().substring(6, 9);
            am = '$a,$b,$c.${j.toString().split('.')[1]}';
          } else if (j.toString().split('.')[0].length == 10) {
            String a = j.toString().substring(0, 1);
            String b = j.toString().substring(1, 4);
            String c = j.toString().substring(4, 7);
            String d = j.toString().substring(7, 10);
            am = '$a,$b,$c,$d.${j.toString().split('.')[1]}';
          } else if (j.toString().split('.')[0].length == 11) {
            String a = j.toString().substring(0, 2);
            String b = j.toString().substring(2, 5);
            String c = j.toString().substring(5, 8);
            String d = j.toString().substring(8, 11);
            am = '$a,$b,$c,$d.${j.toString().split('.')[1]}';
          } else if (j.toString().split('.')[0].length == 12) {
            String a = j.toString().substring(0, 3);
            String b = j.toString().substring(3, 6);
            String c = j.toString().substring(6, 9);
            String d = j.toString().substring(9, 12);
            am = '$a,$b,$c,$d.${j.toString().split('.')[1]}';
          } else {
            am = j;
          }
        } else {
          if (j.toString().length == 4) {
            String a = j.toString().substring(0, 1);
            String b = j.toString().substring(1, 4);
            am = '$a,$b';
          } else if (j.toString().length == 5) {
            String a = j.toString().substring(0, 2);
            String b = j.toString().substring(2, 5);
            am = '$a,$b';
          } else if (j.toString().length == 6) {
            String a = j.toString().substring(0, 3);
            String b = j.toString().substring(3, 6);
            am = '$a,$b';
          } else if (j.toString().length == 7) {
            String a = j.toString().substring(0, 1);
            String b = j.toString().substring(1, 4);
            String c = j.toString().substring(4, 7);
            am = '$a,$b,$c';
          } else if (j.toString().length == 8) {
            String a = j.toString().substring(0, 2);
            String b = j.toString().substring(2, 5);
            String c = j.toString().substring(5, 8);
            am = '$a,$b,$c';
          } else if (j.toString().length == 9) {
            String a = j.toString().substring(0, 3);
            String b = j.toString().substring(3, 6);
            String c = j.toString().substring(6, 9);
            am = '$a,$b,$c';
          } else if (j.toString().length == 10) {
            String a = j.toString().substring(0, 1);
            String b = j.toString().substring(1, 4);
            String c = j.toString().substring(4, 7);
            String d = j.toString().substring(7, 10);
            am = '$a,$b,$c,$d';
          } else if (j.toString().length == 11) {
            String a = j.toString().substring(0, 2);
            String b = j.toString().substring(2, 5);
            String c = j.toString().substring(5, 8);
            String d = j.toString().substring(8, 11);
            am = '$a,$b,$c,$d';
          } else if (j.toString().length == 12) {
            String a = j.toString().substring(0, 3);
            String b = j.toString().substring(3, 6);
            String c = j.toString().substring(6, 9);
            String d = j.toString().substring(9, 12);
            am = '$a,$b,$c,$d';
          } else {
            am = j;
          }
        }
      }
    }

    return am;
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
      if (isStartDateAfterEndDate(state.startDate, state.endDate)) {
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
        WayaUtils.showModalSheet(
          context,
          child: PollsModal(url: '${createPollResponse.data!.url}'),
        );
        // showDialog(
        //     useRootNavigator: false,
        //     context: context,
        //     barrierDismissible: false,
        //     builder: (BuildContext context) {
        //       return PaymentDialog();
        //     });
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
      if (isStartDateAfterEndDate(state.startDate, state.endDate)) {
        WayaSnackBar.showToast("Start date must be before the end date");
        return;
      }

      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.createPoll(formdata);
      if (response.success && context.mounted) {
        await getAllPolls(page: 1);
        await getMyPolls(page: 1);
        showDialog(
            useRootNavigator: false,
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return PaymentDialog();
            });
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
        //WayaNav.goBack();
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

  Future<void> getActivePolls(int page) async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.getActivePolls(
          ConversationState.self.id, page);
      state = state.copyWith(isLoading: false);
      debugPrint('API Response: ${response.data}');
      debugPrint('Status Code: ${response.statusCode}');

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
      debugPrint('API Response: ${response.data}');
      debugPrint('Status Code: ${response.statusCode}');

      if (response.success) {
        FetchAllPolls responseModel = FetchAllPolls.fromJson(response.data);
        state = state.copyWith(fetchAllPols: responseModel.data?.docs);
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  Future<void> deletePoll(ctx, {required String postId}) async {
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

  Future<void> requestSettlement(ctx, String pollId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.requestSettlement(pollId);
      state = state.copyWith(isLoading: false);
      if (response.success && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Request was sent successfully!'),
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

  Future<void> getAllRequestPayout(int page) async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.getAllRequestPayout(page);
      state = state.copyWith(isLoading: false);
      debugPrint('API Response: ${response.data}');
      debugPrint('Status Code: ${response.statusCode}');

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
      final response = await _pollAndVotingRepository.getAllPendingPolls(page, ConversationState.self.id);
      state = state.copyWith(isLoading: false);
      debugPrint('API Response: ${response.data}');
      debugPrint('Status Code: ${response.statusCode}');

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

  Future<GetAllPollModel?> getPollsById(String pollId) async {
    state = state.copyWith(isLoading: true);
    final response = await _pollAndVotingRepository.getAllPollsById(pollId);
    state = state.copyWith(isLoading: false);
    if (response.statusCode == 200) {
      SinglePollModel responseModel = SinglePollModel.fromJson(response.data);
      _logger.i('GENERATED ${responseModel.data}');

      state = state.copyWith(singlePollModelDocs: responseModel.data?.docs);
    } else {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<void> getSinglePollDashboard(pollId) async {
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

  Future<void> getDashboard(pollId) async {
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

final pollAndVotingProvider = Provider((ref) => PollAndVotingRepository());
final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

final createPollVotingProvider = StateNotifierProvider.autoDispose<
    CreatePollVotingVm, CreatePollVotingState>((ref) {
  final pollAndVotingRepository = ref.watch(pollAndVotingProvider);
  return CreatePollVotingVm(ref, ImagePicker(), pollAndVotingRepository);
});

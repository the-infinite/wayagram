import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/bottom_view/bottom_view.dart';
import 'package:wayagram/features/polls_and_voting/data/model/create_poll_state_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/get_my_poll.dart';
import 'package:wayagram/features/polls_and_voting/data/model/get_poll_model.dart';
import 'package:wayagram/features/polls_and_voting/data/model/model.dart';

import 'package:wayagram/features/polls_and_voting/data/repo/poll_and_voting_repository.dart';


class CreatePollVotingVm extends StateNotifier<CreatePollVotingState> {
  final Ref ref;
  final PollAndVotingRepository _pollAndVotingRepository;
  final WayaLocalDataSource _localDataSource;
  final WayaSecureDataSource _secureDataSource;
  final ImagePicker _picker;

  final _logger = getLogger('CreatePollVm');
  CreatePollVotingVm(this.ref, this._picker, this._pollAndVotingRepository,
      this._localDataSource, this._secureDataSource)
      : super(CreatePollVotingState()) {
    state = state.copyWith(choices: [
      Choice(
          image: null,
          description: TextEditingController(text: ''),
          text: TextEditingController(text: ''))
    ]);
  }

  void focusChanged(bool hasFocus) {
    state = state.copyWith(isFocused: hasFocus);
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

  Future<void> showDatePickerDialog(BuildContext context) async {
    try {
      final response = await showDatePicker(
          context: context,
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          initialDate: DateTime.now());

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

  Future<void> showDatePickerDialogTwo(BuildContext context) async {
    try {
      final response = await showDatePicker(
          context: context,
          firstDate: DateTime(1950),
          lastDate: DateTime(2026),
          initialDate: DateTime.now());

      if (response != null) {
        final endDate = "${response.year}-${response.month}-${response.day}";
        final dateIsoFormat = response.toIso8601String();
        state = state.copyWith(endDate: endDate, dateIsoFormat: dateIsoFormat);
      }
    } catch (error) {
      print(error);
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

  @override
  void dispose() {
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

  formatDt1(j) {
    String dt = '';
    if(j != null){
      if(j.toString().contains('T')){
        String x = j.toString().split('T')[0];
        if(x.contains('-')){
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



  Future<void> createPoll(
      BuildContext context,
      String question,
      String startDate,
      String endDate,
      String maxVotes,
      String choiceText,
      String description) async {
    Future<MultipartFile> formattedImage(File file) async {
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

      return await MultipartFile.fromFile(
        file.path,
        filename: file.uri.pathSegments.last,
        contentType: MediaType.parse(mimeType),
      );
    }

    //final List<Map<String, dynamic>> choices = [];


    final Map<String, dynamic> choiceMap = {};

    for (var i = 0; i < state.choices.length; i++) {
      choiceMap["choices[$i].text"] = state.choices[i].text.text;
      choiceMap["choices[$i].image"] = state.choices[i].image; // convert this to multipartfile
      choiceMap["choices[$i].description"] = state.choices[i].description.text;
    }

    final formdata = {
      'question': question,
      'startDate': startDate,
      'endDate': endDate,
      'maxVotesPerUser': maxVotes,
      'ispaid': true,
      ...choiceMap
    };

    try {
      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.createPoll(formdata);
      if (response.data['statusCode'] == 200 ||
          response.data['statusCode'] == 200 && context.mounted) {
        WayaUtils.showNotice(
            context: context,
            title: 'Payment information',
            message:
                'Your documents are under review. We’ll notify you once the \n verification process is complete',
            onPress: () => WayaNav.toNamed("/explore"),
            icon: Image.asset('assets/images/auth/doc-success.png'),
            buttonText: 'Go To HomePage');
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> castYourVote(
      String amountPaid, String qty, String choiceId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response =
          await _pollAndVotingRepository.castVote(amountPaid, qty, choiceId);
      state = state.copyWith(isLoading: false);
      if (response.success) {
        _logger.i(response.data['data']);
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getMyPolls(String creatorId) async {
    state = state.copyWith(isLoading: true);
    final response = await _pollAndVotingRepository.getMyPolls(creatorId);
    state = state.copyWith(isLoading: false);
    if (response.success) {
      GetMyPoll responseModel = GetMyPoll.fromJson(response.data);

      state = state.copyWith(getMyPollModel: responseModel.data);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getAllPolls() async {
    state = state.copyWith(isLoading: true);
    final response = await _pollAndVotingRepository.getAllPolls();
    state = state.copyWith(isLoading: false);
    if (response.success) {
      GetPollModel responseModel = GetPollModel.fromJson(response.data);

      state = state.copyWith(getPollModel: responseModel.data);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getDashboardPoll() async {
    print('VOTE IDEntity ${ref.read(createPollVotingProvider).castVoteModel[0].pollId}');
    final id = ref.read(createPollVotingProvider).castVoteModel[0].pollId;

    state = state.copyWith(isLoading: true);
    final response = await _pollAndVotingRepository.getDashboardPolls(id!);
    state = state.copyWith(isLoading: false);
    // if (response.statusCode == 200) {
    //   PollDashboardModel responseModel = PollDashboardModel.fromJson(response.data);
    //
    //   state = state.copyWith(pollDashboardModel: responseModel.votes);
    // } else {
    //   state = state.copyWith(isLoading: false);
    // }
  }

  void submit(BuildContext context, bool isWayagramDeal) async {
    //final addProductData = ref.watch(addProductProvider.notifier);

    if (isWayagramDeal) {
      // print("$addProductData");
      WayaUtils.showNotice(
          context: context,
          title: "Your Application has been submitted Successfully! 🎉",
          message:
              "Your product has been submitted. We'll notify you \n once it's reviewed.",
          onPress: () => WayaNav.toNamed('/wayagram-deal'),
          icon: Image.asset('assets/images/shop/add-product-success.png'),
          buttonText: 'View Application Status',
          secondButtonText: 'Go to Dashboard',
          onCancel: () => WayaNav.toNamed('/wayagram-deal'));
    } else {
      // print("$addProductData");
      WayaUtils.showNotice(
        context: context,
        title: "Product Added Successfully! 🎉",
        message:
            "Your product is now live in your shop and ready \n for customers to discover.",
        onPress: () => WayaNav.toNamed('/add-product'),
        icon: Image.asset('assets/images/shop/add-product-success.png'),
        buttonText: 'Add Another Product',
        secondButtonText: 'Go to Dashboard',
        onCancel: () => WayaNav.toNamed(BottomView.route, arguments: 1),
      );
    }
  }
}

// final createPollVotingProvider = StateNotifierProvider<CreatePollVotingVm, CreatePollVotingState>(
//         (ref,) => CreatePollVotingVm(ref));

final pollAndVotingProvider = Provider((ref) => PollAndVotingRepository());
final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

final createPollVotingProvider =
    StateNotifierProvider<CreatePollVotingVm, CreatePollVotingState>((ref) {
  final pollAndVotingRepository = ref.watch(pollAndVotingProvider);
  final localDataSource = ref.watch(localDataSourceProvider);

  return CreatePollVotingVm(ref, ImagePicker(), pollAndVotingRepository,
      localDataSource, WayaSecureDataSource());
});


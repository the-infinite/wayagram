import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
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
  //final Ref ref;
  final PollAndVotingRepository _pollAndVotingRepository;
  final WayaLocalDataSource _localDataSource;
  final WayaSecureDataSource _secureDataSource;

  final _logger = getLogger('CreatePollVm');
  CreatePollVotingVm(this._pollAndVotingRepository, this._localDataSource, this._secureDataSource) : super(CreatePollVotingState());
  final ImagePicker _picker = ImagePicker();

  void focusChanged(bool hasFocus) {
    state = state.copyWith(isFocused: hasFocus);
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
        state = state.copyWith(startDate: startDate, dateIsoFormat: dateIsoFormat);
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

  void uploadImage() {
    _picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        File file = File(value.path);
        state = state.copyWith(candidateImage: file);
      }
    });
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
        //state = state.copyWith(productColor: value.value);
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

  Future<void> createPoll(BuildContext context, String question,
      String startDate, String endDate, String maxVotes,
      String choiceText, String description) async {
    Future<MultipartFile> formattedImage(File file) async {
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

      return await MultipartFile.fromFile(
        file.path,
        filename: file.uri.pathSegments.last,
        contentType: MediaType.parse(mimeType),
      );
    }

    //final List<Map<String, dynamic>> choices = [];

    final List<Map<String, dynamic>> choices = [
      {"text": "Option 1", "image": "image1.png", "description": "Description 1"},
      {"text": "Option 2", "image": "image2.png", "description": "Description 2"},
      {"text": "Option 3", "image": "image3.png", "description": "Description 3"},
    ];

    final Map<String, String> choiceMap = {};

    for (var i = 0; i < choices.length; i++) {
      choiceMap["choice[$i].text"] = choices[i]['text'];
      choiceMap["choice[$i].image"] = choices[i]['image'];
      choiceMap["choice[$i].description"] = choices[i]['description'];
    }

    /*   int vt = 2;
    bool pd = true;

    String b =  '{question: ''question,'
        'startDate: 2025-01-25T00:00:00.000Z, '
        'endDate: 2025-01-30T00:00:00.000Z,'
        'maxVotesPerUser: $vt,'
        ' ispaid: $pd,choices[0].text: choiceText,'
        'choices[0].description:description'
        '}';
    final formdata = jsonDecode(b);*/
    //final formdata = b;
    final formdata =
        {
          'question': question,
          'startDate': startDate,
          'endDate': endDate,
          'maxVotesPerUser': maxVotes,
          'ispaid': true,
          'choices[0].text': choiceText,
          // 'choices[0].image': await formattedImage(state.uploadedDocuments
          //     .firstWhere((element) => element.type == 'image0')
          //     .file),
          'choices[0].description': description,

    };

    try {
      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.createPoll(formdata);
      if (response.data['statusCode'] == 200 || response.data['statusCode'] == 200 && context.mounted) {
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

  Future<void> castYourVote(String amountPaid, String qty, String choiceId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _pollAndVotingRepository.castVote(amountPaid, qty, choiceId);
      state = state.copyWith(isLoading: false);
      if (response.success ) {
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


final createPollVotingProvider = StateNotifierProvider<CreatePollVotingVm, CreatePollVotingState>((ref){
  final pollAndVotingRepository = ref.watch(pollAndVotingProvider);
  final localDataSource = ref.watch(localDataSourceProvider);

  return CreatePollVotingVm(pollAndVotingRepository, localDataSource, WayaSecureDataSource());
});

class Choice{
  final File? image;
  final String description;
  final String text;

  Choice({required this.image, required this.description, required this.text});

  Choice copyWith({File? image, String? description, String? text}){
    return  Choice(
        image: image ?? this.image,
        description: description ?? this.description,
        text: text ?? this.text);
  }
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/bottom_view/bottom_view.dart';
import 'package:wayagram/features/polls_and_voting/data/model/model.dart';
import 'package:wayagram/features/quotation/data/model/model.dart';



import 'dart:io';



class CreatePollVotingState {
  final TextEditingController pollTitle;
  final TextEditingController pollDescription;
  final TextEditingController pollCompanyDescription;
  final TextEditingController votePrice;
  final TextEditingController voteNumber;
  final TextEditingController firstChoice;
  final TextEditingController secondChoice;
  final TextEditingController firstChoiceDescription;
  final TextEditingController secondChoiceDescription;

  final String startDate;
  final String endDate;
  final String pollType;
  File? productImage;



  CreatePollVotingState({
    TextEditingController? pollTitle,
    TextEditingController? pollDescription,
    TextEditingController? pollCompanyDescription,
    TextEditingController? votePrice,
    TextEditingController? voteNumber,
    TextEditingController? firstChoice,
    TextEditingController? secondChoice,
    TextEditingController? firstChoiceDescription,
    TextEditingController? secondChoiceDescription,
    this.pollType = '',
    this.startDate = '',
    this.endDate = '',

    this.productImage,
  })  : pollTitle = pollTitle ?? TextEditingController(),
        pollDescription = pollDescription ?? TextEditingController(),
        pollCompanyDescription= pollCompanyDescription ?? TextEditingController(),
        votePrice = votePrice ?? TextEditingController(),
        voteNumber = voteNumber ?? TextEditingController(),
        firstChoice = firstChoice ?? TextEditingController(),
        secondChoice = secondChoice ?? TextEditingController(),
        firstChoiceDescription = firstChoiceDescription ?? TextEditingController(),
        secondChoiceDescription = secondChoiceDescription ?? TextEditingController();

  CreatePollVotingState copyWith({
    TextEditingController? pollTitle,
    TextEditingController? pollDescription,
    TextEditingController? pollCompanyDescription,
    TextEditingController? votePrice,
    TextEditingController? voteNumber,
    TextEditingController? firstChoice,
    TextEditingController? secondChoice,
    TextEditingController? firstChoiceDescription,
    TextEditingController? secondChoiceDescription,
    String? startDate,
    String? endDate,
    String? pollType,
    File? productImage,
  }) {
    return CreatePollVotingState(
      pollTitle: pollTitle ?? this.pollTitle,
      pollDescription: pollDescription ?? this.pollDescription,
      pollCompanyDescription: pollCompanyDescription ?? this.pollCompanyDescription,
      votePrice: votePrice ?? this.votePrice,
      voteNumber: voteNumber ?? this.voteNumber,
      firstChoice: firstChoice ?? this.firstChoice,
      secondChoice: secondChoice ?? this.secondChoice,
      firstChoiceDescription: firstChoiceDescription ?? this.firstChoiceDescription,
      secondChoiceDescription: secondChoiceDescription ?? this.secondChoiceDescription,
      pollType: pollType ?? this.pollType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      productImage: productImage ?? this.productImage,
    );
  }
}

/*Future<void> showDatePickerDialog(BuildContext context) async {
  try {
    final response = await showDatePicker(
        context: context,
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
        initialDate: DateTime.now());

    if (response != null) {
      final dateOfBirth =
          "${response.year}-${response.month}-${response.day}";
      final dateIsoFormat = response.toIso8601String();
      state = state.copyWith(
          dateOfBirth: dateOfBirth, dateIsoFormat: dateIsoFormat);
    }
  } catch (error) {
    print(error);
  }
}*/

final createPollVotingProvider =
StateNotifierProvider<CreatePollVotingVm, CreatePollVotingState>(
        (ref) => CreatePollVotingVm(ref));

class CreatePollVotingVm extends StateNotifier<CreatePollVotingState> {
  final Ref ref;
  CreatePollVotingVm(this.ref) : super(CreatePollVotingState());
  final ImagePicker _picker = ImagePicker();

  void uploadImage() {
    _picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        File file = File(value.path);
        state = state.copyWith(productImage: file);
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
     /* case "productCategory":
        state = state.copyWith(productCategory: value.value);
      case "productCondition":
        state = state.copyWith(productCondition: value.value);
      case "productType":
        state = state.copyWith(productType: value.value);
      case "pickUpOption":
        state = state.copyWith(pickUpOption: value.value);*/
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


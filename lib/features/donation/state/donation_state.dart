
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/donation/model/all_donation_model.dart';
import 'package:wayagram/features/donation/model/create_donation_response.dart';
import 'package:wayagram/features/donation/model/my_donation_model.dart';

class DonationState{
    final TextEditingController title;
    final TextEditingController description;
    final TextEditingController solution;
    final TextEditingController statement;
    final TextEditingController targetAmount;
    final TextEditingController amount;
    final TextEditingController minimumDonationAmount;
    final TextEditingController details;
    final List<DocType> donationImage;
    final MultipartFile? image;
    final String? kycStatus;
    final String kycMessage;
    final String privacyOption;
    final Object? accountType;
    final String startDate;
    final String endDate;
    final String startDateString;
    final String endDateString;
    final CreateDonationResponse? createDonationResponse;
    List<AllDonationDocs>? allDonationDocs;
    List<MyDonationDocs>? myDonationDocs;
    List<MyDonationDocs>? approvedDonations;

    final bool isLoading;
    final bool showAmountRaised;
    final bool showNumberOfDonors;

    DonationState({
    TextEditingController? title,
    TextEditingController? description,
    TextEditingController? solution,
    TextEditingController? statement,
    TextEditingController? amount,
    TextEditingController? targetAmount,
    TextEditingController? minimumDonationAmount,
    TextEditingController? details,
      this.allDonationDocs = const [],
      this.myDonationDocs = const [],
      this.approvedDonations = const [],
      this.donationImage = const [],
      this.image,
      this.startDate = '',
      this.accountType,
      this.kycStatus = '',
      this.kycMessage = '',
      this.privacyOption = '',
      this.endDate = '',
      this.startDateString = '',
      this.endDateString = '',
      this.isLoading = false,
      this.showAmountRaised = false,
      this.showNumberOfDonors = false,
      this.createDonationResponse,

  }):     title = title ?? TextEditingController(),
          description = description ?? TextEditingController(),
          solution = solution ?? TextEditingController(),
          statement = statement ?? TextEditingController(),
          targetAmount = targetAmount ?? TextEditingController(),
          amount = amount ?? TextEditingController(),
          minimumDonationAmount = minimumDonationAmount ?? TextEditingController(),
          details = details ?? TextEditingController();

    DonationState copyWith({
    TextEditingController? title,
    TextEditingController? description,
    TextEditingController? solution,
    TextEditingController? statement,
    TextEditingController? amount,
    TextEditingController? targetAmount,
    TextEditingController? minimumDonationAmount,
    TextEditingController? details,
      List<AllDonationDocs>? allDonationDocs,
      List<MyDonationDocs>? myDonationDocs,
      List<MyDonationDocs>? approvedDonations,
      List<DocType>? donationImage,
      MultipartFile? image,
      String? privacyOption,
      String? startDate,
      String? endDate,
      String? startDateString,
      String? kycStatus,
      String? kycMessage,
      String? accountType,
      String? endDateString,
      bool? isLoading,
      bool? isPublic,
      bool? isPrivate,
      bool? showAmountRaised,
      bool? showNumberOfDonors,
      CreateDonationResponse? createDonationResponse,

    }){
    return DonationState(
      title: title ?? this.title,
      description: description ?? this.description,
      solution: solution ?? this.solution,
      statement: statement ?? this.statement,
      amount: amount ?? this.amount,
      kycStatus: kycStatus ?? this.kycStatus,
      kycMessage: kycMessage ?? this.kycMessage,
      targetAmount: targetAmount?? this.targetAmount,
      minimumDonationAmount: minimumDonationAmount ?? this.minimumDonationAmount,
      details: details ?? this.details,
      donationImage: donationImage ?? this.donationImage,
      image: image ?? this.image,
      privacyOption: privacyOption ?? this.privacyOption,
      accountType: accountType ?? this.accountType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startDateString: startDateString ?? this.startDateString,
      endDateString: endDateString ?? this.endDateString,
      isLoading: isLoading ?? this.isLoading,
      showAmountRaised: showAmountRaised ?? this.showAmountRaised,
      showNumberOfDonors: showNumberOfDonors ?? this.showNumberOfDonors,
      allDonationDocs: allDonationDocs ?? this.allDonationDocs,
      myDonationDocs: myDonationDocs ?? this.myDonationDocs,
      approvedDonations: approvedDonations ?? this.approvedDonations,
      createDonationResponse: createDonationResponse ?? this.createDonationResponse,
    );
  }
}


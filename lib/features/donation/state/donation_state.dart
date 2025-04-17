
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/donation/model/all_donation_model.dart';
import 'package:wayagram/features/donation/model/applied_donation_model.dart';
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
    final List<String>? selectedCategoryId;
    final String category;
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
    List<AppliedDonationDocs>? appliedDonationDocs;
    List<MyDonationDocs>? myDonationDocs;
    List<MyDonationDocs>? approvedDonations;
    List<MyDonationDocs>? rejectedDonations;
    final List<Select> categories;

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
      this.appliedDonationDocs = const [],
      this.myDonationDocs = const [],
      this.selectedCategoryId = const [],
      this.approvedDonations = const [],
      this.rejectedDonations = const [],
      this.donationImage = const [],
      this.categories = const [],
      this.image,
      this.startDate = '',
      this.category = '',
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
      List<Select>? categories,
      List<String>? selectedCategoryId,
      List<AllDonationDocs>? allDonationDocs,
      List<AppliedDonationDocs>? appliedDonationDocs,
      List<MyDonationDocs>? myDonationDocs,
      List<MyDonationDocs>? approvedDonations,
      List<MyDonationDocs>? rejectedDonations,
      List<DocType>? donationImage,
      MultipartFile? image,
      String? privacyOption,
      String? category,
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
      category: category ?? this.category,
      categories: categories ?? this.categories,
      image: image ?? this.image,
      privacyOption: privacyOption ?? this.privacyOption,
      accountType: accountType ?? this.accountType,
      startDate: startDate ?? this.startDate,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      endDate: endDate ?? this.endDate,
      startDateString: startDateString ?? this.startDateString,
      endDateString: endDateString ?? this.endDateString,
      isLoading: isLoading ?? this.isLoading,
      showAmountRaised: showAmountRaised ?? this.showAmountRaised,
      showNumberOfDonors: showNumberOfDonors ?? this.showNumberOfDonors,
      allDonationDocs: allDonationDocs ?? this.allDonationDocs,
      appliedDonationDocs: appliedDonationDocs ?? this.appliedDonationDocs,
      myDonationDocs: myDonationDocs ?? this.myDonationDocs,
      approvedDonations: approvedDonations ?? this.approvedDonations,
      rejectedDonations: rejectedDonations ?? this.rejectedDonations,
      createDonationResponse: createDonationResponse ?? this.createDonationResponse,
    );
  }
}


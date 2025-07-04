
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/donation/model/all_donation_model.dart';
import 'package:wayagram/features/donation/model/applied_donation_model.dart';
import 'package:wayagram/features/donation/model/create_donation_response.dart';
import 'package:wayagram/features/donation/model/my_donation_model.dart';
import 'package:wayagram/features/donation/model/rejected_donation_model.dart';

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
    final List<String> selected;
    final List<MyDonationDocs> singleDonationDocs;
    final String category;
    final String? kycStatus;
    final String kycMessage;
    final String commission;
    final String privacyOption;
    final Object? accountType;
    final String startDate;
    final String daysLeft;
    final String endDate;
    final String startDateString;
    final String endDateString;
    final String donationTitle;
    final String donationCount;
    final String donationDescription;
    final String donationSolution;
    final String donationImpact;
    final String donationTargetAmount;
    final String donationShowRaised;
    final String donationAmountRaised;
    final String donationMinimumDonationAmount;
    final String donationImageUrl;
    final String donationId;
    final String donationPrivacy;
    final CreateDonationResponse? createDonationResponse;
    List<AllDonationDocs>? allDonationDocs;
    List<AppliedDonationDocs>? appliedDonationDocs;
    List<MyDonationDocs> myDonationDocs;
    List<MyDonationDocs>? approvedDonations;
    List<MyDonationDocs>? pendingDonations;
    List<RejectedDonationDocs> rejectedDonations;
    final List<Select> categories;

    final bool isLoading;
    final bool isAgreeToTerm;
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
      this.pendingDonations = const [],
      this.appliedDonationDocs = const [],
      this.myDonationDocs = const [],
      this.selectedCategoryId = const [],
      this.selected = const [],
      this.approvedDonations = const [],
      this.rejectedDonations = const [],
      this.donationImage = const [],
      this.categories = const [],
      this.image,
      this.singleDonationDocs = const [],
      this.startDate = '',
      this.commission = '',
      this.category = '',
      this.accountType,
      this.kycStatus = '',
      this.kycMessage = '',
      this.privacyOption = '',
      this.endDate = '',
      this.startDateString = '',
      this.endDateString = '',
      this.daysLeft = '',
      this.isLoading = false,
      this.isAgreeToTerm = false,
      this.showAmountRaised = false,
      this.showNumberOfDonors = false,
      this.createDonationResponse,
      this.donationTitle = '',
      this.donationCount = '',
      this.donationDescription = '',
      this.donationSolution = '',
      this.donationImpact = '',
      this.donationTargetAmount = '',
      this.donationShowRaised = '',
      this.donationImageUrl= '',
      this.donationId = '',
      this.donationPrivacy = '',
      this.donationAmountRaised = '',
      this.donationMinimumDonationAmount = '',

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
      List<MyDonationDocs>? pendingDonations,
      List<Select>? categories,
      List<String>? selectedCategoryId,
      List<String>? selected,
      List<AllDonationDocs>? allDonationDocs,
      List<AppliedDonationDocs>? appliedDonationDocs,
      List<MyDonationDocs>? myDonationDocs,
      List<MyDonationDocs>? singleDonationDocs,
      List<MyDonationDocs>? approvedDonations,
      List<RejectedDonationDocs>? rejectedDonations,
      List<DocType>? donationImage,
      MultipartFile? image,
      String? daysLeft,
      String? donationTitle,
      String? donationImageUrl,
      String? donationPrivacy,
      String? donationId,
      String? donationCount,
      String? donationDescription,
      String? donationSolution,
      String? donationImpact,
      String? donationTargetAmount,
      String? donationShowRaised,
      String? donationAmountRaised,
      String? donationMinimumDonationAmount,
      String? privacyOption,
      String? category,
      String? startDate,
      String? endDate,
      String? commission,
      String? startDateString,
      String? kycStatus,
      String? kycMessage,
      String? accountType,
      String? endDateString,
      bool? isLoading,
      bool? isPublic,
      bool? isPrivate,
      bool? isAgreeToTerm,
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
      donationTitle: donationTitle ?? this.donationTitle,
      donationPrivacy: donationPrivacy ?? this.donationPrivacy,
      donationCount: donationCount ?? this.donationCount,
      donationDescription: donationDescription ?? this.donationDescription,
      donationAmountRaised: donationAmountRaised ?? this.donationAmountRaised,
      donationImpact: donationImpact ?? this.donationImpact,
      donationMinimumDonationAmount: donationMinimumDonationAmount ?? this.donationMinimumDonationAmount,
      donationShowRaised: donationShowRaised ?? this.donationShowRaised,
      donationSolution: donationSolution ?? this.donationSolution,
      donationImageUrl: donationImageUrl ?? this.donationImageUrl,
      donationTargetAmount: donationTargetAmount ?? this.donationTargetAmount,
      donationId: donationId?? this.donationId,
      kycMessage: kycMessage ?? this.kycMessage,
      targetAmount: targetAmount?? this.targetAmount,
      minimumDonationAmount: minimumDonationAmount ?? this.minimumDonationAmount,
      details: details ?? this.details,
      donationImage: donationImage ?? this.donationImage,
      category: category ?? this.category,
      categories: categories ?? this.categories,
      selected: selected ?? this.selected,
      image: image ?? this.image,
      daysLeft: daysLeft ?? this.daysLeft,
      singleDonationDocs: singleDonationDocs ?? this.singleDonationDocs,
      privacyOption: privacyOption ?? this.privacyOption,
      accountType: accountType ?? this.accountType,
      startDate: startDate ?? this.startDate,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      endDate: endDate ?? this.endDate,
      commission: commission ?? this.commission,
      startDateString: startDateString ?? this.startDateString,
      endDateString: endDateString ?? this.endDateString,
      isLoading: isLoading ?? this.isLoading,
      isAgreeToTerm: isAgreeToTerm ?? this.isAgreeToTerm,
      showAmountRaised: showAmountRaised ?? this.showAmountRaised,
      showNumberOfDonors: showNumberOfDonors ?? this.showNumberOfDonors,
      allDonationDocs: allDonationDocs ?? this.allDonationDocs,
      pendingDonations: pendingDonations ?? this.pendingDonations,
      appliedDonationDocs: appliedDonationDocs ?? this.appliedDonationDocs,
      myDonationDocs: myDonationDocs ?? this.myDonationDocs,
      approvedDonations: approvedDonations ?? this.approvedDonations,
      rejectedDonations: rejectedDonations ?? this.rejectedDonations,
      createDonationResponse: createDonationResponse ?? this.createDonationResponse,
    );
  }
}


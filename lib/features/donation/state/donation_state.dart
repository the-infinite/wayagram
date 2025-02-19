
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';

class DonationState{
    final TextEditingController title;
    final TextEditingController description;
    final TextEditingController solution;
    final TextEditingController statement;
    final TextEditingController amount;
    final TextEditingController details;
    final DocType? donationImage;
    final MultipartFile? image;
    final String startDate;
    final String endDate;
    final String startDateString;
    final String endDateString;

    final bool isLoading;
    final bool showAmountRaised;
    final bool showNumberOfDonors;

    DonationState({
    TextEditingController? title,
    TextEditingController? description,
    TextEditingController? solution,
    TextEditingController? statement,
    TextEditingController? amount,
    TextEditingController? details,

      this.donationImage,
      this.image,
      this.startDate = '',
      this.endDate = '',
      this.startDateString = '',
      this.endDateString = '',
      this.isLoading = false,
      this.showAmountRaised = false,
      this.showNumberOfDonors = false,


  }):     title = title ?? TextEditingController(),
          description = description ?? TextEditingController(),
          solution = solution ?? TextEditingController(),
          statement = statement ?? TextEditingController(),
          amount = amount ?? TextEditingController(),
          details = details ?? TextEditingController();

    DonationState copyWith({
    TextEditingController? title,
    TextEditingController? description,
    TextEditingController? solution,
    TextEditingController? statement,
    TextEditingController? amount,
    TextEditingController?  details,
      DocType? donationImage,
      MultipartFile? image,
      String? startDate,
      String? endDate,
      String? startDateString,
      String? endDateString,
      bool? isLoading,
      bool? showAmountRaised,
      bool? showNumberOfDonors,

    }){
    return DonationState(
      title: title ?? this.title,
      description: description ?? this.description,
      solution: solution ?? this.solution,
      statement: statement ?? this.statement,
      amount: amount ?? this.amount,
      details: details ?? this.details,
      donationImage: donationImage ?? this.donationImage,
      image: image ?? this.image,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startDateString: startDateString ?? this.startDateString,
      endDateString: endDateString ?? this.endDateString,
      isLoading: isLoading ?? this.isLoading,
      showAmountRaised: showAmountRaised ?? this.showAmountRaised,
      showNumberOfDonors: showNumberOfDonors ?? this.showNumberOfDonors
    );
  }
}


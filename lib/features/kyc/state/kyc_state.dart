
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/donation/model/all_donation_model.dart';
import 'package:wayagram/features/donation/model/create_donation_response.dart';
import 'package:wayagram/features/donation/model/my_donation_model.dart';

class KycState{
  final TextEditingController accountNumber;
  final TextEditingController bvn;
  final TextEditingController houseAddress;
  final TextEditingController businessAddress;
  final List<DocType> kycImage;
  final String? kycStatus;
  final String? date;

  final bool isLoading;

  KycState({
    TextEditingController? accountNumber,
    TextEditingController? bvn,
    TextEditingController? houseAddress,
    TextEditingController? businessAddress,
    this.isLoading = false,
    this.kycImage = const [],
    this.kycStatus = '',
    this.date = '',


  }):
        accountNumber = accountNumber ?? TextEditingController(),
        bvn = bvn ?? TextEditingController(),
        houseAddress = houseAddress ?? TextEditingController(),
        businessAddress = businessAddress ?? TextEditingController();


  KycState copyWith({
    TextEditingController? accountNumber,
    TextEditingController? bvn,
    TextEditingController? houseAddress,
    TextEditingController? businessAddress,
    bool? isLoading,
    String? kycStatus,
    String? date,
    List<DocType>? kycImage,

  }){
    return KycState(
     accountNumber: accountNumber ?? this.accountNumber,
      bvn: bvn ?? this.bvn,
      houseAddress: houseAddress ?? this.houseAddress,
      businessAddress: businessAddress ?? this.businessAddress,
      isLoading: isLoading ?? this.isLoading,
      kycImage: kycImage ?? this.kycImage,
        kycStatus: kycStatus ?? this.kycStatus,
      date: date ?? this.date,

    );
  }
}


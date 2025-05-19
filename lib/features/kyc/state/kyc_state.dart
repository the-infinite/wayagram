import 'package:flutter/cupertino.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';

class KycState {
  final TextEditingController accountNumber;
  final TextEditingController bvn;
  final TextEditingController houseAddress;
  final TextEditingController businessAddress;
  final List<DocType> kycImage;
  final String? kycStatus;
  final String? date;
  final bool notBusiness;
  final String? reason;

  final bool isLoading;

  KycState(
      {TextEditingController? accountNumber,
      TextEditingController? bvn,
      TextEditingController? houseAddress,
      TextEditingController? businessAddress,
      this.isLoading = false,
      this.kycImage = const [],
      this.kycStatus = '',
      this.date = '',
      this.notBusiness = false,
      this.reason = ""
      
      
      })
      : accountNumber = accountNumber ?? TextEditingController(),
        bvn = bvn ?? TextEditingController(),
        houseAddress = houseAddress ?? TextEditingController(),
        businessAddress = businessAddress ?? TextEditingController();

  KycState copyWith({
    TextEditingController? accountNumber,
    TextEditingController? bvn,
    TextEditingController? houseAddress,
    TextEditingController? businessAddress,
    bool? notBusiness,
    bool? isLoading,
    String? kycStatus,
    String? date,
    List<DocType>? kycImage,
    String? reason
  }) {
    return KycState(
        accountNumber: accountNumber ?? this.accountNumber,
        bvn: bvn ?? this.bvn,
        houseAddress: houseAddress ?? this.houseAddress,
        businessAddress: businessAddress ?? this.businessAddress,
        isLoading: isLoading ?? this.isLoading,
        kycImage: kycImage ?? this.kycImage,
        kycStatus: kycStatus ?? this.kycStatus,
        reason: reason ?? this.reason,
        date: date ?? this.date,
        notBusiness: notBusiness ?? this.notBusiness);
  }
}

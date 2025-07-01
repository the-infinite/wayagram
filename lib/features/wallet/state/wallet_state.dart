import 'package:flutter/material.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/wallet/data/model/bank_model.dart';
import 'package:wayagram/features/wallet/data/model/external_wallet_model.dart';
import 'package:wayagram/features/wallet/data/model/get_request_model.dart';
import 'package:wayagram/features/wallet/data/model/payout_method_model.dart';
import 'package:wayagram/features/wallet/data/model/wallet_model.dart';

class WalletState {
  final bool? isLoading;
  final bool? isMakePaymentLoading;
  final Wallet? data;
  final Select? bank;
  final String status;
  final String amount;
  final String refNumber;
   String bankName;
   String bankRef;
  final String payoutAccountNumber;
  String accountName;
  final String time;
   String accountNumber;
  final TextEditingController acctNumberController;
  final TextEditingController searchController;
  final TextEditingController acctNameController;
  final List<ExternalWalletModel>? externalWallets;
  final List<PayoutMethodData> payoutMethod;
  final List<RequestDocs> requestDocs;
  final List<Select> banks;
  final List<BankModelData>  filteredList;

  WalletState({
    this.isLoading = false,
    this.isMakePaymentLoading = false,
    this.data,
    this.time = '',
    this.status = '',
    this.amount = '',
    this.refNumber = '',
    this.bankName = '',
    this.bankRef = '',
    this.accountName = '',
    this.accountNumber = '',
    this.payoutAccountNumber = '',
    this.banks = const [],
    this.filteredList = const [],
    this.bank,
    TextEditingController? acctNumberController,
    TextEditingController? acctNameController,
    TextEditingController? searchController,
    this.externalWallets,
    this.payoutMethod = const [],
    this.requestDocs = const [],

  }):
        acctNumberController = acctNumberController ?? TextEditingController(),
        acctNameController = acctNameController ?? TextEditingController(),
        searchController = searchController ?? TextEditingController();

  WalletState copyWith({
    bool? isLoading,
    Wallet? data,
    Select? bank,
    String? time,
    String? status,
    String? amount,
    String? refNumber,
    String? bankName,
    String? bankRef,
    String? accountName,
    String? accountNumber,
    String? payoutAccountNumber,
    TextEditingController? acctNumberController,
    TextEditingController? acctNameController,
    TextEditingController? searchController,
    List<ExternalWalletModel>? externalWallets,
    List<Select>? banks,
    List<RequestDocs>? requestDocs,
    List<PayoutMethodData>? payoutMethod,
    List<BankModelData>? filteredList,

  }) =>
      WalletState(
        isLoading: isLoading ?? this.isLoading,
        data: data ?? this.data,
          bank: bank ?? this.bank,
        time: time ?? this.time,
        status: status ?? this.status,
        banks: banks ?? this.banks,
        amount: amount ?? this.amount,
        refNumber: refNumber ?? this.refNumber,
        bankName: bankName ?? this.bankName,
          bankRef: bankRef ?? this.bankRef,
          accountNumber: accountNumber ?? this.accountNumber,
        payoutAccountNumber: payoutAccountNumber ?? this.payoutAccountNumber,
        requestDocs: requestDocs ?? this.requestDocs,
        accountName: accountName ?? this.accountName,
        acctNumberController: acctNumberController ?? this.acctNumberController,
        acctNameController: acctNameController ?? this.acctNameController,
          searchController: searchController ?? this.searchController,
        externalWallets: externalWallets ?? this.externalWallets,
        payoutMethod: payoutMethod ?? this.payoutMethod,
        filteredList: filteredList ?? this.filteredList
      );
}

class WalletFundingOptionState {
  final bool? isLoading;
  final List<WalletFundingOptionModel>? fundingOptions;
  final List<PayoutMethodData>? payoutMethod;
  WalletFundingOptionState({this.isLoading = false, this.fundingOptions, this.payoutMethod});

  WalletFundingOptionState copyWith({bool? isLoading, List<WalletFundingOptionModel>? fundingOptions, List<PayoutMethodData>? payoutMethod,}) =>
      WalletFundingOptionState(
          isLoading: isLoading ?? this.isLoading,
          fundingOptions: fundingOptions ?? this.fundingOptions,
          payoutMethod: payoutMethod ?? this.payoutMethod);
}

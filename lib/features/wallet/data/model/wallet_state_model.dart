import 'package:flutter/material.dart';
import 'package:wayagram/core/data/model/model.dart';
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
  final String bankName;
  final String payoutAccountNumber;
  final String accountName;
  final String time;
  final TextEditingController acctNumber;
  final TextEditingController acctName;
  final List<ExternalWalletModel>? externalWallets;
  final List<PayoutMethodData> payoutMethod;
  final List<RequestDocs> requestDocs;
  final List<Select> banks;

  WalletState({
    this.isLoading = false,
    this.isMakePaymentLoading = false,
    this.data,
    this.time = '',
    this.status = '',
    this.amount = '',
    this.refNumber = '',
    this.bankName = '',
    this.accountName = '',
    this.payoutAccountNumber = '',
    this.banks = const [],
    this.bank,
    TextEditingController? acctNumber,
    TextEditingController? acctName,
    this.externalWallets,
    this.payoutMethod = const [],
    this.requestDocs = const [],

  }):
        acctNumber = acctNumber ?? TextEditingController(),
        acctName = acctName ?? TextEditingController();

  WalletState copyWith({
    bool? isLoading,
    Wallet? data,
    Select? bank,
    String? time,
    String? status,
    String? amount,
    String? refNumber,
    String? bankName,
    String? accountName,
    String? payoutAccountNumber,
    TextEditingController? acctNumber,
    TextEditingController? acctName,
    List<ExternalWalletModel>? externalWallets,
    List<Select>? banks,
    List<RequestDocs>? requestDocs,
    List<PayoutMethodData>? payoutMethod,

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
        payoutAccountNumber: payoutAccountNumber ?? this.payoutAccountNumber,
        requestDocs: requestDocs ?? this.requestDocs,
        accountName: accountName ?? this.accountName,
        acctNumber: acctNumber ?? this.acctNumber,
        acctName: acctName ?? this.acctName,
        externalWallets: externalWallets ?? this.externalWallets,
        payoutMethod: payoutMethod ?? this.payoutMethod
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

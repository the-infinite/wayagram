import 'package:flutter/material.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/wallet/data/model/external_wallet_model.dart';
import 'package:wayagram/features/wallet/data/model/payout_method_model.dart';
import 'package:wayagram/features/wallet/data/model/wallet_model.dart';

class WalletState {
  final bool? isLoading;
  final bool? isMakePaymentLoading;
  final Wallet? data;
  final String bank;
  final TextEditingController acctNumber;
  final List<ExternalWalletModel>? externalWallets;
  final List<PayoutMethodData> payoutMethod;
  final List<Select> banks;

  WalletState({
    this.isLoading = false,
    this.isMakePaymentLoading = false,
    this.data,
    this.banks = const [],
    this.bank = '',
    TextEditingController? acctNumber,
    this.externalWallets,
    this.payoutMethod = const [],

  }):acctNumber = acctNumber ?? TextEditingController();

  WalletState copyWith({
    bool? isLoading,
    Wallet? data,
    String? bank,
    TextEditingController? acctNumber,
    List<ExternalWalletModel>? externalWallets,
    List<Select>? banks,
    final List<PayoutMethodData>? payoutMethod,

  }) =>
      WalletState(
        isLoading: isLoading ?? this.isLoading,
        data: data ?? this.data,
          bank: bank ?? this.bank,
        banks: banks ?? this.banks,
        acctNumber: acctNumber ?? this.acctNumber,
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

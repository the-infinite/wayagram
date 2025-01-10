import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/wallet/data/model/external_wallet_model.dart';
import 'package:wayagram/features/wallet/data/model/wallet_model.dart';
import 'package:wayagram/features/wallet/data/model/wallet_state_model.dart';
import 'package:wayagram/features/wallet/data/repo/wallet_repository.dart';

class WalletVm extends StateNotifier<WalletState> {
  final WalletRepository? _walletRepository;
  WalletVm(this._walletRepository) : super(WalletState());

  Future<void> getUserWallet() async {
    state = state.copyWith(isLoading: true);
    final response = await _walletRepository!.getUserWallet();
    if (response.success == true) {
      final walletData = response.data["data"]["wallet"];
      final walletAccountsData = response.data["data"]["walletAccounts"];
      final externalWallets = (walletAccountsData as List)
          .map((walletAccount) => ExternalWalletModel.fromJson(walletAccount))
          .toList();
      state = state.copyWith(
          data: Wallet.fromJson(walletData),
          externalWallets: externalWallets,
          isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> checkWalletPinStatus(String userId) async {
    state = state.copyWith(isLoading: true);
    final response = await _walletRepository!.checkWalletPinStatus(userId);
    if (response.success == true) {
      final walletData = response.data["data"]["wallet"];
      state =
          state.copyWith(data: Wallet.fromJson(walletData), isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }
}

final walletVmProvider = StateNotifierProvider<WalletVm, WalletState>((ref) {
  return WalletVm(WalletRepository());
});

class WalletFundingOptionsVm extends StateNotifier<WalletFundingOptionState> {
  final WalletRepository? _walletRepository;
  final WayaLocalDataSource _localDataSource;
  final SuccessfulSetUpState _setupState;
  WalletFundingOptionsVm(
      this._walletRepository, this._localDataSource, this._setupState)
      : super(WalletFundingOptionState());

  Future<void> getWalletFundingOptions() async {
    state = state.copyWith(isLoading: true);
    final response = await _walletRepository!.getWalletFundingOptions();
    if (response.success == true) {
      final fundingData = response.data["data"];
      final fundingOptions = (fundingData as List)
          .map((fundOption) => WalletFundingOptionModel.fromJson(fundOption))
          .toList();
      state = state.copyWith(fundingOptions: fundingOptions, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<Map<String, dynamic>?> walletFunding(
      {String? decription,
      required double amount,
      required String fundOptionCode}) async {
    final user = _setupState.user?.user;

    final response = await _walletRepository!.fundWallet(FundWallet(
        userId: user!.id ?? "",
        amount: amount,
        description: decription ?? "Wallet funding",
        email: user.email ?? "",
        fundOptionCode: fundOptionCode,
        callbackUrl: "https://v2.staging.wayagram.ng"));

    if (response.success) {
      final resData = response.data["data"];
      return resData;
    } else {
      return null;
    }
  }

  Future<bool> verifyWalletPin(String pin) async {
    final user = _setupState.user?.user;
    final response = await _walletRepository!
        .confirmWalletPin(ConfirmWalletPin(userId: user!.id ?? "", pin: pin));
    if (response.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> payForService(
      {required double amount,
      required String description,
      required String purpose,
      required String recipientId,
      required String referenceId,
      Map<String, dynamic>? metadata}) async {
    final user = _setupState.user?.user;
    final response = await _walletRepository!.payForService(PayForService(
      userId: user!.id ?? "",
      amount: amount,
      description: description,
      purpose: purpose,
      recipientId: recipientId,
      referenceId: recipientId,
      metadata: metadata,
    ));
    if (response.success) {
      return;
    }
  }
}

final walletFundingOptionsVmProvider =
    StateNotifierProvider<WalletFundingOptionsVm, WalletFundingOptionState>(
        (ref) {
  final successfulSetupVm = ref.watch(successfulSetupVmProvider);
  return WalletFundingOptionsVm(
      WalletRepository(), WayaLocalDataSource(), successfulSetupVm);
});

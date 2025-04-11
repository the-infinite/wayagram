import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:wayagram/features/wallet/data/model/bank_model.dart';
import 'package:wayagram/features/wallet/data/model/external_wallet_model.dart';
import 'package:wayagram/features/wallet/data/model/payout_method_model.dart';
import 'package:wayagram/features/wallet/data/model/wallet_model.dart';
import 'package:wayagram/features/wallet/data/model/wallet_state_model.dart';
import 'package:wayagram/features/wallet/data/repo/wallet_repository.dart';

class WalletVm extends StateNotifier<WalletState> {
  final _walletRepository = WalletRepository.instance;
  WalletVm() : super(WalletState());

  void selectCategory(Select value) {
    state = state.copyWith(bank: value.value);
  }

  Future<void> getUserWallet() async {
    state = state.copyWith(isLoading: true);
    final response = await _walletRepository.getUserWallet();
    if (response.success == true) {
      final walletData = response.data["data"]["wallet"];
      final walletAccountsData = response.data["data"]["walletAccounts"];
      final externalWallets =
          (walletAccountsData as List).map((walletAccount) => ExternalWalletModel.fromJson(walletAccount)).toList();
      state = state.copyWith(data: Wallet.fromJson(walletData), externalWallets: externalWallets, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getPayoutMethod() async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _walletRepository.getPayoutMethod();
      state = state.copyWith(isLoading: false);
      print('API Response: ${response.data}');
      print('Status Code: ${response.statusCode}');

      if (response.success) {
        PayoutMethodModel responseModel = PayoutMethodModel.fromJson(response.data);
        state = state.copyWith(payoutMethod: responseModel.data);
      } else {}
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<PaginatedResult<PayoutMethodData>?> getPayoutMethodTwo() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _walletRepository.getPayoutMethod();
      List<PayoutMethodData>? fetchPageDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        PayoutMethodModel responseModel = PayoutMethodModel.fromJson(response.data);
        fetchPageDocs = responseModel.data;
        //hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(payoutMethod: fetchPageDocs);
        state = state.copyWith(payoutMethod: responseModel.data);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage, items: fetchPageDocs!);
    } catch (e) {
      // _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<void> fetchBank() async {
    try {
      final response = await _walletRepository.getBanks();

      if (response.success) {
        BankModel responseModel = BankModel.fromJson(response.data);

        final List<Select>? categories = responseModel.data?.map((val) {
          return Select(label: '${val.institutionName}', value: '${val.institutionCode}');
        }).toList();
        state = state.copyWith(banks: categories);
      }
    } catch (e) {
      // _logger.e(e);
    }
  }

  Future<void> checkWalletPinStatus(String userId) async {
    state = state.copyWith(isLoading: true);
    final response = await _walletRepository.checkWalletPinStatus(userId);
    if (response.success == true) {
      final walletData = response.data["data"]["wallet"];
      state = state.copyWith(data: Wallet.fromJson(walletData), isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }
}

final walletVmProvider = StateNotifierProvider<WalletVm, WalletState>((ref) {
  return WalletVm();
});

class WalletFundingOptionsVm extends StateNotifier<WalletFundingOptionState> {
  final WalletRepository? _walletRepository;
  final SuccessfulSetUpState _setupState;
  WalletFundingOptionsVm(this._walletRepository, this._setupState) : super(WalletFundingOptionState());

  Future<void> getWalletFundingOptions() async {
    state = state.copyWith(isLoading: true);
    final response = await _walletRepository!.getWalletFundingOptions();
    if (response.success == true) {
      final fundingData = response.data["data"];
      final fundingOptions =
          (fundingData as List).map((fundOption) => WalletFundingOptionModel.fromJson(fundOption)).toList();
      state = state.copyWith(fundingOptions: fundingOptions, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<Map<String, dynamic>?> walletFunding(
      {String? decription, required double amount, required String fundOptionCode}) async {
    final user = _setupState.user?.user;

    final response = await _walletRepository!.fundWallet(FundWallet(
        userId: user!.id,
        amount: amount,
        description: decription ?? "Wallet funding",
        email: user.email ?? "",
        fundOptionCode: fundOptionCode,
        callbackUrl: "https://v2.staging.wayagram.ng"
        //callbackUrl: WayaConstants.baseUrl
        ));

    if (response.success) {
      final resData = response.data["data"];
      return resData;
    } else {
      return null;
    }
  }

  Future<bool> verifyWalletPin(String pin) async {
    final user = _setupState.user?.user;
    final response = await _walletRepository!.confirmWalletPin(ConfirmWalletPin(userId: user!.id, pin: pin));
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
      userId: user!.id,
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

final walletFundingOptionsVmProvider = StateNotifierProvider<WalletFundingOptionsVm, WalletFundingOptionState>((ref) {
  final successfulSetupVm = ref.watch(successfulSetupVmProvider);
  return WalletFundingOptionsVm(WalletRepository.instance, successfulSetupVm);
});

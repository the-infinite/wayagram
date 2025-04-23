import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:wayagram/features/wallet/data/model/bank_model.dart';
import 'package:wayagram/features/wallet/data/model/external_wallet_model.dart';
import 'package:wayagram/features/wallet/data/model/get_request_model.dart';
import 'package:wayagram/features/wallet/data/model/payout_method_model.dart';
import 'package:wayagram/features/wallet/data/model/single_payout_method_model.dart';
import 'package:wayagram/features/wallet/data/model/single_request_model.dart';
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

  Future<void> createPayoutMethod(String acctNum, String acctName, String bankName, String bankCode, ctx) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _walletRepository.createPayoutMethod(acctNum, acctName, bankName, bankCode);
      state = state.copyWith(isLoading: false);
      WayaNav.goBack();
      if (response.success && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              'Payout Method added successfully!',
              style: TextStyle(fontFamily: WayaConstants.fontFamily, fontSize: 12.sp),
            ),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      } else {}
    } catch (e) {
      // _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> createPayoutRequest(String amount, String payoutMethodId, ctx) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _walletRepository.createPayoutRequest(amount, payoutMethodId);
      state = state.copyWith(isLoading: false);
      WayaNav.goBack();
      if (response.success && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              'Payout Request created successfully!',
              style: TextStyle(fontFamily: WayaConstants.fontFamily, fontSize: 12.sp),
            ),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      } else {}
    } catch (e) {
      // _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getPayoutMethod() async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _walletRepository.getPayoutMethod();
      state = state.copyWith(isLoading: false);
      debugPrint('API Response: ${response.data}');
      debugPrint('Status Code: ${response.statusCode}');

      if (response.success) {
        PayoutMethodModel responseModel = PayoutMethodModel.fromJson(response.data);
        state = state.copyWith(payoutMethod: responseModel.data);
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  Future<void> deletePayoutMethod(
    ctx, {
    required String id,
  }) async {
    try {
      final response = await _walletRepository.deletePayoutMethod(id);
      if (response.success && ctx.mounted) {
        getPayoutMethodTwo(
          page: 1,
        );
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              'Payout method deleted successfully!',
              style: TextStyle(fontFamily: WayaConstants.fontFamily, fontSize: 12.sp),
            ),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getSingleRequest({required String id}) async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _walletRepository.getSingleRequest(id);
      state = state.copyWith(isLoading: false);
      debugPrint('API Response: ${response.data}');
      debugPrint('Status Code: ${response.statusCode}');

      if (response.success) {
        SingleRequestModel responseModel = SingleRequestModel.fromJson(response.data);
        state = state.copyWith(
            amount: responseModel.data?.amount,
            status: responseModel.data?.status,
            refNumber: responseModel.data?.referenceId,
            bankName: responseModel.data?.payoutMethod?.bankName,
            accountName: responseModel.data?.payoutMethod?.accountName,
            payoutAccountNumber: responseModel.data?.payoutMethod?.accountNumber,
            time: responseModel.data?.createdAt);
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  Future<void> getSinglePayoutMethod({required String id}) async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _walletRepository.getSinglePayoutMethod(id);
      state = state.copyWith(isLoading: false);
      debugPrint('API Response: ${response.data}');
      debugPrint('Status Code: ${response.statusCode}');

      if (response.success) {
        SinglePayoutMethodModel responseModel = SinglePayoutMethodModel.fromJson(response.data);
        state = state.copyWith(
          bankName: responseModel.data?.bankName,
          payoutAccountNumber: responseModel.data?.accountName,
        );
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  Future<PaginatedResult<PayoutMethodData>?> getPayoutMethodTwo({required int page}) async {
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

  Future<PaginatedResult<RequestDocs>?> getRequest({required int page}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _walletRepository.getRequestPayout(page);
      List<RequestDocs>? fetchRequestDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        GetRequestModel responseModel = GetRequestModel.fromJson(response.data);
        fetchRequestDocs = responseModel.data?.docs;
        hasNextPage = responseModel.data?.hasNextPage;
        state = state.copyWith(requestDocs: fetchRequestDocs);
        state = state.copyWith(requestDocs: responseModel.data?.docs);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return PaginatedResult(hasNextPage: hasNextPage!, items: fetchRequestDocs!);
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

        final List<Select>? banksList = responseModel.data?.map((val) {
          return Select(label: '${val.institutionName}', value: '${val.institutionCode}');
        }).toList();
        state = state.copyWith(banks: banksList);
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
  final WayaLocalDataSource _localDataSource;
  final SuccessfulSetUpState _setupState;
  WalletFundingOptionsVm(this._walletRepository, this._localDataSource, this._setupState)
      : super(WalletFundingOptionState());

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

    final response = await _walletRepository!.fundWallet(
      FundWallet(
          userId: user!.id,
          amount: amount,
          description: decription ?? "Wallet funding",
          email: user.email ?? "",
          fundOptionCode: fundOptionCode,
          callbackUrl: "https://v2.staging.wayagram.ng"
          //callbackUrl: WayaConstants.baseUrl
          ),
    );

    if (response.success) {
      final resData = response.data["data"];
      return resData;
    } else {
      return null;
    }
  }

  Future<bool> verifyWalletPin(String pin) async {
    final user = _setupState.user?.user;
    final response = await _walletRepository!.confirmWalletPin(ConfirmWalletPin(userId: user!.id ?? "", pin: pin));
    if (response.success) {
      return true;
    } else {
      return false;
    }
  }
}

final walletFundingOptionsVmProvider = StateNotifierProvider<WalletFundingOptionsVm, WalletFundingOptionState>((ref) {
  final successfulSetupVm = ref.watch(successfulSetupVmProvider);
  return WalletFundingOptionsVm(WalletRepository.instance, WayaLocalDataSource(), successfulSetupVm);
});

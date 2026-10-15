import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/config/environment.dart';
import 'package:wayagram/core/components/modals/error.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:wayagram/features/wallet/data/model/bank_model.dart';
import 'package:wayagram/features/wallet/data/model/create_payout_model.dart';
import 'package:wayagram/features/wallet/data/model/external_wallet_model.dart';
import 'package:wayagram/features/wallet/data/model/get_request_model.dart';
import 'package:wayagram/features/wallet/data/model/payout_history_model.dart';
import 'package:wayagram/features/wallet/data/model/payout_method_model.dart';
import 'package:wayagram/features/wallet/data/model/single_payout_method_model.dart';
import 'package:wayagram/features/wallet/data/model/single_request_model.dart';
import 'package:wayagram/features/wallet/data/model/verify_account_model.dart';
import 'package:wayagram/features/wallet/data/model/wallet_model.dart';
import 'package:wayagram/features/wallet/state/wallet_state.dart';
import 'package:wayagram/features/wallet/data/repo/wallet_repository.dart';
import 'package:wayagram/features/wallet/view/request_payout.dart';

import '../../../core/controller/debug_console.dart';
import '../../chat/state/default.dart';

part 'wallet_vm.g.dart';

@riverpod
class WalletVm extends _$WalletVm {
  @override
  WalletState build() {
    final initialState = WalletState();
    return initialState.copyWith(
      acctNameController: TextEditingController(text: ''),
      acctNumberController: TextEditingController(text: ''),
    );
  }

  void reset() {
    state = WalletState().copyWith(
      acctNameController: TextEditingController(text: ''),
      acctNumberController: TextEditingController(text: ''),
    );
  }

  void selectCategory(Select value) {
    state = state.copyWith(bank: value);
  }

  Future<void> getUserWallet() async {
    state = state.copyWith(isLoading: true);
    final response = await WalletRepository.instance.getUserWallet();
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

  Future<void> createPayoutMethod(String acctNum, String acctName,
      String bankName, String bankCode, ctx) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await WalletRepository.instance
          .createPayoutMethod(acctNum, acctName, bankName, bankCode);
      state = state.copyWith(isLoading: false);
      WayaNav.goBack();
      if (response.success && ctx.mounted) {
        getPayoutMethod();
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              'Payout Method added successfully!',
              style: TextStyle(
                  fontFamily: WayaConstants.fontFamily, fontSize: 12.sp),
            ),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
        WayaNav.toNamed(RequestPayout.route);
        reset();
      } else {
        CreatePayoutModel responseModel =
            CreatePayoutModel.fromJson(response.data);
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              '${responseModel.message}',
              style: TextStyle(
                  fontFamily: WayaConstants.fontFamily, fontSize: 12.sp),
            ),
            backgroundColor: WayaColors.error,
            duration: Duration(seconds: 2),
          ),
        );
        reset();
        fetchBank();
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.polls,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> createPayoutRequest(
      String amount, String payoutMethodId, ctx) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await WalletRepository.instance
          .createPayoutRequest(amount, payoutMethodId);
      state = state.copyWith(isLoading: false);
      WayaNav.goBack();
      if (response.success && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              'Payout Request created successfully!',
              style: TextStyle(
                  fontFamily: WayaConstants.fontFamily, fontSize: 12.sp),
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
      final response = await WalletRepository.instance.getPayoutMethod();
      state = state.copyWith(isLoading: false);

      if (response.success) {
        PayoutMethodModel responseModel =
            PayoutMethodModel.fromJson(response.data);
        state = state.copyWith(payoutMethod: responseModel.data);
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  Future<void> deletePayoutMethod(
    BuildContext ctx, {
    required String id,
  }) async {
    try {
      final response = await WalletRepository.instance.deletePayoutMethod(id);
      if (response.success && ctx.mounted) {
        getPayoutMethodTwo(
          page: 1,
        );
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              'Payout method deleted successfully!',
              style: TextStyle(
                  fontFamily: WayaConstants.fontFamily, fontSize: 12.sp),
            ),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        if (WayaNav.context.mounted) {
          WayaUtils.showModalSheet(WayaNav.context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> verifyAccountName(BuildContext ctx,
      {required String acctNumber, required String bankCode}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response =
          await WalletRepository.instance.verifyName(acctNumber, bankCode);
      state = state.copyWith(isLoading: false);
      if (response.success) {
        VerifyAccountNameModel responseModel =
            VerifyAccountNameModel.fromJson(response.data);
        state = state.copyWith(
            accountName: responseModel.data?.name,
            acctNameController:
                TextEditingController(text: responseModel.data?.name));
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
      final response = await WalletRepository.instance.getSingleRequest(id);
      state = state.copyWith(isLoading: false);

      if (response.success) {
        SingleRequestModel responseModel =
            SingleRequestModel.fromJson(response.data);
        state = state.copyWith(
            amount: responseModel.data?.amount,
            status: responseModel.data?.status,
            refNumber: responseModel.data?.referenceId,
            bankName: responseModel.data?.payoutMethod?.bankName,
            accountName: responseModel.data?.payoutMethod?.accountName,
            payoutAccountNumber:
                responseModel.data?.payoutMethod?.accountNumber,
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
      final response =
          await WalletRepository.instance.getSinglePayoutMethod(id);
      state = state.copyWith(isLoading: false);

      if (response.success) {
        SinglePayoutMethodModel responseModel =
            SinglePayoutMethodModel.fromJson(response.data);
        state = state.copyWith(
          bankName: responseModel.data?.bankName,
          payoutAccountNumber: responseModel.data?.accountName,
        );
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  Future<PaginatedResult<PayoutMethodData>?> getPayoutMethodTwo(
      {required int page}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await WalletRepository.instance.getPayoutMethod();
      List<PayoutMethodData>? fetchPageDocs = [];
      bool? hasNextPage = false;
      state = state.copyWith(isLoading: false);
      if (response.success) {
        PayoutMethodModel responseModel =
            PayoutMethodModel.fromJson(response.data);
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
      final response = await WalletRepository.instance.getRequestPayout(page);
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
      return PaginatedResult(
          hasNextPage: hasNextPage!, items: fetchRequestDocs!);
    } catch (e) {
      // _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<void> fetchBank() async {
    try {
      final response = await WalletRepository.instance.getBanks();

      if (response.success) {
        BankModel responseModel = BankModel.fromJson(response.data);

        final List<Select>? banksList = responseModel.data?.map((val) {
          return Select(label: '${val.name}', value: '${val.code}');
        }).toList();
        state =
            state.copyWith(banks: banksList, filteredList: responseModel.data);
      }
    } catch (e) {
      // _logger.e(e);
    }
  }

  Future<void> checkWalletPinStatus(String userId) async {
    state = state.copyWith(isLoading: true);
    final response =
        await WalletRepository.instance.checkWalletPinStatus(userId);
    if (response.success == true) {
      final walletData = response.data["data"]["wallet"];
      state =
          state.copyWith(data: Wallet.fromJson(walletData), isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> requestPayoutMethod(BuildContext ctx,
      {required String purpose,
      required String referenceId,
      required String accountNumber,
      required String accountName,
      required String bankName,
      required String bankCode,
      required VoidCallback goBackTo}) async {
    try {
      final response = await WalletRepository.instance.requestPayout(
        purpose: purpose,
        referenceId: referenceId,
        accountNumber: accountNumber,
        accountName: accountName,
        bankName: bankName,
        bankCode: bankCode,
      );

      //  WayaNav.goBack();
      if (response.success && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              'Payout Method added successfully!',
              style: TextStyle(
                  fontFamily: WayaConstants.fontFamily, fontSize: 12.sp),
            ),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
        goBackTo();
      } else {
        if (WayaNav.context.mounted) {
          WayaUtils.showModalSheet(WayaNav.context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchUserPayoutTransaction(String referenceId, String purpose,
      {int page = 1, int limit = 100}) async {
    try {
      final response = await WalletRepository.instance
          .fetchPayoutHistory(referenceId, purpose, page: page, limit: limit);

      if (response.success) {
        PayoutHistoryModelBase responseModel =
            PayoutHistoryModelBase.fromJson(response.data);

        state =
            state.copyWith(payoutHistoryList: responseModel.data?.docs ?? []);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }
}

@riverpod
class WalletFundingOptions extends _$WalletFundingOptions {
  @override
  WalletFundingOptionState build() {
    return WalletFundingOptionState();
  }

  Future<void> getWalletFundingOptions() async {
    state = state.copyWith(isLoading: true);
    final response = await WalletRepository.instance.getWalletFundingOptions();
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
    //final user = _setupState.user?.user;

    final response = await WalletRepository.instance.fundWallet(
      FundWallet(
          userId: ConversationState.self.id,
          amount: amount,
          description: decription ?? "Wallet funding",
          email: ConversationState.self.email!,
          fundOptionCode: fundOptionCode,
          callbackUrl: AppEnvironment.webUrl),
    );

    if (response.success) {
      final resData = response.data["data"];
      return resData;
    } else {
      return null;
    }
  }

  Future<bool> verifyWalletPin(String pin) async {
    final setupState = ref.read(successfulSetupProvider);
    final user = setupState.user?.user;
    final response = await WalletRepository.instance
        .confirmWalletPin(ConfirmWalletPin(userId: user!.id, pin: pin));
    if (response.success) {
      return true;
    } else {
      return false;
    }
  }
}

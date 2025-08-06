import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/service/repos/transactions/transaction_history_model.dart';
import 'package:wayagram/core/service/repos/transactions/transaction_repository.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/wallet/data/repo/wallet_repository.dart';
import 'package:wayagram/features/wallet/transactions/model/transaction_history_model.dart';
import 'package:wayagram/features/wallet/transactions/model/transaction_history_state_model.dart';

class TransactionVm extends StateNotifier<TransactionHistoryState> {
  final TransactionRepository _transactionRepository;
  final WalletRepository _walletRepository;
  final WayaLocalDataSource _localDataSource;

  TransactionVm(this._transactionRepository, this._walletRepository,
      this._localDataSource)
      : super(TransactionHistoryState()); //

  Future<void> getTransaction(
      {int? page = 1,
      int? limit = 10,
      bool? hasNextPage,
      bool isFirst = false,
      String? filters}) async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _transactionRepository.getUserTransactions(
          page: page, limit: limit, filters: filters);
      state = state.copyWith(isLoading: false);

      if (response.success) {
        if (isFirst) {
          state = state.copyWith(
            docs: [],
          );
        }
        TransactionHistoryModel responseModel =
            TransactionHistoryModel.fromJson(response.data);
        state = state.copyWith(
            isLoading: false,
            docs: responseModel.data?.docs,
            totalCreditTransaction: responseModel
                        .data?.totalCreditTransaction ==
                    null
                ? 0
                : double.parse('${responseModel.data?.totalCreditTransaction}'),
            totalDebitTransaction: responseModel.data?.totalDebitTransaction ==
                    null
                ? 0
                : double.parse('${responseModel.data?.totalDebitTransaction}'),
            hasNextPage: responseModel.data?.hasNextPage);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  Future<void> getUserTransactions(
      {int? page = 1,
      int? limit = 10,
      bool? hasNextPage,
      String? filters}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _transactionRepository.getUserTransactions(
          page: page, limit: limit, filters: filters);
      if (response.success) {
        log("${response.data}");
        final transactions = (response.data["data"]["docs"] as List)
            .map((transaction) => TransactionDetail.fromJson(transaction))
            .toList();
        final totalCreditTransaction =
            double.parse(response.data["data"]["totalCreditTransaction"]);
        final totalDebitTransaction =
            double.parse(response.data["data"]["totalDebitTransaction"]);
        final hasNextPage = response.data["data"]["hasNextPage"];
        state = state.copyWith(
            isLoading: false,
            transactions: transactions,
            totalCreditTransaction: totalCreditTransaction,
            totalDebitTransaction: totalDebitTransaction,
            hasNextPage: hasNextPage);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getSingleTransactions(String transactionId) async {
    try {
      state = state.copyWith(isLoadingSingle: true);
      final response =
          await _transactionRepository.getSingleTransactions(transactionId);
      if (response.success) {
        final transaction = TransactionDetail.fromJson(response.data["data"]);
        log("$transaction");
        state =
            state.copyWith(isLoadingSingle: false, transaction: transaction);
      } else {
        state = state.copyWith(isLoadingSingle: false);
      }
    } catch (e) {
      state = state.copyWith(isLoadingSingle: false);
    }
  }

  Future<void> downloadPdf(String fileName) async {
    state = state.copyWith(isLoading: true);

    try {
      //? Request storage permission
      //? to request only on required Android Devices
      checkAndRequestStoragePermission();
      /*  if (Platform.isAndroid) {
        final status = await Permission.storage.request();
       
        if (!status.isGranted) {
          state = state.copyWith(error: 'Storage permission denied');
          return;
        }
      } */

      //? Make GET request
      await _transactionRepository.getTransactionForExport();
    } catch (e) {
      state = state.copyWith(error: 'Error: $e');
    }
  }

  Future<bool> checkAndRequestStoragePermission() async {
    if (!Platform.isAndroid) return true; // Not Android, no need for permission

    // Only request permission on Android 12 or lower (SDK <= 32)
    final androidVersion = int.tryParse(
      (await File('/system/build.prop').readAsLines())
          .firstWhere((line) => line.startsWith('ro.build.version.sdk='),
              orElse: () => 'ro.build.version.sdk=33') // fallback to 33
          .split('=')[1],
    );

    if (androidVersion != null && androidVersion <= 32) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      return status.isGranted;
    }

    // Android 13+ (SDK 33+), permission not required for scoped saving
    return true;
  }

  Future<void> verifyTransaction(
      String transactionId, String fundingOption) async {
    final fundingOptionCode =
        fundingOption.toLowerCase() == "paystack" ? "PS002" : "WQ001";
    try {
      final userId = _localDataSource.getUserId();
      state = state.copyWith(isVerifying: true);
      final response = await _walletRepository.verifyWalletFunding(
          VerifyTransaction(
              transactionId: transactionId,
              userId: userId ?? "",
              fundOptionCode: fundingOptionCode));
      if (response.success) {
        log("${response.data}");
        state = state.copyWith(isVerifying: false, verified: true);
      } else {
        state = state.copyWith(isVerifying: false);
      }
    } catch (e) {
      state = state.copyWith(isVerifying: false);
    }
  }

  Future<void> loadInitialData() async {
    try {
      final list = await getTransaction2(limit: 10, page: 1);

      state = state.copyWith(transactionModel: list);

      if (mounted) {
        state = state.copyWith(isFirstLoad: false, page: 1);
      }
    } catch (e) {
      log('Error loading initial data: $e');
      if (mounted) {
        state = state.copyWith(isFirstLoad: false);
      }
    }
  }

  Future<void> loadMoreData() async {
    if (!state.hasNextPage || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      state = state.copyWith(page: state.page + 1);
      // page++;

      final list = await getTransaction2(limit: 10, page: state.page);

      if (mounted) {
        // final viewModel = ref.read(transactionVmProvider);
        //final newTransactions = viewModel.docs ?? [];
        //final newTransactions = viewModel.transactions ?? [];
        if (list.isNotEmpty) {
          // Filter out duplicates
          final existingIds = list.map((t) => t.id).toSet();
          final uniqueNewTransactions = list
              .where((transaction) => !existingIds.contains(transaction.id))
              .toList();
          uniqueNewTransactions.length;
          state = state.copyWith(transactionModel: list);

          /*  setState(() {
            docs.addAll(uniqueNewTransactions);
            hasNextPage = uniqueNewTransactions.length >= limit;
          }); */
        } else {
          state = state.copyWith(hasNextPage: false);
        }
      }
    } catch (e) {
      log('Error loading more transactions: $e');
      // page--;
      state = state.copyWith(page: state.page - 1);
    } finally {
      if (mounted) {
        state = state.copyWith(isLoadingMore: false);
      }
    }
  }

  Future<List<TransactionHistoryModelDocs>> getTransaction2(
      {int? page = 1,
      int? limit = 10,
      bool? hasNextPage,
      bool isFirst = false,
      String? filters}) async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _transactionRepository.getUserTransactions(
          page: page, limit: limit, filters: filters);
      state = state.copyWith(isLoading: false);

      if (response.success) {
        TransactionHistoryModel responseModel =
            TransactionHistoryModel.fromJson(response.data);
        state = state.copyWith(
            isLoading: false,
            //  docs: responseModel.data?.docs,
            totalCreditTransaction: responseModel
                        .data?.totalCreditTransaction ==
                    null
                ? 0
                : double.parse('${responseModel.data?.totalCreditTransaction}'),
            totalDebitTransaction: responseModel.data?.totalDebitTransaction ==
                    null
                ? 0
                : double.parse('${responseModel.data?.totalDebitTransaction}'),
            hasNextPage: responseModel.data?.hasNextPage);

        return responseModel.data?.docs ?? [];
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
    return [];
  }

  void setModelList(List<TransactionHistoryModelDocs> list) {
    state = state.copyWith(transactionModel: list);
  }
}

final hideShowBalanceProvider =
    StateProvider<bool>((ref) => WayaLocalDataSource().getShowHideBalance());

final transactionVmProvider =
    StateNotifierProvider<TransactionVm, TransactionHistoryState>((ref) {
  final transactionRepository = ref.watch(transactionRepositoryProvider);

  return TransactionVm(
      transactionRepository, WalletRepository.instance, WayaLocalDataSource());
});

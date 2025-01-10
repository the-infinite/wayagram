import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/service/repos/transactions/transaction_history_model.dart';
import 'package:wayagram/core/service/repos/transactions/transaction_repository.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/wallet/data/repo/wallet_repository.dart';
import 'package:wayagram/features/wallet/transactions/model/transaction_history_state_model.dart';

class TransactionVm extends StateNotifier<TransactionHistoryState> {
  final TransactionRepository _transactionRepository;
  final WalletRepository _walletRepository;
  final WayaLocalDataSource _localDataSource;

  TransactionVm(this._transactionRepository, this._walletRepository,
      this._localDataSource)
      : super(TransactionHistoryState());

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
        log("${transaction}");
        state =
            state.copyWith(isLoadingSingle: false, transaction: transaction);
      } else {
        state = state.copyWith(isLoadingSingle: false);
      }
    } catch (e) {
      state = state.copyWith(isLoadingSingle: false);
    }
  }

  Future<void> verifyTransaction(
      String transactionId, String fundingOption) async {
    final fundingOptionCode =
        fundingOption.toLowerCase() == "paystack" ? "PS002" : "WQ001";
    try {
      final user = _localDataSource.getUser();
      state = state.copyWith(isVerifying: true);
      final response = await _walletRepository.verifyWalletFunding(
          VerifyTransaction(
              transactionId: transactionId,
              userId: user.id ?? "",
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
}

final transactionVmProvider =
    StateNotifierProvider<TransactionVm, TransactionHistoryState>((ref) {
  return TransactionVm(
      TransactionRepository(), WalletRepository(), WayaLocalDataSource());
});

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/service/repos/transactions/transaction_history_model.dart';
import 'package:wayagram/core/service/repos/transactions/transaction_repository.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/wallet/data/repo/wallet_repository.dart';
import 'package:wayagram/features/wallet/transactions/model/transaction_history_state_model.dart';
import 'package:wayagram/features/wallet/transactions/model/transaction_model.dart';

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
      String? filters}) async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _transactionRepository.getUserTransactions(
          page: page, limit: limit, filters: filters);
      state = state.copyWith(isLoading: false);
      debugPrint('API Response: ${response.data}');
      debugPrint('Status Code: ${response.statusCode}');

      if (response.success) {
        TransactionModel responseModel =
            TransactionModel.fromJson(response.data);
        state = state.copyWith(
            isLoading: false,
            docs: responseModel.data?.docs,
            totalCreditTransaction: double.parse('${responseModel.data?.totalCreditTransaction}'),
            totalDebitTransaction: double.parse('${responseModel.data?.totalDebitTransaction}'),
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
      getTransaction(limit: 10, page: state.page);

      if (mounted) {
        state = state.copyWith(isFirstLoad: false);

        // Update transactions with initial data

        if (state.docs != null) {
          state = state.copyWith(
              docs: state.docs, 
            //  hasNextPage: state.hasNextPage ?? false
              );
          //  docs = viewModel.docs!;
          //hasNextPage = viewModel.hasNextPage ?? false;
        }
      }
    } catch (e) {
      log('Error loading initial data: $e');
      if (mounted) {
        state = state.copyWith(isFirstLoad: false);
        /*  setState(() {
          isFirstLoad = false;
        }); */
      }
    }
  }

  Future<void> loadMoreData() async {
    if (!state.hasNextPage! || state.isLoadingMore!) return;

    state = state.copyWith(isLoadingMore: true);
    /*  setState(() {
      isLoadingMore = true;
    }); */


    try {
      state = state.copyWith(page: state.page! + 1);
      // page++;

      getTransaction(limit: 10, page: state.page!);

      if (mounted) {
        //  final viewModel = ref.read(transactionVmProvider);
        //final newTransactions = viewModel.docs ?? [];
        //final newTransactions = viewModel.transactions ?? [];

        if (state.docs!.isNotEmpty) {
          // Filter out duplicates
          final existingIds = state.docs!.map((t) => t.id).toSet();
          final uniqueNewTransactions = state.docs!
              .where((transaction) => !existingIds.contains(transaction.id))
              .toList();
          state = state.copyWith(
              docs: [...state.docs!, ...uniqueNewTransactions],
              hasNextPage: uniqueNewTransactions.length >= 10);

          /*  setState(() {
            docs.addAll(uniqueNewTransactions);
            hasNextPage = uniqueNewTransactions.length >= limit;
          }); */
        } else {
          state = state.copyWith(hasNextPage: false);
          /*  setState(() {
            hasNextPage = false;
          }); */
        }
      }
    } catch (e) {
      log('Error loading more transactions: $e');
      state = state.copyWith(page: state.page! - 1);
      // page--;
    } finally {
      if (mounted) {
        state = state.copyWith(isLoadingMore: false);
        /*  setState(() {
          isLoadingMore = false;
        }); */
      }
    }
  }
}

final transactionVmProvider =
    StateNotifierProvider<TransactionVm, TransactionHistoryState>((ref) {
  return TransactionVm(TransactionRepository(), WalletRepository.instance,
      WayaLocalDataSource());
});

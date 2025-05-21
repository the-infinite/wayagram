import 'package:wayagram/core/service/repos/transactions/transaction_history_model.dart';
import 'package:wayagram/features/wallet/transactions/model/transaction_history_model.dart';

class TransactionHistoryState {
  final int? page;
  final bool? isLoading;
  final bool? isLoadingSingle;
  final bool? isVerifying;
  final bool? verified;
  final bool? isFirstLoad;


  final bool? hasNextPage;
  final bool? isLoadingMore;
  final List<TransactionDetail>? transactions;
  final TransactionDetail? transaction;
  List<TransactionHistoryModelDocs>? docs;
  final double totalCreditTransaction;
  final double totalDebitTransaction;

  TransactionHistoryState({
    this.page = 1,
    this.isLoading = false,
    this.isLoadingSingle = false,
    this.isVerifying = false,
    this.verified = false,
    this.isFirstLoad = false,
    this.isLoadingMore = false,
    this.hasNextPage = true,
    this.docs = const [],
    this.transactions,
    this.transaction,
    this.totalCreditTransaction = 0.0,
    this.totalDebitTransaction = 0.0,
  });

  TransactionHistoryState copyWith(
      {bool? isLoading,
      bool? isVerifying,
      bool? isFirstLoad,
      bool? verified,
      bool? isLoadingMore,
      int? page,
      bool? isLoadingSingle,
      bool? hasNextPage,
      List<TransactionDetail>? transactions,
      TransactionDetail? transaction,
      List<TransactionHistoryModelDocs>? docs,
      double? totalCreditTransaction,
      double? totalDebitTransaction}) {
    return TransactionHistoryState(
        page: page ?? this.page,
        isLoading: isLoading ?? this.isLoading,
        isVerifying: isVerifying ?? this.isVerifying,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
       
        isLoadingSingle: isLoadingSingle ?? this.isLoadingSingle,
        verified: verified ?? this.verified,
        isFirstLoad: isFirstLoad ?? this.isFirstLoad,
        hasNextPage: hasNextPage ?? this.hasNextPage,
        transactions: transactions ?? this.transactions,
        transaction: transaction ?? this.transaction,
        docs: docs ?? this.docs,
        totalCreditTransaction:
            totalCreditTransaction ?? this.totalCreditTransaction,
        totalDebitTransaction:
            totalDebitTransaction ?? this.totalDebitTransaction);
  }
}

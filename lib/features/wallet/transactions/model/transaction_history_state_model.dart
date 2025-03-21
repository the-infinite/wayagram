import 'package:wayagram/core/service/repos/transactions/transaction_history_model.dart';
import 'package:wayagram/features/wallet/transactions/model/transaction_model.dart';

class TransactionHistoryState {
  final bool? isLoading;
  final bool? isLoadingSingle;
  final bool? isVerifying;
  final bool? verified;
  final bool? hasNextPage;
  final List<TransactionDetail>? transactions;
  final TransactionDetail? transaction;
  List<TransactionModelDocs>? docs;
  final double totalCreditTransaction;
  final double totalDebitTransaction;

  TransactionHistoryState({
    this.isLoading = false,
    this.isLoadingSingle = false,
    this.isVerifying = false,
    this.verified = false,
    this.hasNextPage = false,
    this.docs = const [],
    this.transactions,
    this.transaction,
    this.totalCreditTransaction = 0.0,
    this.totalDebitTransaction = 0.0,
  });

  TransactionHistoryState copyWith(
      {bool? isLoading,
      bool? isVerifying,
      bool? verified,
      bool? isLoadingSingle,
      bool? hasNextPage,
      List<TransactionDetail>? transactions,
      TransactionDetail? transaction,
        List<TransactionModelDocs>? docs,
      double? totalCreditTransaction,
      double? totalDebitTransaction}) {
    return TransactionHistoryState(
        isLoading: isLoading ?? this.isLoading,
        isVerifying: isVerifying ?? this.isVerifying,
        isLoadingSingle: isLoadingSingle ?? this.isLoadingSingle,
        verified: verified ?? this.verified,
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

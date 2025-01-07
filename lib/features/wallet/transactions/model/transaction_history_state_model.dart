import 'package:wayagram/core/service/repos/transactions/transaction_history_model.dart';

class TransactionHistoryState {
  final bool? isLoading;
  final bool? isLoadingSingle;
  final bool? isVerifying;
  final bool? verified;
  final List<TransactionDetail>? transactions;
  final TransactionDetail? transaction;

  TransactionHistoryState({
    this.isLoading = false,
    this.isLoadingSingle = false,
    this.isVerifying = false,
    this.verified = false,
    this.transactions,
    this.transaction,
  });

  TransactionHistoryState copyWith(
      {bool? isLoading,
      bool? isVerifying,
      bool? verified,
      List<TransactionDetail>? transactions,
      TransactionDetail? transaction,
      bool? isLoadingSingle}) {
    return TransactionHistoryState(
        isLoading: isLoading ?? this.isLoading,
        isVerifying: isVerifying ?? this.isVerifying,
        verified: verified ?? this.verified,
        transactions: transactions ?? this.transactions,
        transaction: transaction ?? this.transaction,
        isLoadingSingle: isLoadingSingle ?? this.isLoadingSingle);
  }
}

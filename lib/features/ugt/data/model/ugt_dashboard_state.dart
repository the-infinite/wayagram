import 'package:wayagram/features/ugt/data/model/contest_transaction_model.dart';
import 'package:wayagram/features/ugt/data/model/contestant_transaction_model.dart';

class UgtDashboardState {
  final int? revenueGenerated;
  final int? totalContestants;
  final int? contestStageCount;
  final int? totalCommission;
  final List<Transaction> transactionList;
  final List<ContestTransactionModel> contestTransactionHistoryList;
  final List<ContestTransactionModel> contestPayoutHistoryList;

  UgtDashboardState({
    this.revenueGenerated = 0,
    this.totalContestants = 0,
    this.contestStageCount = 0,
    this.totalCommission = 0,
    this.transactionList = const [],
    this.contestTransactionHistoryList = const [],
    this.contestPayoutHistoryList = const [],
  });

  UgtDashboardState copyWith({
    int? revenueGenerated,
    int? totalContestants,
    int? contestStageCount,
    int? totalCommission,
    List<Transaction>? transactionList,
    List<ContestTransactionModel>? contestTransactionHistoryList,
    List<ContestTransactionModel>? contestPayoutHistoryList,
  }) =>
      UgtDashboardState(
        revenueGenerated: revenueGenerated ?? this.revenueGenerated,
        totalContestants: totalContestants ?? this.totalContestants,
        totalCommission: totalCommission ?? this.totalCommission,
        contestStageCount: contestStageCount ?? this.contestStageCount,
        transactionList: transactionList ?? this.transactionList,
        contestTransactionHistoryList: contestTransactionHistoryList ?? this.contestTransactionHistoryList,
        contestPayoutHistoryList: contestPayoutHistoryList ?? this.contestPayoutHistoryList,
      );
}

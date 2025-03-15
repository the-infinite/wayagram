import 'package:wayagram/features/ugt/data/model/contestant_transaction_model.dart';

class UgtDashboardState {
  final int? revenueGenerated;
  final int? totalContestants;
  final int? contestStageCount;
  final List<Transaction> transactionList;

  UgtDashboardState({
    this.revenueGenerated = 0,
    this.totalContestants = 0,
    this.contestStageCount = 0,
    this.transactionList = const [],
  });

  UgtDashboardState copyWith({
    int? revenueGenerated,
    int? totalContestants,
    int? contestStageCount,
    List<Transaction>? transactionList,
  }) =>
      UgtDashboardState(
        revenueGenerated: revenueGenerated ?? this.revenueGenerated,
        totalContestants: totalContestants ?? this.totalContestants,
        contestStageCount: contestStageCount ?? this.contestStageCount,
        transactionList: transactionList ?? this.transactionList,
      );
}

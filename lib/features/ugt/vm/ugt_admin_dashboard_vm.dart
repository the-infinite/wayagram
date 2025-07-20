import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/ugt/data/model/contest_transaction_model.dart';

import 'package:wayagram/features/ugt/data/model/contestant_count_model.dart';
import 'package:wayagram/features/ugt/data/model/contestant_transaction_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_dashboard_state.dart';
import 'package:wayagram/features/ugt/data/repository/contest_repo.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

import '../../../core/data/local_data_source.dart';

class UgtAdminDashboardVm extends StateNotifier<UgtDashboardState> {
  final ContestRepo _contestRepository;

  UgtAdminDashboardVm(this._contestRepository) : super(UgtDashboardState());

  Future<void> fetchTotalEarnings(String id, String filter) async {
    try {
      final response = await _contestRepository.fetchAllTotalEarningContest(id, filter);

      if (response.success) {
        ContestantTransactionModel responseModel = ContestantTransactionModel.fromJson(response.data);
        //  contestList = responseModel.data;

        state = state.copyWith(
            revenueGenerated: responseModel.data?.totalSum ?? 0,
            transactionList: responseModel.data?.transactions ?? []);
      }
    } catch (e) {
      //debugPrint(e.toString());
    } finally {}
  }

  Future<void> fetchTotalContestant(String id) async {
    try {
      final response = await _contestRepository.fetchAllTotalContest(id);

      if (response.success) {
        ContestantCountModel responseModel = ContestantCountModel.fromJson(response.data);
        //  contestList = responseModel.data;

        state = state.copyWith(totalContestants: responseModel.data?.totalContestants ?? 0);
      }
    } catch (e) {
      //debugPrint(e.toString());
    } finally {}
  }

  Future<void> fetchVotesStat(String id) async {
    try {
      final response = await _contestRepository.fetchVoteStatsContest(id);

      if (response.success) {
        //VoteStatisticModel responseModel = VoteStatisticModel.fromJson(response.data);
        //  contestList = responseModel.data;
      }
    } catch (e) {
      //debugPrint(e.toString());
    } finally {}
  }

  Future<void> fetchUserTransaction(String contestId) async {
    try {
      final response = await _contestRepository.fetchTransactionHistory(contestId);
      List<ContestTransactionModel> modelList = [];
      if (response.success) {
        ContestTransactionModelBase responseModel = ContestTransactionModelBase.fromJson(response.data);

        int totalCommission = 0;
        for (var model in responseModel.data?.docs ?? []) {
          totalCommission += int.tryParse(model.commission ?? '') ?? 0;
        }
        //
        for (var modelNew in responseModel.data!.docs!) {
          var data = await UserResource.getUserDetails(modelNew.userId ?? "");
          var userModel = data?.$2;
          //var userModel1 = data?.$1;

          modelNew.name = userModel?.displayName ?? "";
          modelList.add(modelNew);
        }
        state = state.copyWith(contestTransactionHistoryList: modelList);

        //
        state = state.copyWith(totalCommission: totalCommission);
      }
    } catch (e) {
      //debugPrint(e.toString());
    } finally {}
  }

  Future<void> fetchUserPayoutTransaction(String contestId) async {
    try {
      final response = await _contestRepository.fetchPayoutHistory(contestId);

      if (response.success) {
        //ContestTransactionModelBase responseModel = ContestTransactionModelBase.fromJson(response.data);
        /*  PayoutHistoryModelBase responseModel =
            PayoutHistoryModelBase.fromJson(response.data); */

        /*   state = state.copyWith(
            contestPayoutHistoryList: responseModel.data?.docs ?? []); */
      }
    } catch (e) {
      //debugPrint(e.toString());
    } finally {}
  }
}

final ugtAdminDashboardVm = StateNotifierProvider<UgtAdminDashboardVm, UgtDashboardState>(
  (ref) {
    return UgtAdminDashboardVm(ContestRepo());
  },
);

final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

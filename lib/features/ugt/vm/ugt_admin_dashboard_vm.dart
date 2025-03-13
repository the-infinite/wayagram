import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/utils/utils.dart';

import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/ugt/create_contest_post/create_contest_post.dart';
import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart';
import 'package:wayagram/features/ugt/data/model/contestant_count_model.dart';
import 'package:wayagram/features/ugt/data/model/contestant_transaction_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_all_post_contest_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_contest_aplicant_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_dashboard_state.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart' as model;
import 'package:wayagram/features/ugt/data/model/vote_statistic_model.dart';
import 'package:wayagram/features/ugt/data/model/voter_contest_state.dart';

import 'package:wayagram/features/ugt/data/repository/ContestRepo.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/wallet/data/model/external_wallet_model.dart';
import 'package:wayagram/features/wallet/data/model/wallet_model.dart';

import 'package:wayagram/features/wallet/data/repo/wallet_repository.dart';
import 'package:wayagram/shared/features/file/repo/default.dart';
import '../../../core/data/local_data_source.dart';

import '../../../core/service/logger_service.dart';

class UgtAdminDashboardVm extends StateNotifier<UgtDashboardState> {
  final ContestRepo _contestRepository;
  final WayaLocalDataSource _localDataSource;
  final WalletRepository? _walletRepository;

  final _logger = getLogger('ContestRepo');

  UgtAdminDashboardVm(
      this._contestRepository, this._localDataSource, this._walletRepository)
      : super(UgtDashboardState());

  Future<void> fetchTotalEarnings(String id, String filter) async {
    try {
      final response =
          await _contestRepository.fetchAllTotalEarningContest(id, filter);

      if (response.success) {
        ContestantTransactionModel responseModel =
            ContestantTransactionModel.fromJson(response.data);
        //  contestList = responseModel.data;

        state =
            state.copyWith(revenueGenerated: responseModel.data?.totalSum ?? 0, transactionList: responseModel.data?.transactions??[]);
      }
    } catch (e) {
      //print(e);
    } finally {}
  }

  Future<void> fetchTotalContestant(String id) async {
    try {
      final response = await _contestRepository.fetchAllTotalContest(id);

      if (response.success) {
        ContestantCountModel responseModel =
            ContestantCountModel.fromJson(response.data);
        //  contestList = responseModel.data;

        state = state.copyWith(
            totalContestants: responseModel.data?.totalContestants ?? 0);
      }
    } catch (e) {
      //print(e);
    } finally {}
  }

  Future<void> fetchVotesStat(String id) async {
    try {
      final response = await _contestRepository.fetchVoteStatsContest(id);

      if (response.success) {
        VoteStatisticModel responseModel =
            VoteStatisticModel.fromJson(response.data);
        //  contestList = responseModel.data;
      }
    } catch (e) {
      //print(e);
    } finally {}
  }
}

final ugtAdminDashboardVm =
    StateNotifierProvider<UgtAdminDashboardVm, UgtDashboardState>(
  (ref) {
    return UgtAdminDashboardVm(
        ContestRepo(), WayaLocalDataSource(), WalletRepository.instance);
  },
);

final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart';
import 'package:wayagram/features/ugt/data/model/contest_state.dart';
import 'package:wayagram/features/ugt/data/model/contest_vote_model.dart';
import 'package:wayagram/features/ugt/data/model/voter_contest_state.dart';

import 'package:wayagram/features/ugt/data/repository/ContestRepo.dart';
import 'package:wayagram/features/wallet/data/model/external_wallet_model.dart';
import 'package:wayagram/features/wallet/data/model/wallet_model.dart';

import 'package:wayagram/features/wallet/data/repo/wallet_repository.dart';
import '../../../core/data/local_data_source.dart';

import '../../../core/service/logger_service.dart';

class VotersContestNotifier extends StateNotifier<VoterDetailState> {
  final ContestRepo _contestRepository;
  final WayaLocalDataSource _localDataSource;
  final WalletRepository? _walletRepository;

  final _logger = getLogger('ContestRepo');

  VotersContestNotifier(
      this._contestRepository, this._localDataSource, this._walletRepository)
      : super(VoterDetailState());

  Future<bool> verifyWalletPin(String pin, Map<String, String> map) async {
    final response = await _walletRepository!.confirmWalletPin(ConfirmWalletPin(
        userId: _localDataSource.getUserId().toString(), pin: pin));
    if (response.success) {
      print(map);
      map["profileId"] = _localDataSource.getUserId().toString();
      return await voteContestant(map);
    } else {
      return false;
    }
  }

  Future<bool> voteContestant(Map<String, String> map) async {
    final response = await _contestRepository.voteContestant(map);
    if (response.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getUserWallet() async {
    state = state.copyWith(isLoading: true);
    final response = await _walletRepository!.getUserWallet();
    if (response.success == true) {
      final walletData = response.data["data"]["wallet"];
      final walletAccountsData = response.data["data"]["walletAccounts"];
      final externalWallets = (walletAccountsData as List)
          .map((walletAccount) => ExternalWalletModel.fromJson(walletAccount))
          .toList();
      state = state.copyWith(
          data: Wallet.fromJson(walletData),
          externalWallets: externalWallets,
          isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getContestantProfileVoteDetails(String contestId) async {
    try {
      final response =
          await _contestRepository.getContestantProfileVoteDetails(contestId);
      List<MyContestContestantModel> contestList = [];
      if (response.success) {
        ContestContestantModelMean responseModel =
            ContestContestantModelMean.fromJson(response.data);
        contestList = responseModel.data ?? [];
        state = state.copyWith(myContestList: contestList);
        // _page++;
        //isLoading = false;
      }
      // return contestList;
    } catch (e) {
      print(e);
    } finally {
      // isLoading = false;
    }
  }
}

final authRepositoryProvider = Provider((ref) => ContestRepo());

final votersContestNotifier =
    StateNotifierProvider<VotersContestNotifier, VoterDetailState>(
  (ref) {
    return VotersContestNotifier(
        ContestRepo(), WayaLocalDataSource(), WalletRepository());
  },
);

final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

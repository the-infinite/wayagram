import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wayagram/features/role_access/vm/states/role_access_state.dart';
import 'package:wayagram/features/ugt/data/repository/ContestRepo.dart';
import 'package:wayagram/features/wallet/data/repo/wallet_repository.dart';
import '../../../core/data/local_data_source.dart';

class RoleAccessVm extends StateNotifier<RoleAccessState> {
  final ContestRepo _contestRepository;
  final WayaLocalDataSource _localDataSource;
  final WalletRepository? _walletRepository;
// controllers
  late TextEditingController firstName;
  late TextEditingController lastName;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController confirmPassword;
  // final _logger = getLogger('ContestRepo');

  RoleAccessVm(
      this._contestRepository, this._localDataSource, this._walletRepository)
      : super(RoleAccessState()) {
    firstName = TextEditingController();
    lastName = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
  }
}

final roleAccessVm = StateNotifierProvider<RoleAccessVm, RoleAccessState>(
  (ref) {
    return RoleAccessVm(
        ContestRepo(), WayaLocalDataSource(), WalletRepository.instance);
  },
);

final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

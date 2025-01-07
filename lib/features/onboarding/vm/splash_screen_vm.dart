import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/account_creation/data/model/business_account_model.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';

class SplashScreenVm extends StateNotifier<void> {
  final ProfileRepo _profileRepo;
  final WayaSecureDataSource _secureDataSource;
  final SuccessfulSetupVm _setupVm;

  SplashScreenVm(this._profileRepo, this._secureDataSource, this._setupVm)
      : super(null);

  void getUserData() async {
    try {
      // check if user has a token
      String? authToken = await _secureDataSource.getToken();

      if (authToken == null) return WayaNav.toNamed("/onboarding");

      // check if user has an ID
      final userId = await _secureDataSource.getUserId();

      if (userId == null) return WayaNav.toNamed('/login-cover-page');

      final response = await _profileRepo.getUserDataRepo(userId: userId);

      if (response.success) {
        UserAccountModel userAccountModel =
            UserAccountModel.fromJson(response.data);

        _setupVm.state = _setupVm.state.copyWith(user: userAccountModel.data);

        if (userAccountModel.data != null &&
            userAccountModel.data!.role!.name != 'PERSONAL') {
          final bizResponse =
              await _profileRepo.getBusinessDataRepo(userId: userId);

          if (bizResponse.success) {
            BusinessAccountData bizData =
                BusinessAccountData.fromJson(bizResponse.data);
            _setupVm.state = _setupVm.state.copyWith(business: bizData);
          }
        }

        WayaNav.toNamed('/welcome-back');
      } else {
        WayaNav.toNamed('/login-cover-page');
      }
    } catch (e) {
      WayaNav.toNamed('/login-cover-page');
    }
  }

  void runStartUpLogic() async {
    getUserData();
  }
}

final splashScreenVmProvider = StateNotifierProvider((ref) {
  final successfulSetupVm = ref.read(successfulSetupVmProvider.notifier);
  return SplashScreenVm(
      ProfileRepo(), WayaSecureDataSource(), successfulSetupVm);
});

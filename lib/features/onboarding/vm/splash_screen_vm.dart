import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';

class SplashScreenVm extends StateNotifier<void> {
  final ProfileRepo _profileRepo;
  final WayaLocalDataSource _localDataSource;
  final WayaSecureDataSource _secureDataSource;

  SplashScreenVm(
      this._profileRepo, this._localDataSource, this._secureDataSource)
      : super(null);

  void getUserData() async {
    try {
      // check if user has a token
      String? authToken = await _secureDataSource.getToken();

      if (authToken == null) return WayaNav.toNamed("/onboarding");

      // check if user has an ID
      final userId = _localDataSource.getUserId();

      if (userId == null) return WayaNav.toNamed('/login-cover-page');

      final response = await _profileRepo.getUserDataRepo(userId: userId);

      if (response.success) {
        UserAccountModel userAccountModel =
            UserAccountModel.fromJson(response.data);

        _localDataSource.saveUser(userAccountModel.data!);
        WayaNav.toNamed('/welcome-back');
      } else {
        WayaNav.toNamed('/login-cover-page');
      }
    } catch (e) {
      WayaNav.toNamed('/login-cover-page');
    }
  }

  void runStartUpLogic() async {
    // Future.delayed(Duration(seconds: 3), () {
    // navigate to home
    // });
    getUserData();
  }
}

final splashScreenVmProvider = StateNotifierProvider((ref) => SplashScreenVm(
    ProfileRepo(), WayaLocalDataSource(), WayaSecureDataSource()));

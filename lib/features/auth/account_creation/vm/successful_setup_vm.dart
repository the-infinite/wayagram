import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/account_creation/data/model/business_account_model.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';

class SuccessfulSetUpState {
  final bool isloading;

  SuccessfulSetUpState({this.isloading = false});

  SuccessfulSetUpState copyWith({bool? isloading}) {
    return SuccessfulSetUpState(isloading: isloading ?? this.isloading);
  }
}

class SuccessfulSetupVm extends StateNotifier<SuccessfulSetUpState> {
  final ProfileRepo _profileRepo;
  final WayaLocalDataSource _localDataSource;
  final WayaSecureDataSource _secureDataSource;

  SuccessfulSetupVm(
      this._profileRepo, this._localDataSource, this._secureDataSource)
      : super(SuccessfulSetUpState());

  void getUserData() async {
    try {
      state = state.copyWith(isloading: true);
      // check if user has an ID
      final userId = await _secureDataSource.getUserId();

      if (userId == null) {
        state = state.copyWith(isloading: false);
        return;
      }

      final response = await _profileRepo.getUserDataRepo(userId: userId);

      if (response.success) {
        UserAccountModel userAccountModel =
            UserAccountModel.fromJson(response.data);

        _localDataSource.saveUser(userAccountModel.data!);

        if (userAccountModel.data != null &&
            userAccountModel.data!.role!.name != 'PERSONAL') {
          final bizResponse =
              await _profileRepo.getBusinessDataRepo(userId: userId);

          if (bizResponse.success) {
            BusinessAccountData bizData =
                BusinessAccountData.fromJson(bizResponse.data);
            _localDataSource.saveBusiness(bizData);
          }
        }

        WayaNav.toNamed('/explore');
      }
    } catch (e) {
      print(e);
    } finally {
      state = state.copyWith(isloading: false);
    }
  }
}

final successfulSetupVmProvider = StateNotifierProvider<SuccessfulSetupVm, SuccessfulSetUpState>((ref) =>
    SuccessfulSetupVm(
        ProfileRepo(), WayaLocalDataSource(), WayaSecureDataSource()));

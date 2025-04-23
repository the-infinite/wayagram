import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/features/auth/account_creation/data/model/business_account_model.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';

class SuccessfulSetUpState {
  final bool isloading;
  final UserAccountData? user;
  final BusinessAccountData? business;

  SuccessfulSetUpState({this.isloading = false, this.business, this.user});

  SuccessfulSetUpState copyWith({bool? isloading, BusinessAccountData? business, UserAccountData? user}) {
    return SuccessfulSetUpState(
        isloading: isloading ?? this.isloading, user: user ?? this.user, business: business ?? this.business);
  }
}

class SuccessfulSetupVm extends StateNotifier<SuccessfulSetUpState> {
  final ProfileRepo _profileRepo;
  final WayaSecureDataSource _secureDataSource;

  SuccessfulSetupVm(this._profileRepo, this._secureDataSource) : super(SuccessfulSetUpState());

  Future<void> getUserData() async {
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
        UserAccountModel userAccountModel = UserAccountModel.fromJson(response.data);

        state = state.copyWith(user: userAccountModel.data?.userdata);

        if (userAccountModel.data != null && userAccountModel.data!.userdata!.user!.role != 'PERSONAL') {
          final bizResponse = await _profileRepo.getBusinessDataRepo(userId: userId);

          if (bizResponse.success) {
            BusinessAccountData bizData = BusinessAccountData.fromJson(bizResponse.data);
            ConversationState.setSelf(null, null, BusinessDetailsModel.fromJson(bizResponse.data));
            state = state.copyWith(business: bizData);
          }
        }

        
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      state = state.copyWith(isloading: false);
    }
  }
}

final successfulSetupVmProvider = StateNotifierProvider<SuccessfulSetupVm, SuccessfulSetUpState>(
    (ref) => SuccessfulSetupVm(ProfileRepo(), WayaSecureDataSource()));

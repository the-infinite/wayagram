import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/features/auth/account_creation/data/model/business_account_model.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';

part 'successful_setup_vm.g.dart';

class SuccessfulSetUpState {
  final bool isloading;
  final UserAccountData? user;
  final BusinessAccountData? business;

  SuccessfulSetUpState({this.isloading = false, this.business, this.user});

  SuccessfulSetUpState copyWith(
      {bool? isloading, BusinessAccountData? business, UserAccountData? user}) {
    return SuccessfulSetUpState(
        isloading: isloading ?? this.isloading,
        user: user ?? this.user,
        business: business ?? this.business);
  }
}

@riverpod
class SuccessfulSetup extends _$SuccessfulSetup {
  @override
  SuccessfulSetUpState build() {
    return SuccessfulSetUpState();
  }

  Future<void> getUserData() async {
    final secureDataSource = WayaSecureDataSource();

    try {
      state = state.copyWith(isloading: true);
      // check if user has an ID
      final userId = await secureDataSource.getUserId();

      if (userId == null) {
        state = state.copyWith(isloading: false);
        return;
      }

      final response = await ref
          .read(profileRepositoryProvider)
          .getUserDataRepo(userId: userId);

      if (response.success) {
        UserAccountModel userAccountModel =
            UserAccountModel.fromJson(response.data);

        state = state.copyWith(user: userAccountModel.data?.userdata);

        if (userAccountModel.data != null &&
            userAccountModel.data!.userdata!.user!.role != 'PERSONAL') {
          final bizResponse = await ref
              .read(profileRepositoryProvider)
              .getBusinessDataRepo(userId: userId);

          if (bizResponse.success) {
            BusinessAccountData bizData =
                BusinessAccountData.fromJson(bizResponse.data);
            ConversationState.setSelf(
                null, null, BusinessDetailsModel.fromJson(bizResponse.data));
            state = state.copyWith(business: bizData);
          }
        }
      }
    } catch (_) {
    } finally {
      state = state.copyWith(isloading: false);
    }
  }
}

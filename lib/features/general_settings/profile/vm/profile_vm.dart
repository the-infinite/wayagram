import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/general_settings/profile/data/model/profile_state_model.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';

class ProfileVm extends StateNotifier<ProfileState> {
  final ProfileRepo _profileRepo;

  final WayaLocalDataSource _localDataSource;
  ProfileVm(this._profileRepo, this._localDataSource) : super(ProfileState());

  void updateAccount({String? dob, String? address}) async {
    final userId = _localDataSource.getUserId();

    try {
      state = ProfileState(isLoading: true);

      final response = await _profileRepo.updateAccount(userId: userId, dob: dob, address: address);
      if (response.success) {
        WayaSnackBar.showToast('Account Updated Successfully');
        Future.delayed(Duration(seconds: 2), () {
          WayaNav.offNamed('/general-settings');
        });
      }
      state = ProfileState(isLoading: false);
    } catch (e) {
      state = ProfileState(isLoading: false);
    }
  }

  void updateProfile({String? username, String? displayName, String? bio, bool? isPublic}) async {
    final userId = _localDataSource.getUserId();

    try {
      state = ProfileState(isLoading: true);

      final response = await _profileRepo.updateProfile(
          userId: userId, username: username, displayName: displayName, bio: bio, isPublic: isPublic);
      if (response.success) {
        WayaSnackBar.showToast('Profile Updated Successfully');
      }
      state = ProfileState(isLoading: false);
    } catch (e) {
      state = ProfileState(isLoading: false);
    }
  }
}

final profileVmProvider = StateNotifierProvider<ProfileVm, ProfileState>((ref) {
  return ProfileVm(ProfileRepo(), WayaLocalDataSource());
});

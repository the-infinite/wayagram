import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/controller/preloader.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/profile/data/model/profile_state_model.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';
import 'package:wayagram/shared/features/file/repo/default.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';
import 'package:wayagram/shared/features/moments/notifier/default.dart';

class ProfileVm extends StateNotifier<ProfileState> {
  final ProfileRepo _profileRepo;
  final WayaSecureDataSource _secureDataSource;
  final WayaLocalDataSource _localDataSource;
  ProfileVm(this._profileRepo, this._localDataSource, this._secureDataSource) : super(ProfileState());

  void refetchUserData() {
    getUserData();
  }

  void updateAccount({String? dob, String? address}) async {
    final userId = _localDataSource.getUserId();

    try {
      state = ProfileState(isLoading: true);

      final response = await _profileRepo.updateAccountRepo(userId: userId, dob: dob, address: address);
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

  Future<bool> updateProfile(
      {String? username, String? displayName, String? bio, bool? isPublic, bool load = true}) async {
    final userId = _localDataSource.getUserId();

    // Get the last update and creation dates
    final lastUsernameUpdate = state.userAccountModel!.data!.userdata!.profile!.updatedAt ?? DateTime.now();
    final lastDisplayNameUpdate = state.userAccountModel!.data!.userdata!.profile!.createdAt ?? DateTime.now();

    // Check if the account is newly created
    final isNewAccount = lastUsernameUpdate.isAtSameMomentAs(lastDisplayNameUpdate);

    // Determine if updates are allowed based on the conditions
    final canUpdateUsername = isNewAccount || DateTime.now().difference(lastUsernameUpdate).inDays >= 30;
    final canUpdateDisplayName = isNewAccount || DateTime.now().difference(lastDisplayNameUpdate).inDays >= 7;

    // Check if username can be updated
    if (username != null && !canUpdateUsername) {
      WayaSnackBar.showToast('You can only update your username once every 30 days.');
      return false;
    }

    // Check if display name can be updated
    if (displayName != null && !canUpdateDisplayName) {
      WayaSnackBar.showToast('You can only update your display name once every 7 days.');
      return false;
    }

    try {
      state = state.copyWith(isLoading: load);

      final response = await _profileRepo.updateProfileRepo(
          userId: userId, username: username, displayName: displayName, bio: bio, isPublic: isPublic);
      if (response.success) {
        WayaSnackBar.showToast('Profile Updated Successfully');
        isPublic != null
            ? null
            : Future.delayed(Duration(seconds: 2), () {
                WayaNav.removeUntilNamed(BottomView.route);
                WayaNav.offNamed(GeneralSettingsPage.route);
              });
        refetchUserData();
        state = state.copyWith(
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(isLoading: false);
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  void getUserData() async {
    final userId = _localDataSource.getUserId();

    try {
      state = state.copyWith(isLoading: true);
      final response = await _profileRepo.getUserDataRepo(userId: userId);

      if (response.success) {
        UserAccountModel userAccountModel = UserAccountModel.fromJson(response.data);

        //? Set who is currently logged in somewhere that is easily accessible
        //? for conversation's sake.
        ConversationState.setSelf(
          userAccountModel.data?.userdata?.user,
          userAccountModel.data?.userdata?.profile,
          userAccountModel.data?.userdata?.business,
        );

        // Finally, update general state.
        state = state.copyWith(userAccountModel: userAccountModel, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> logOutUser() async {
    await _secureDataSource.saveToken("");
    await _secureDataSource.saveRefreshToken("");
    await _secureDataSource.saveBusinessId("");
    myFollowProvider.reset();
    otherUserMoments.reset();
    _localDataSource.saveUserId("");
    await _secureDataSource.saveUserId("");
    WayaNav.removeUntilNamed(LoginCoverPage.route);
  }

  void updateProfilePicture() async {
    final userId = _localDataSource.getUserId();
    File? profileImage = await WayaUtils.pickAndCropImage();
    if (profileImage != null) {
      Uint8List imageBytes = await profileImage.readAsBytes();

      try {
        state = state.copyWith(isLoading: true);
        final response = await _profileRepo.updateProfileImageRepo(
            userId: userId, fileName: WayaHelpers.extractFileName(profileImage), image: imageBytes);

        if (response.success) {
          WayaSnackBar.showToast('Profile Picture Updated Successfully');
          refetchUserData();
        }
        state = state.copyWith(isLoading: false);
      } catch (e) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  void updateCoverPhoto() async {
    File? profileImage = await WayaUtils.pickAndCropImage();

    //? If this finishes early...
    if (profileImage == null) return;

    try {
      //? First, show the preloader.
      WayaPreloaderController.instance.show();

      //? Second, try uploading this image.
      final result = await WayaFileRepository.instance.uploadFile(profileImage,
          '${DateTime.now().millisecondsSinceEpoch}-${ConversationState.self.id}-${WayaHelpers.extractFileName(profileImage)}');

      //? If this failed.
      if (result == null) {
        WayaPreloaderController.instance.hide();
        WayaSnackBar.showToast('Failed to update profile picture.');
        return;
      }

      //? Now, try submitting the result to the person who needs it.
      final response = await _profileRepo.updateProfileRepo(userId: ConversationState.self.id, coverPhoto: result);

      //? This is fine too.
      if (response.success) {
        WayaSnackBar.showToast('Cover photo updated successfully');

        //? Update this user's data.
        refetchUserData();
      }

      //? Hide.
    } catch (_) {}

    WayaPreloaderController.instance.hide();
  }
}

final profileVmProvider = StateNotifierProvider<ProfileVm, ProfileState>((ref) {
  return ProfileVm(
    ProfileRepo(),
    WayaLocalDataSource(),
    WayaSecureDataSource(),
  );
});

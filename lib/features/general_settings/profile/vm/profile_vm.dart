import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/components/modals/error.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/controller/preloader.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/profile/data/model/profile_state_model.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';
import 'package:wayagram/features/general_settings/profile/view/edit_profile_page.dart';
import 'package:wayagram/features/notifications/vm/notification_vm.dart';
import 'package:wayagram/shared/cache/comment.dart';
import 'package:wayagram/shared/cache/group.dart';
import 'package:wayagram/shared/cache/page.dart';
import 'package:wayagram/shared/cache/post.dart';
import 'package:wayagram/shared/features/file/repo/waya_file_repository.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';
import 'package:wayagram/shared/features/group/notifier/group_notifier.dart';
import 'package:wayagram/shared/features/pages/notifier/default.dart';
import 'package:wayagram/shared/features/shop/resource/shop_resource.dart';

class ProfileVm extends StateNotifier<ProfileState> {
  final ProfileRepo _profileRepo;
  final Ref _ref;
  final WayaSecureDataSource _secureDataSource;
  final WayaLocalDataSource _localDataSource;
  ProfileVm(this._profileRepo, this._localDataSource, this._secureDataSource,
      this._ref)
      : super(ProfileState());

  void refetchUserData() {
    getUserData();
  }

  void updateUniqueFields(
      {required String code,
      required String purpose,
      String? email,
      String? phone}) async {
    //final userId = _localDataSource.getUserId();

    try {
      state = ProfileState(isLoading: true);

      final response = await _profileRepo.updateEmailOrPhone(
          userId: ConversationState.self.id,
          phone: phone,
          email: email,
          otp: code,
          purpose: purpose);
      if (response.success) {
        WayaSnackBar.showToast('Account Updated Successfully');

        await logOutUser();
      } else {
        if (WayaNav.context.mounted) {
          WayaUtils.showModalSheet(WayaNav.context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
      state = ProfileState(isLoading: false);
    } catch (_) {
      state = ProfileState(isLoading: false);
    }
  }

  void updateAccount({String? dob, String? address}) async {
    final userId = _localDataSource.getUserId();

    try {
      state = ProfileState(isLoading: true);

      final response = await _profileRepo.updateAccountRepo(
          userId: userId, dob: dob, address: address);
      if (response.success) {
        WayaSnackBar.showToast('Account Updated Successfully');

        Future.delayed(Duration(seconds: 1), () {
          WayaNav.replaceWithNamedAndRemoveScreens(EditProfilePage.route,
              removeCount: 2);
        });
      }
      state = ProfileState(isLoading: false);
    } catch (e) {
      state = ProfileState(isLoading: false);
    }
  }

  Future<bool> updateProfile(
      {String? username,
      String? displayName,
      String? bio,
      bool? isPublic,
      bool load = true}) async {
    final userId = _localDataSource.getUserId();

    // Get the last update and creation dates
    DateTime? lastUsernameUpdate;
    DateTime? lastDisplayNameUpdate;

    lastUsernameUpdate = _localDataSource.getLastUpdateUserName();
    lastDisplayNameUpdate = _localDataSource.getLastUpdateDisplayName();
    if (lastUsernameUpdate == null && username != null) {
      _localDataSource.saveLastUpdateUserName(DateTime.now());
    } else if (lastUsernameUpdate != null && username != null) {
      // Determine if updates are allowed based on the conditions
      final cannotUpdateUsername =
          DateTime.now().difference(lastUsernameUpdate).inDays <= 30;
      if (cannotUpdateUsername) {
        WayaSnackBar.showToast(
            'You can only update your username once every 30 days.');
      }
      return cannotUpdateUsername;
    }

    if (lastDisplayNameUpdate == null && displayName != null) {
      _localDataSource.saveLastUpdateDisplayName(DateTime.now());
    } else if (lastDisplayNameUpdate != null && displayName != null) {
      // Determine if updates are allowed based on the conditions
      final cannotUpdateDisplayName =
          DateTime.now().difference(lastDisplayNameUpdate).inDays <= 7;
      if (cannotUpdateDisplayName) {
        WayaSnackBar.showToast(
            'You can only update your display name once every 7 days.');
        return cannotUpdateDisplayName;
      }
    }

    try {
      state = state.copyWith(isLoading: load);

      final response = await _profileRepo.updateProfileRepo(
          userId: userId,
          username: username,
          displayName: displayName,
          bio: bio,
          isPublic: isPublic);
      if (response.success) {
        WayaSnackBar.showToast('Profile Updated Successfully');
        isPublic != null
            ? null
            : Future.delayed(Duration(seconds: 1), () {
                WayaNav.replaceWithNamedAndRemoveScreens(EditProfilePage.route,
                    removeCount: 2);
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

  Future<UserDetailsModel?> getUserData() async {
    final userId = _localDataSource.getUserId();

    try {
      state = state.copyWith(isLoading: true);
      final response = await _profileRepo.getUserDataRepo(userId: userId);
      UserDetailsModel? userData;
      if (response.success) {
        final userAccountModel = UserAccountModel.fromJson(response.data);

        //? Set who is currently logged in somewhere that is easily accessible
        //? for conversation's sake.
        ConversationState.setSelf(
          userAccountModel.data?.userdata?.user,
          userAccountModel.data?.userdata?.profile,
          userAccountModel.data?.userdata?.business,
        );

        userData = userAccountModel.data?.userdata?.user;

        // Finally, update general state.
        state = state.copyWith(
            userAccountModel: userAccountModel, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }

      return userData;
    } catch (e) {
      state = state.copyWith(isLoading: false);

      return null;
    }
  }

  //? Log out properly in the future.
  Future<void> logOutUser() async {
    await _ref.read(notificationProvider.notifier).deleteDeviceToken();
    await _secureDataSource.deleteAll();
    await _localDataSource.wayaFastStorageService.deleteAll();

    //?sign out and revoke access
    await signOutGoogle();

    //? Reset all notifiers, providers, and caches.
    myFollowProvider.reset();
    myGroupNotifier.reset();
    myPageNotifier.reset();
    // otherUserMoments.reset();
    wayaCommentCache.clear();
    wayaPostCache.clear();
    wayaGroupCache.clear();
    wayaPageCache.clear();
    await ShopResource.reset();

    //? Go all the wat to the last page.
    WayaNav.removeUntilNamed(LoginCoverPage.route);
  }

  //?sign out and revoke access
  Future<void> signOutGoogle() async {
    try {
      //?init
      final GoogleSignIn googleSignIn = GoogleSignIn();
      //? check if user is signed in
      bool isSignedIn = await googleSignIn.isSignedIn();

      if (isSignedIn) {
        //? revoke user access to the permissions
        await googleSignIn.disconnect();
        //? sign out of the account
        await googleSignIn.signOut();
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void updateProfilePicture() async {
    final userId = _localDataSource.getUserId();
    File? profileImage = await WayaUtils.pickAndCropImage();
    if (profileImage != null) {
      Uint8List imageBytes = await profileImage.readAsBytes();

      try {
        state = state.copyWith(isLoading: true);
        final response = await _profileRepo.updateProfileImageRepo(
            userId: userId,
            fileName: WayaHelpers.extractFileName(profileImage),
            image: imageBytes);

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
      final response = await _profileRepo.updateProfileRepo(
          userId: ConversationState.self.id, coverPhoto: result);

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

  void removeCoverPhoto() async {
    try {
      WayaPreloaderController.instance.show();
      final response = await _profileRepo.removeCoverPhoto();

      if (response.success) {
        WayaSnackBar.showToast('Cover photo removed successfully');
        refetchUserData();
      } else {
        if (WayaNav.context.mounted) {
          WayaUtils.showModalSheet(WayaNav.context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (_) {}
    WayaPreloaderController.instance.hide();
  }
}

final profileVmProvider = StateNotifierProvider<ProfileVm, ProfileState>((ref) {
  final profileRepo = ref.watch(profileRepositoryProvider);
  return ProfileVm(
    profileRepo,
    WayaLocalDataSource(),
    WayaSecureDataSource(),
    ref,
  );
});

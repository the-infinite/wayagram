import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wayagram/core/components/modals/error.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/controller/preloader.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/data/model/business_account_model.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/auth/account_creation/vm/verify_account_vm.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/features/auth/login/model/user_model.dart';
import 'package:wayagram/features/auth/verify_email/verify_email.dart';
import 'package:wayagram/features/general_settings/notifications/controller/default.dart';
import 'package:wayagram/features/general_settings/notifications/vm/notification_settings_vm.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';
import 'package:wayagram/features/notifications/vm/notification_vm.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';
import 'package:wayagram/shared/features/shop/resource/shop_resource.dart';

part 'login_vm.g.dart';

class LoginState {
  final bool isPasswordFocused;
  final bool isLoading;
  final bool isPasswordVisible;
  final UserModel? userData;

  LoginState({
    this.isPasswordFocused = false,
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.userData,
  });

  LoginState copyWith({
    bool? isPasswordFocused,
    bool? isLoading,
    bool? isPasswordVisible,
    UserModel? userData,
    TextEditingController? emailController,
    TextEditingController? passwordController,
  }) {
    return LoginState(
      isPasswordFocused: isPasswordFocused ?? this.isPasswordFocused,
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      userData: userData ?? this.userData,
    );
  }
}

@riverpod
class Login extends _$Login {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  @override
  LoginState build() {
    return LoginState();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void setPasswordFocus(bool hasFocus) {
    state = state.copyWith(isPasswordFocused: hasFocus);
  }

  Future<void> signinWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    oauthSignIn(token: credential.identityToken.toString(), authType: 'APPLE');
  }

  Future<void> signinWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      debugPrint("User cancelled sign-in");
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    log(googleAuth.idToken ?? "");

    await oauthSignIn(authType: 'GOOGLE', token: googleAuth.idToken ?? '');
  }

  Future<void> oauthSignIn(
      {required String token, required String authType}) async {
    try {
      //? Show the preloader.
      WayaPreloaderController.instance.show();

      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.oauth(token, authType);

      if (response.success) {
        await getUserInfo(data: response.data);
      } else {
        if (response.data != null && response.data['responseCode'] == 404) {
          return WayaSnackBar.showToast("User does not exist");
        } else {
          throw "Error";
        }
      }
    } catch (_) {
    } finally {
      WayaPreloaderController.instance.hide();
    }
  }

  Future<void> onSubmit({
    required String? email,
    required String? password,
  }) async {
    try {
      WayaPreloaderController.instance.show();

      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.login(
          isBusinessLogin: false,
          email: email?.trim(),
          password: password ?? '');
      WayaPreloaderController.instance.hide();
      if (response.success) {
        await getUserInfo(data: response.data);
      } else {
        if (response.data != null && response.data['responseCode'] == 625) {
          await ref
              .read(verifyAccountProvider.notifier)
              .resendOtpForRegisteredButNotVerifiedUser(email: email ?? '');

          WayaNav.toNamed(VerifyEmail.route, arguments: email);
        } else {
          if (WayaNav.context.mounted) {
            WayaUtils.showModalSheet(WayaNav.context,
                child:
                    WayaErrorDialog(title: response.responseCodeError ?? ''));
          }
        }
      }
    } catch (_) {}
  }

  Future<void> getUserInfo({required dynamic data}) async {
    // clearStorage();
    final remoteUserData = UserModel.fromJson(data);

    //? if two factor authentication is enabled verify and there token is absent
    if (remoteUserData.data?.userdata?.user?.twoFactorEnabled == true &&
        remoteUserData.data?.token == null) {
      final email =
          Uri.encodeComponent(remoteUserData.data?.userdata?.user?.email ?? '');
      WayaNav.toNamed(WayaAppRoutes.get2FaScreen(email), arguments: "login");
      WayaPreloaderController.instance.hide();
      return;
    }

    state = state.copyWith(userData: remoteUserData);

    final localDataSource = WayaLocalDataSource();
    final secureDataSource = WayaSecureDataSource();

    localDataSource
        .saveUserId(remoteUserData.data?.userdata?.user?.id as String);
    await secureDataSource
        .saveUserId(remoteUserData.data?.userdata?.user?.id as String);
    await secureDataSource
        .saveToken(remoteUserData.data?.token?.token as String);
    await secureDataSource
        .saveRefreshToken(remoteUserData.data?.token?.refreshToken as String);

    //
    if (remoteUserData.data != null) {
      //? Now, it is time to save this one.
      ConversationState.setSelf(
        remoteUserData.data?.userdata?.user,
        remoteUserData.data?.userdata?.profile,
        remoteUserData.data?.userdata?.business,
      );

      // Now, in a contained region, load up this person's stores.
      try {
        await ShopResource.configureShop(ConversationState.self.id);
        await ShopResource.getShopCategories();
      } catch (_) {}

      try {
        await myFollowProvider.getIfEmpty();
      } catch (_) {}

      //? Now we do the unnecessPary part of things.
      final profileRepo = ref.read(profileRepositoryProvider);
      final response = await profileRepo.getUserDataRepo(
          userId: remoteUserData.data?.userdata?.user?.id as String);

      if (response.success) {
        UserAccountModel userAccountModel =
            UserAccountModel.fromJson(response.data);

        final setupVm = ref.read(successfulSetupProvider.notifier);
        setupVm.state =
            setupVm.state.copyWith(user: userAccountModel.data?.userdata);

        if (userAccountModel.data != null &&
            userAccountModel.data!.userdata!.user!.role != "PERSONAL") {
          final bizResponse = await profileRepo.getBusinessDataRepo(
              userId: remoteUserData.data?.userdata?.user?.id as String);
          BusinessAccountData bizData =
              BusinessAccountData.fromJson(bizResponse.data["data"]);

          setupVm.state = setupVm.state.copyWith(business: bizData);

          await secureDataSource.saveBusinessId(bizData.businessId);
        }
      }
    }

    //? This is fine.
    final notificationVm = ref.read(notificationProvider.notifier);
    final notificationSettings =
        ref.read(notificationSettingsProvider.notifier);

    try {
      //? If this has not yet generated any device tokens, send them across.
      final result = await notificationVm.sendDeviceToken();

      //? If this was fine...
      if (result) {
        WayaLocalDataSource().saveDeviceToken(WayaValueHelper.createUid());
      }

      // Before moving forward, try to retrieve the user's notifications.
      await notificationSettings
          .getSettings(NotificationSettingsController.instance);
      await notificationVm.getUserNotifications();
    } catch (_) {}

    // This is good too.
    WayaNav.replaceNamed("/explore");
  }

  Future<void> loginVerification(
      {required String email, required String code, String? purpose}) async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.validate2Fa(
          email: email, code: code, purpose: purpose);

      if (response.success) {
        await getUserInfo(data: response.data);
      } else {
        if (WayaNav.context.mounted) {
          WayaUtils.showModalSheet(WayaNav.context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (_) {}
  }
}

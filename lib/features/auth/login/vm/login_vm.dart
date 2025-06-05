import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/controller/preloader.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/data/model/business_account_model.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/auth/account_creation/vm/verify_account_vm.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/features/auth/login/model/user_model.dart';
import 'package:wayagram/features/auth/verify_email/verify_email.dart';
import 'package:wayagram/features/general_settings/notifications/controller/default.dart';
import 'package:wayagram/features/general_settings/notifications/vm/default.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';
import 'package:wayagram/features/notifications/vm/default.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';
import 'package:wayagram/shared/features/shop/resource/default.dart';

class LoginState {
  final bool isPasswordFocused;
  final bool isLoading;
  final bool isPasswordVisible;
  final UserModel? userData;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController businessAcctController;

  LoginState(
      {this.isPasswordFocused = false,
      this.isLoading = false,
      this.isPasswordVisible = false,
      this.userData,
      required this.emailController,
      required this.passwordController,
      required this.businessAcctController});

  LoginState copyWith(
      {bool? isPasswordFocused,
      bool? isLoading,
      bool? isPasswordVisible,
      UserModel? userData,
      TextEditingController? emailController,
      TextEditingController? passwordController,
      TextEditingController? businessAcctController}) {
    return LoginState(
        isPasswordFocused: isPasswordFocused ?? this.isPasswordFocused,
        isLoading: isLoading ?? this.isLoading,
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
        userData: userData ?? this.userData,
        emailController: emailController ?? this.emailController,
        passwordController: passwordController ?? this.passwordController,
        businessAcctController:
            businessAcctController ?? this.businessAcctController);
  }
}

class LoginVm extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;
  final WayaLocalDataSource _localDataSource;
  final WayaSecureDataSource _secureDataSource;
  final SuccessfulSetupVm _setupVm;
  final ProfileRepo _profileRepo;
  final _logger = getLogger("LoginVm");
  final Ref ref;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  LoginVm(this.ref, this._authRepository, this._localDataSource,
      this._secureDataSource, this._setupVm, this._profileRepo)
      : super(LoginState(
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            businessAcctController: TextEditingController()));

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void setPasswordFocus(bool hasFocus) {
    state = state.copyWith(isPasswordFocused: hasFocus);
  }

  @override
  void dispose() {
    state.emailController.dispose();
    state.passwordController.dispose();
    state.businessAcctController.dispose();
    super.dispose();
  }

  Future<void> signinWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    debugPrint(credential.identityToken.toString());
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

    // final OAuthCredential credential = GoogleAuthProvider.credential(
    //   idToken: googleAuth.idToken,
    //   accessToken: googleAuth.accessToken,
    // );

    log(googleAuth.idToken ?? "");

    // if (idToken != null) {
    await oauthSignIn(authType: 'GOOGLE', token: googleAuth.idToken ?? '');
  }

  Future<void> oauthSignIn(
      {required String token, required String authType}) async {
    try {
      //? Show the preloader.
      WayaPreloaderController.instance.show();

      final response = await _authRepository.oauth(token, authType);

      if (response.success) {
        debugPrint(response.data.toString());
        await getUserInfo(data: response.data);
      } else {
        if (response.data['responseCode'] == 404) {
          return WayaSnackBar.showToast("User does not exist");
        } else {
          throw "Error";
        }
      }
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      //? Hide the preloader.
      WayaPreloaderController.instance.hide();
    }
  }

  Future<void> onSubmit(WidgetRef ref,
      {String? email, bool? isBusinessLogin}) async {
    try {
      //? Show the preloader.
      WayaPreloaderController.instance.show();

      //? added trim, add issue login in just cause of space issues
      final response = await _authRepository.login(
          isBusinessLogin: isBusinessLogin,
          email: email?.trim() ?? state.emailController.text.trim(),
          businessInfo: state.businessAcctController.text.trim(),
          password: state.passwordController.text.trim());

      if (response.success) {
        await getUserInfo(data: response.data);
      } else {
        if (response.data['responseCode'] == 625) {
          await ref
              .read(verifyAccountProvider.notifier)
              .resendOtpForRegisteredButNotVerifiedUser(
                  email: state.emailController.text);

          WayaNav.toNamed(VerifyEmail.route,
              arguments: state.emailController.text);
        }
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      //state = state.copyWith(isLoading: false);
      //? Hide the preloader.
      WayaPreloaderController.instance.hide();
    }
  }

  Future<void> getUserInfo({required dynamic data}) async {
    // clearStorage();
    final remoteUserData = UserModel.fromJson(data);

    //? if two factor authentication is enabled verify and there token is absent
    if (remoteUserData.data?.userdata?.user?.twoFactorEnabled == true &&
        remoteUserData.data?.token == null) {
      final email =
          Uri.encodeComponent(remoteUserData.data?.userdata?.user?.email ?? '');
      WayaNav.toNamed(
          WayaAppRoutes.get2FaScreen(
              email),
          arguments: "login");
      WayaPreloaderController.instance.hide();
      return;
    }

    state = state.copyWith(userData: remoteUserData);

    _localDataSource
        .saveUserId(remoteUserData.data?.userdata?.user?.id as String);
    await _secureDataSource
        .saveUserId(remoteUserData.data?.userdata?.user?.id as String);
    await _secureDataSource
        .saveToken(remoteUserData.data?.token?.token as String);
    await _secureDataSource
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
      } catch (e) {
        WayaDebugConsoleController.instance.addException(
          WayaDebugHelpers.getMessage(e),
          e,
          WayaDebugEventModule.shops,
          WayaDebugHelpers.getStackTrace(e),
        );
      }

      //? Now, load this user's followers
      try {
        await myFollowProvider.getIfEmpty();
      } catch (e) {
        WayaDebugConsoleController.instance.addException(
          WayaDebugHelpers.getMessage(e),
          e,
          WayaDebugEventModule.relationships,
          WayaDebugHelpers.getStackTrace(e),
        );
      }

      //? Now we do the unnecessPary part of things.
      final response = await _profileRepo.getUserDataRepo(
          userId: remoteUserData.data?.userdata?.user?.id as String);

      if (response.success) {
        UserAccountModel userAccountModel =
            UserAccountModel.fromJson(response.data);

        _setupVm.state =
            _setupVm.state.copyWith(user: userAccountModel.data?.userdata);

        if (userAccountModel.data != null &&
            userAccountModel.data!.userdata!.user!.role != "PERSONAL") {
          final bizResponse = await _profileRepo.getBusinessDataRepo(
              userId: remoteUserData.data?.userdata?.user?.id as String);
          BusinessAccountData bizData =
              BusinessAccountData.fromJson(bizResponse.data["data"]);

          _setupVm.state = _setupVm.state.copyWith(business: bizData);

          await _secureDataSource.saveBusinessId(bizData.businessId);
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
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.notifications,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    // This is good too.
    WayaNav.replaceNamed("/explore");
  }

  Future<void> loginVerification(
      {required String email, required String code, String? purpose}) async {
    try {
      final response = await _authRepository.validate2Fa(
          email: email, code: code, purpose: purpose);

      if (response.success) {
        await getUserInfo(data: response.data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

final loginVmProvider = StateNotifierProvider<LoginVm, LoginState>((ref) {
  final successfulSetupVm = ref.read(successfulSetupVmProvider.notifier);
  return LoginVm(ref, AuthRepository(), WayaLocalDataSource(),
      WayaSecureDataSource(), successfulSetupVm, ProfileRepo());
});

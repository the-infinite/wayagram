import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/account_creation/data/model/business_account_model.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/features/auth/login/model/user_model.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';
import 'package:wayagram/features/notifications/vm/default.dart';
import 'package:wayagram/features/chat/state/default.dart';

class LoginState {
  final bool isPasswordFocused;
  final bool isLoading;
  final bool isPasswordVisible;
  final UserModel? userData;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController businessIdController;

  LoginState(
      {this.isPasswordFocused = false,
      this.isLoading = false,
      this.isPasswordVisible = false,
      this.userData,
      required this.emailController,
      required this.passwordController,
      required this.businessIdController});

  LoginState copyWith(
      {bool? isPasswordFocused,
      bool? isLoading,
      bool? isPasswordVisible,
      UserModel? userData,
      TextEditingController? emailController,
      TextEditingController? passwordController,
      TextEditingController? businessIdController}) {
    return LoginState(
        isPasswordFocused: isPasswordFocused ?? this.isPasswordFocused,
        isLoading: isLoading ?? this.isLoading,
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
        userData: userData ?? this.userData,
        emailController: emailController ?? this.emailController,
        passwordController: passwordController ?? this.passwordController,
        businessIdController: businessIdController ?? this.businessIdController);
  }
}

class LoginVm extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;
  final WayaLocalDataSource _localDataSource;
  final WayaSecureDataSource _secureDataSource;
  final SuccessfulSetupVm _setupVm;
  final ProfileRepo _profileRepo;
  final _logger = getLogger("LoginVm");

  LoginVm(this._authRepository, this._localDataSource, this._secureDataSource, this._setupVm, this._profileRepo)
      : super(LoginState(
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            businessIdController: TextEditingController()));

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
    state.businessIdController.dispose();
    super.dispose();
  }

  Future<void> onSubmit(WidgetRef ref, {String? email, bool? isBusinessLogin}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _authRepository.login(
          isBusinessLogin: isBusinessLogin,
          email: email ?? state.emailController.text,
          businessId: state.businessIdController.text,
          password: state.passwordController.text);

      // _logger.d(" result ${response.data['message']}");
      if (response.success) {
        // clearStorage();
        final remmoteUserData = UserModel.fromJson(response.data);
        state = state.copyWith(userData: remmoteUserData);

        _localDataSource.saveUserId(remmoteUserData.data?.userdata?.user?.id as String);
        await _secureDataSource.saveUserId(remmoteUserData.data?.userdata?.user?.id as String);
        await _secureDataSource.saveToken(remmoteUserData.data?.token?.token as String);
        await _secureDataSource.saveRefreshToken(remmoteUserData.data?.token?.refreshToken as String);

        //

        if (remmoteUserData.data != null) {
          final response =
              await _profileRepo.getUserDataRepo(userId: remmoteUserData.data?.userdata?.user?.id as String);

          if (response.success) {
            UserAccountModel userAccountModel = UserAccountModel.fromJson(response.data);
            _setupVm.state = _setupVm.state.copyWith(user: userAccountModel.data?.userdata);
            ConversationState.setSelf(userAccountModel.data?.userdata?.user);

            if (userAccountModel.data != null && userAccountModel.data!.userdata!.user!.role!.name != "PERSONAL") {
              final bizResponse =
                  await _profileRepo.getBusinessDataRepo(userId: remmoteUserData.data?.userdata?.user?.id as String);
              BusinessAccountData bizData = BusinessAccountData.fromJson(bizResponse.data["data"]);
              _setupVm.state = _setupVm.state.copyWith(business: bizData);
              await _secureDataSource.saveBusinessId(bizData.businessId);
            }
          }
        }

        //? This is fine.
        final notificationVm = ref.watch(notificationProvider.notifier);

        //? If this has not yet generated any device tokens, send them across.
        if (!WayaLocalDataSource().getIsFcmTokenFine()) {
          final result = await notificationVm.sendDeviceToken();

          // If this was fine...
          if (result) WayaLocalDataSource().saveDeviceToken("TDNOINSO");
        }

        // Before moving forward, try to retrieve the user's notifications.
        notificationVm.getUserNotifications();

        // This is good too.
        WayaNav.toNamed("/explore");
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void clearStorage() async {
    await _secureDataSource.saveToken("");
    await _secureDataSource.saveRefreshToken("");
    await _secureDataSource.saveBusinessId("");
    _localDataSource.saveUserId("");
    await _secureDataSource.saveUserId("");
  }
}

final loginVmProvider = StateNotifierProvider<LoginVm, LoginState>((ref) {
  final successfulSetupVm = ref.read(successfulSetupVmProvider.notifier);
  return LoginVm(AuthRepository(), WayaLocalDataSource(), WayaSecureDataSource(), successfulSetupVm, ProfileRepo());
});

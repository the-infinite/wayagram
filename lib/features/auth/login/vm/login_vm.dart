import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/login/model/user_model.dart';

class LoginState {
  final bool isPasswordFocused;
  final bool isLoading;
  final bool isPasswordVisible;
  final UserModel? userData;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  LoginState({
    this.isPasswordFocused = false,
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.userData,
    required this.emailController,
    required this.passwordController,
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
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
    );
  }
}

class LoginVm extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;
  final WayaLocalDataSource _localDataSource;
  final WayaSecureDataSource _secureDataSource;
  final _logger = getLogger("LoginVm");

  LoginVm(this._authRepository, this._localDataSource, this._secureDataSource)
      : super(LoginState(
          emailController: TextEditingController(),
          passwordController: TextEditingController(),
        ));

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
    super.dispose();
  }

  Future<void> onSubmit(String? email) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _authRepository.login(
          email ?? state.emailController.text, state.passwordController.text);

      _logger.d(" result ${response.data['message']}");
      if (response.success) {
        final remmoteUserData = UserModel.fromJson(response.data);
        state = state.copyWith(userData: remmoteUserData);
           _localDataSource.saveUserId(remmoteUserData.data?.userdata?.user?.id as String);
      await  _secureDataSource.saveUserId(remmoteUserData.data?.userdata?.user?.id as String);
        await _secureDataSource
            .saveToken(remmoteUserData.data?.token?.token as String);

        WayaNav.toNamed("/explore");
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final loginVmProvider = StateNotifierProvider<LoginVm, LoginState>((ref) {
  return LoginVm(
      AuthRepository(), WayaLocalDataSource(), WayaSecureDataSource());
});

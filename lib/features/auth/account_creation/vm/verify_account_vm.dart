import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/service/repos/auth/auth_model.dart';
import 'package:wayagram/core/service/repos/auth/auth_repository.dart';
import 'package:wayagram/core/service/snackbar_service.dart';

class VerifyAccountState {
  bool isEditing;
  String inputCode;
  int countdown;
  bool isResend;
  bool isLoading;

  VerifyAccountState({
    this.inputCode = '',
    this.isEditing = false,
    this.countdown = 900,
    this.isResend = false,
    this.isLoading = false,
  });

  VerifyAccountState copyWith({
    bool? isEditing,
    String? inputCode,
    int? countdown,
    bool? isResend,
    bool? isLoading,
  }) {
    return VerifyAccountState(
      isEditing: isEditing ?? this.isEditing,
      inputCode: inputCode ?? this.inputCode,
      countdown: countdown ?? this.countdown,
      isResend: isResend ?? this.isResend,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class VerifyAccountVm extends Notifier<VerifyAccountState> {
  final WayaLocalDataSource _localDataSource = WayaLocalDataSource();
  final WayaSecureDataSource _secureDataSource = WayaSecureDataSource();
  final _logger = getLogger("VerifyAccountVm");
  final AuthRepository _authRepository = AuthRepository();
  Timer? _timer;
  final SnackbarService _snackbarService = SnackbarService();

  @override
  VerifyAccountState build() {
    state = VerifyAccountState();
    _startCountdown();
    return state;
  }

  void _startCountdown() {
    _timer?.cancel();
    state = state.copyWith(countdown: 40);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.countdown > 0) {
        state = state.copyWith(countdown: state.countdown - 1);
      } else {
        state = state.copyWith(isResend: true);
        _timer?.cancel();
      }
    });
  }

  void onCodeChanged(String value) {
    state = state.copyWith(inputCode: value);
  }

  void onEditited(bool value) {
    state = state.copyWith(isEditing: value);
  }

  Future<void> verifyAccount(VoidCallback onSucess, String code) async {
    state = state.copyWith(isLoading: true);

    try {
      final user = _localDataSource.getUser();
      final response = await _authRepository
          .verifyOtp(VerifyOtp(email: user["email"], otp: code));
      _logger.d(" result ${response.data['message']}");
      if (response.data["statusCode"] == 200) {
        final user = response.data['data']['user'];
        final token = response.data['data']['token']['token'];
        final refreshToken = response.data['data']['token']['refreshToken'];
        _localDataSource.saveUser(user);
        _secureDataSource.saveToken(token);
        _secureDataSource.saveRefreshToken(refreshToken);
        onSucess();
      }
    } catch (e) {
      _logger.e(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> resendOtp() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = _localDataSource.getUser();
      final response = await _authRepository.resendOtp(user['email']);
      _logger.d(" result ${response.data['message']}");
      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message: "Otp has been resend to ${user['email']}");
      }
    } catch (e) {
      _logger.e(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void cancelTimer() {
    _timer?.cancel();
  }
}

final verifyAccountProvider =
    NotifierProvider<VerifyAccountVm, VerifyAccountState>(() {
  return VerifyAccountVm();
});

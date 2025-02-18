import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/auth/account_creation/vm/personal_first_step_vm.dart';
import 'package:wayagram/features/auth/data/model/auth_model.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
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
  final WayaLocalDataSource _localDataSource;
  final AuthRepository _authRepository;
  final WayaSecureDataSource _secureDataSource = WayaSecureDataSource();
  final _logger = getLogger("VerifyAccountVm");
  Timer? _timer;
  final SnackbarService _snackbarService = SnackbarService();

  VerifyAccountVm(this._localDataSource, this._authRepository);

  @override
  VerifyAccountState build() {
    state = VerifyAccountState();
    _startCountdown();
    return state;
  }

  void _startCountdown() {
    _timer?.cancel();
    state = state.copyWith(countdown: 40);
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (state.countdown > 0) {
          state = state.copyWith(countdown: state.countdown - 1);
        } else {
          state = state.copyWith(isResend: true);
          _timer?.cancel();
        }
      },
    );
  }

  void onCodeChanged(String value) {
    state = state.copyWith(inputCode: value);
  }

  void onEdited(bool value) {
    state = state.copyWith(isEditing: value);
  }

  Future<void> verifyAccount(VoidCallback onSuccess, String code) async {
    state = state.copyWith(isLoading: true);

    try {
      final email = ref.watch(personalFirstStepProvider).email.text;
      final response = await _authRepository.verifyOtp(VerifyOtp(email: email, otp: code));
      if (response.success) {
        final token = response.data['data']['token']['token'];
        final refreshToken = response.data['data']['token']['refreshToken'];

        _secureDataSource.saveToken(token);
        _secureDataSource.saveRefreshToken(refreshToken);
        onSuccess();
      }
    } catch (e) {
      _logger.e(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> resendOtp() async {
    try {
      final email = ref.watch(personalFirstStepProvider).email.text;
      final response = await _authRepository.resendOtp(email);
      _logger.d(" result ${response.data['message']}");
      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(variant: SnackbarType.success, message: "OTP has been resend to $email");
state = state.copyWith(isResend: false);
        //? Start the countdown since our attempt to resend the OTP was successful.
        _startCountdown();
      }
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  void cancelTimer() {
    _timer?.cancel();
  }
}

final verifyAccountProvider = NotifierProvider<VerifyAccountVm, VerifyAccountState>(() {
  return VerifyAccountVm(WayaLocalDataSource(), AuthRepository());
});

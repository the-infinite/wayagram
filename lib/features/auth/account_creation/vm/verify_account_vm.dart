import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/vm/personal_first_step_vm.dart';
import 'package:wayagram/features/auth/data/model/auth_model.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/core/service/snackbar_service.dart';
import 'package:wayagram/features/auth/login/vm/login_vm.dart';
import 'package:wayagram/features/chat/state/default.dart';

class VerifyAccountState {
  bool isEditing;
  String inputCode;
  int countdown;
  bool isResend;
  bool isLoading;
  bool isFromLogin;

  VerifyAccountState(
      {this.inputCode = '',
      this.isEditing = false,
      this.countdown = 60,
      this.isResend = false,
      this.isLoading = false,
      this.isFromLogin = false});

  VerifyAccountState copyWith(
      {bool? isEditing,
      String? inputCode,
      int? countdown,
      bool? isResend,
      bool? isLoading,
      bool? isFromLogin}) {
    return VerifyAccountState(
        isEditing: isEditing ?? this.isEditing,
        inputCode: inputCode ?? this.inputCode,
        countdown: countdown ?? this.countdown,
        isResend: isResend ?? this.isResend,
        isLoading: isLoading ?? this.isLoading,
        isFromLogin: isFromLogin ?? this.isFromLogin);
  }
}

class VerifyAccountVm extends Notifier<VerifyAccountState> {
  final AuthRepository _authRepository;
  final WayaSecureDataSource _secureDataSource = WayaSecureDataSource();
  final _logger = getLogger("VerifyAccountVm");
  Timer? _timer;
  final SnackbarService _snackbarService = SnackbarService();

  VerifyAccountVm(this._authRepository);

  @override
  VerifyAccountState build() {
    state = VerifyAccountState();
    startCountdown();
    return state;
  }

  void startCountdown() {
    _timer?.cancel();
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

  void reset() {}

  Future<void> verifyPhone(
      {required VoidCallback onSuccess, required String code}) async {
    final personalPhone = ref.watch(personalFirstStepProvider).phoneNumber.text;

    state = state.copyWith(isLoading: true);
    try {
      final response =
          await _authRepository.phoneVerification(code, "234$personalPhone");

      if (response.success) {
        onSuccess();
      }
    } catch (e) {
      _logger.e(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> resendPhoneOtp() async {
    try {
      final personalPhone =
          ref.watch(personalFirstStepProvider).phoneNumber.text;
      final response = await _authRepository.resendOtp(
          phone:
              "234${personalPhone.length > 10 ? personalPhone.substring(1) : personalPhone}");
      _logger.d(" result ${response.data['message']}");
      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message: "OTP has been resend to 234$personalPhone");
        state = state.copyWith(isResend: false);

        //? Start the countdown since our attempt to resend the OTP was successful.
        startCountdown();
      }
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  Future<void> verifyAccount(
      {required VoidCallback onSuccess,
      required String code,
      required String type}) async {
    state = state.copyWith(isLoading: true);

    try {
      String personalEmail = ref.watch(personalFirstStepProvider).email.text;
      String phoneNumber =
          ref.watch(personalFirstStepProvider).phoneNumber.text;

      final response = await _authRepository
          .verifyOtp(VerifyOtp(email: personalEmail, otp: code));
      if (response.success) {
        final token = response.data['data']['token']['token'];
        final refreshToken = response.data['data']['token']['refreshToken'];

        _secureDataSource.saveToken(token);
        _secureDataSource.saveRefreshToken(refreshToken);
        state = state.copyWith(inputCode: '');
        if (type == 'account-creation') {
          await _authRepository.resendOtp(
              phone:
                  "234${phoneNumber.length > 10 ? phoneNumber.substring(1) : phoneNumber}");
        }

        onSuccess();
      }
    } catch (e) {
      _logger.e(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> verifyEmail(
      {required VoidCallback onSuccess,
      required String code,
      required String email}) async {
    state = state.copyWith(isLoading: true);

    try {
      final response =
          await _authRepository.verify(VerifyOtp(email: email, otp: code));
      if (response.success) {
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
      final response = await _authRepository.resendOtp(email: email);
      _logger.d(" result ${response.data['message']}");
      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message: "OTP has been resend to $email");
        state = state.copyWith(isResend: false);

        //? Start the countdown since our attempt to resend the OTP was successful.
        startCountdown();
      }
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  Future<void> resendOtpForRegisteredButNotVerifiedUser(
      {required String email}) async {
    try {
      final response = await _authRepository.resendOtp(email: email);
      _logger.d(" result ${response.data['message']}");
      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message: "OTP has been resend to $email");
        state = state.copyWith(isResend: false);

        //? Start the countdown since our attempt to resend the OTP was successful.
        startCountdown();
      }
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  Future<void> verifyAccountForRegisteredButNotVerifiedUser(
      String email, String code) async {
    state = state.copyWith(isLoading: true);

    try {
      final response =
          await _authRepository.verifyOtp(VerifyOtp(email: email, otp: code));
      if (response.success) {
        final token = response.data['data']['token']['token'];
        final refreshToken = response.data['data']['token']['refreshToken'];

        _secureDataSource.saveToken(token);
        _secureDataSource.saveRefreshToken(refreshToken);
        WayaNav.goBack();
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

  Future<void> requestOtp(
      {required String purpose, String? email, String? phone}) async {
    await _authRepository.getOtp(email: email, purpose: purpose, phone: phone);
  }

  Future<void> requestEmailOtp() async {
    await _authRepository.resendOtp(
        email: ConversationState.self.email, purpose: "Reset_PIN");
  }

  Future<void> resend2faOtp({required String email}) async {
    try {
      final response =
          await _authRepository.resendOtp(email: email, purpose: "2FA");
      _logger.d(" result ${response.data['message']}");
      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message: "OTP has been resend to $email");
        state = state.copyWith(isResend: true);

        //? Start the countdown since our attempt to resend the OTP was successful.
      }
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  Future<void> update2Fa({required String code, required String email}) async {
    try {
      final response =
          await _authRepository.toggle2Fa(code: code, purpose: "2FA");

      if (response.success) {
        WayaNav.goBack();
      }
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  Future<void> twoFaVerification(
      {required String code, required String email}) async {
    state = state.copyWith(isLoading: true);

    final decodedEmail = Uri.decodeComponent(email);

    try {
      state.isFromLogin
          ? await ref.read(loginVmProvider.notifier).loginVerification(
              email: decodedEmail, code: code, purpose: state.isResend ? "2FA" : null)
          : await update2Fa(code: code, email: decodedEmail);
    } catch (e) {
      _logger.e(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

/**

 */
  void updateResend(bool value) {
    state = state.copyWith(isResend: value);
  }

  void updateFromLoginState(bool value) {
    state = state.copyWith(isFromLogin: value);
  }
}

final verifyAccountProvider =
    NotifierProvider<VerifyAccountVm, VerifyAccountState>(() {
  return VerifyAccountVm(AuthRepository());
});

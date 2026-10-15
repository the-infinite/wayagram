import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/components/modals/error.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/vm/personal_first_step_vm.dart';
import 'package:wayagram/features/auth/data/model/auth_model.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/core/service/snackbar_service.dart';
import 'package:wayagram/features/auth/login/vm/login_vm.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/account_security/account_security.dart';

part 'verify_account_vm.g.dart';

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

@riverpod
class VerifyAccount extends _$VerifyAccount {
  final WayaSecureDataSource _secureDataSource = WayaSecureDataSource();
  Timer? _timer;
  final SnackbarService _snackbarService = SnackbarService();

  @override
  VerifyAccountState build() {
    startCountdown();
    return VerifyAccountState();
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
      final authRepository = ref.read(authRepositoryProvider);
      final response =
          await authRepository.phoneVerification(code, "234$personalPhone");

      if (response.success) {
        onSuccess();
      } else {
        if (WayaNav.context.mounted) {
          WayaUtils.showModalSheet(WayaNav.context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> resendPhoneOtp() async {
    try {
      final personalPhone =
          ref.watch(personalFirstStepProvider).phoneNumber.text;
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.resendOtp(
          phone:
              "234${personalPhone.length > 10 ? personalPhone.substring(1) : personalPhone}",
          purpose: "PHONE_NUMBER_AUTH");
      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message: "OTP has been resend to 234$personalPhone");
        state = state.copyWith(isResend: false);

        //? Start the countdown since our attempt to resend the OTP was successful.
        startCountdown();
      }
    } catch (_) {}
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

      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository
          .verifyOtp(VerifyOtp(email: personalEmail, otp: code));
      if (response.success) {
        final token = response.data['data']['token']['token'];
        final refreshToken = response.data['data']['token']['refreshToken'];

        _secureDataSource.saveToken(token);
        _secureDataSource.saveRefreshToken(refreshToken);
        state = state.copyWith(inputCode: '');
        if (type == 'account-creation') {
          await authRepository.resendOtp(
              phone:
                  "234${phoneNumber.length > 10 ? phoneNumber.substring(1) : phoneNumber}",
              purpose: "PHONE_NUMBER_AUTH");
        }

        onSuccess();
      } else {
        if (WayaNav.context.mounted) {
          WayaUtils.showModalSheet(WayaNav.context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (_) {
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
      final authRepository = ref.read(authRepositoryProvider);
      final response =
          await authRepository.verify(VerifyOtp(email: email, otp: code));
      if (response.success) {
        onSuccess();
      } else {
        if (WayaNav.context.mounted) {
          WayaUtils.showModalSheet(WayaNav.context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> verifyChangePassword(
      {required VoidCallback onSuccess,
      required String code,
      required String email}) async {
    state = state.copyWith(isLoading: true);

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository
          .verifyChangePassword(VerifyOtp(email: email, otp: code));
      if (response.success) {
        onSuccess();
      } else {
        if (WayaNav.context.mounted) {
          WayaUtils.showModalSheet(WayaNav.context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> verifySetTransactionPin(
      {required VoidCallback onSuccess,
      required String code,
      required String email}) async {
    state = state.copyWith(isLoading: true);

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response =
          await authRepository.verifySetPin(VerifyOtp(email: email, otp: code));
      if (response.success) {
        onSuccess();
      } else {
        if (WayaNav.context.mounted) {
          WayaUtils.showModalSheet(WayaNav.context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> verifyChangeTransactionPin(
      {required VoidCallback onSuccess,
      required String code,
      required String email}) async {
    state = state.copyWith(isLoading: true);

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository
          .verifyChangePin(VerifyOtp(email: email, otp: code));
      if (response.success) {
        onSuccess();
      } else {
        if (WayaNav.context.mounted) {
          WayaUtils.showModalSheet(WayaNav.context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> verifyPayout(
      {required VoidCallback onSuccess,
      required String code,
      required String email}) async {
    state = state.copyWith(isLoading: true);

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.verifyPayout(email, code);
      if (response.success) {
        onSuccess();
      } else {
        if (WayaNav.context.mounted) {
          WayaUtils.showModalSheet(WayaNav.context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> resendOtp() async {
    try {
      final email = ref.watch(personalFirstStepProvider).email.text;
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.resendOtp(email: email);
      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message: "OTP has been resend to $email");
        state = state.copyWith(isResend: false);

        //? Start the countdown since our attempt to resend the OTP was successful.
        startCountdown();
      }
    } catch (_) {}
  }

  Future<void> resendOtpForRegisteredButNotVerifiedUser(
      {required String email}) async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.resendOtp(email: email);
      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message: "OTP has been resend to $email");
        state = state.copyWith(isResend: false);

        //? Start the countdown since our attempt to resend the OTP was successful.
        startCountdown();
      }
    } catch (_) {}
  }

  Future<void> verifyAccountForRegisteredButNotVerifiedUser(
      String email, String code) async {
    state = state.copyWith(isLoading: true);

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response =
          await authRepository.verifyOtp(VerifyOtp(email: email, otp: code));
      if (response.success) {
        final token = response.data['data']['token']['token'];
        final refreshToken = response.data['data']['token']['refreshToken'];

        _secureDataSource.saveToken(token);
        _secureDataSource.saveRefreshToken(refreshToken);
        WayaNav.goBack();
      } else {
        if (WayaNav.context.mounted) {
          WayaUtils.showModalSheet(WayaNav.context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  Future<void> requestOtp(
      {required String purpose, String? email, String? phone}) async {
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.getOtp(email: email, purpose: purpose, phone: phone);
  }

  Future<void> requestEmailOtp() async {
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.resendOtp(
        email: ConversationState.self.email, purpose: "Reset_PIN");
  }

  Future<void> resend2faOtp({required String email}) async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response =
          await authRepository.resendOtp(email: email, purpose: "2FA");
      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message: "OTP has been resend to $email");
        state = state.copyWith(isResend: true);

        //? Start the countdown since our attempt to resend the OTP was successful.
      }
    } catch (_) {}
  }

  Future<void> update2Fa({required String code, required String email}) async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response =
          await authRepository.toggle2Fa(code: code, purpose: "2FA");

      if (response.success) {
        WayaNav.replaceNamed(AccountSecurity.route);
      } else {
        if (WayaNav.context.mounted) {
          WayaUtils.showModalSheet(WayaNav.context,
              child: WayaErrorDialog(title: response.responseCodeError ?? ''));
        }
      }
    } catch (_) {}
  }

  Future<void> twoFaVerification(
      {required String code, required String email}) async {
    state = state.copyWith(isLoading: true);

    final decodedEmail = Uri.decodeComponent(email);

    try {
      state.isFromLogin
          ? await ref.read(loginProvider.notifier).loginVerification(
              email: decodedEmail,
              code: code,
              purpose: state.isResend ? "2FA" : null)
          : await update2Fa(code: code, email: decodedEmail);
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void updateResend(bool value) {
    state = state.copyWith(isResend: value, isFromLogin: !value);
  }

  void updateFromLoginState(bool value) {
    state = state.copyWith(isFromLogin: value, isResend: !value);
  }
}

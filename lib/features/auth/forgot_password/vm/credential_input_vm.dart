import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/modals/error.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/core/service/snackbar_service.dart';
import 'package:wayagram/features/chat/state/default.dart';

class CredentialInputState {
  final bool isEmail;
  final bool isButtonEnabled;
  final bool isLoading;
  final TextEditingController email;
  final TextEditingController phone;

  CredentialInputState({
    this.isEmail = true,
    this.isButtonEnabled = false,
    this.isLoading = false,
    TextEditingController? email,
    TextEditingController? phone,
  })  : email = email ?? TextEditingController(),
        phone = phone ?? TextEditingController();

  CredentialInputState copyWith({
    bool? isEmail,
    bool? isButtonEnabled,
    bool? isLoading,
    TextEditingController? email,
    TextEditingController? phone,
  }) {
    return CredentialInputState(
      isEmail: isEmail ?? this.isEmail,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}

class CredentialInputNotifier extends StateNotifier<CredentialInputState> {
  final Ref ref;
  final _logger = getLogger("CredentialInputNotifier");
  final _authRepository = AuthRepository();
  final _snackbarService = SnackbarService();

  CredentialInputNotifier(this.ref)
      : super(
          CredentialInputState(),
        ) {
    state.email.addListener(_validateInputs);
    state.phone.addListener(_validateInputs);
  }
  @override
  void dispose() {
    state.email.removeListener(_validateInputs);
    state.phone.removeListener(_validateInputs);
    state.email.dispose();
    state.phone.dispose();

    super.dispose();
  }

  void toggle() {
    if (state.isEmail) {
      state.email.text = '';
    } else {
      state.phone.text = '';
    }

    state = state.copyWith(isEmail: !state.isEmail);
  }

  Future<void> onSubmit(VoidCallback onSuccess) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _authRepository.verifyEmail(state.email.text);

      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message:
                "A Password reset Otp has been resent to ${state.email.text}");
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

  Future<void> onSubmitPin(VoidCallback onSuccess) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _authRepository.resendOtp(
        email: '${ConversationState.self.email}',
        purpose: 'Reset_PIN',
      );

      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message:
                "A Password reset Otp has been sent to ${ConversationState.self.email}");
        onSuccess();
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> onToTransactionPin({VoidCallback? onSuccess}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _authRepository.resendOtp(
        email: '${ConversationState.self.email}',
        purpose: 'Transaction-Pin',
      );

      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message: " Otp has been sent to ${ConversationState.self.email}");
        if (onSuccess != null) {
          onSuccess();
        }
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> onToChangeTransactionPin({VoidCallback? onSuccess}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _authRepository.resendOtp(
        email: '${ConversationState.self.email}',
        purpose: 'Change-Transaction-Pin',
      );

      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message: " Otp has been sent to ${ConversationState.self.email}");
        if (onSuccess != null) {
          onSuccess();
        }
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> onToChangePassword({VoidCallback? onSuccess}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _authRepository.resendOtp(
        email: '${ConversationState.self.email}',
        purpose: 'Reset-Password',
      );

      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message: " Otp has been sent to ${ConversationState.self.email}");
        if (onSuccess != null) {
          onSuccess();
        }
      }
    } catch (_) {
    } finally {
      if (mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<void> onResendPayoutOtp() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _authRepository.resendOtp(
        email: '${ConversationState.self.email}',
        purpose: 'PAYOUT',
      );

      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message:
                "A Password reset Otp has been sent to ${ConversationState.self.email}");
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> onSubmitPayoutPin(VoidCallback onSuccess) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _authRepository.resendOtp(
        email: '${ConversationState.self.email}',
        purpose: 'PAYOUT',
      );

      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message:
                "A Password reset Otp has been sent to ${ConversationState.self.email}");
        onSuccess();
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void _validateInputs() {
    final RegExp regexp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    final isButtonEnabled =
        state.email.text.isNotEmpty && regexp.hasMatch(state.email.text) ||
            state.phone.text.isNotEmpty;

    state = state.copyWith(isButtonEnabled: isButtonEnabled);
  }
}

final credentialInputProvider = StateNotifierProvider.autoDispose<
    CredentialInputNotifier,
    CredentialInputState>((ref) => CredentialInputNotifier(ref));

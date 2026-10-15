import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/components/modals/error.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/core/service/snackbar_service.dart';
import 'package:wayagram/features/chat/state/default.dart';

part 'credential_input_vm.g.dart';

class CredentialInputState {
  final bool isEmail;
  final bool isButtonEnabled;
  final bool isLoading;

  CredentialInputState({
    this.isEmail = true,
    this.isButtonEnabled = false,
    this.isLoading = false,
  });

  CredentialInputState copyWith({
    bool? isEmail,
    bool? isButtonEnabled,
    bool? isLoading,
  }) {
    return CredentialInputState(
      isEmail: isEmail ?? this.isEmail,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class CredentialInput extends _$CredentialInput {
  final _snackbarService = SnackbarService();

  @override
  CredentialInputState build() {
    return CredentialInputState();
  }

  Future<void> onSubmit(VoidCallback onSuccess, String email) async {
    try {
      state = state.copyWith(isLoading: true);
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.verifyEmail(email);

      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message: "A Password reset Otp has been resent to $email");
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
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.resendOtp(
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
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> onToTransactionPin({VoidCallback? onSuccess}) async {
    try {
      state = state.copyWith(isLoading: true);
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.resendOtp(
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
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> onToChangeTransactionPin({VoidCallback? onSuccess}) async {
    try {
      state = state.copyWith(isLoading: true);
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.resendOtp(
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
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> onToChangePassword({VoidCallback? onSuccess}) async {
    try {
      state = state.copyWith(isLoading: true);
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.resendOtp(
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
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> onResendPayoutOtp() async {
    try {
      state = state.copyWith(isLoading: true);
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.resendOtp(
        email: '${ConversationState.self.email}',
        purpose: 'PAYOUT',
      );

      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message:
                "A Password reset Otp has been sent to ${ConversationState.self.email}");
      }
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> onSubmitPayoutPin(VoidCallback onSuccess) async {
    try {
      state = state.copyWith(isLoading: true);
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.resendOtp(
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
    } catch (_) {
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void validateInputs(String email, String phone) {
    final RegExp regexp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    final isButtonEnabled =
        email.isNotEmpty && regexp.hasMatch(email) || phone.isNotEmpty;

    state = state.copyWith(isButtonEnabled: isButtonEnabled);
  }
}

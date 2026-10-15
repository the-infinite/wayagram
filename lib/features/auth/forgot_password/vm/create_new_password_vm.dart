import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/components/modals/error.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/data/model/auth_model.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';

part 'create_new_password_vm.g.dart';

class CreateNewPasswordState {
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isConfirmPasswordFocused;
  final bool isPasswordFocused;
  final bool isLoading;

  CreateNewPasswordState({
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isConfirmPasswordFocused = false,
    this.isPasswordFocused = false,
    this.isLoading = false,
  });

  CreateNewPasswordState copyWith({
    bool? isButtonEnabled,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isConfirmPasswordFocused,
    bool? isPasswordFocused,
    bool? isLoading,
  }) {
    return CreateNewPasswordState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isConfirmPasswordFocused:
          isConfirmPasswordFocused ?? this.isConfirmPasswordFocused,
      isPasswordFocused: isPasswordFocused ?? this.isPasswordFocused,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class CreateNewPassword extends _$CreateNewPassword {
  @override
  CreateNewPasswordState build() {
    return CreateNewPasswordState();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
        isConfirmPasswordVisible: !state.isConfirmPasswordVisible);
  }

  void setConfirmPasswordFocus(bool hasFocus) {
    state = state.copyWith(isConfirmPasswordFocused: hasFocus);
  }

  void setPasswordFocus(bool hasFocus) {
    state = state.copyWith(isPasswordFocused: hasFocus);
  }

  Future<void> onSubmit(
    String email,
    String otp,
    String password,
    String confirmPassword,
  ) async {
    try {
      state = state.copyWith(isLoading: true);

      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.resetPassword(ForgotPassword(
          confirmPassword: confirmPassword,
          newPassword: password,
          email: email,
          otp: otp));

      if (response.data["statusCode"] == 200) {
        WayaNav.toNamed('/changed-password-success');
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
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/auth/data/model/auth_model.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class CreateNewPasswordVm extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final _logger = getLogger('CreateNewPasswordVm');
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  bool _isButtonEnabled = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final bool _isFocused = false;
  bool _isConfirmPasswordFocused = false;
  bool _isPasswordFocused = false;
  bool _isLoading = false;

  final Ref ref;

  CreateNewPasswordVm(this.ref);

  bool get isButtonEnabled => _isButtonEnabled;
  bool get isConfirmPasswordFocused => _isConfirmPasswordFocused;
  bool get isPasswordFocused => _isPasswordFocused;
  bool get isLoading => _isLoading;
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  void setConfirmPasswordFocus(bool hasFocus) {
    _isConfirmPasswordFocused = hasFocus;
    notifyListeners();
  }

  void setPasswordFocus(bool hasFocus) {
    _isPasswordFocused = hasFocus;
    notifyListeners();
  }

  Future<void> onSubmit(String email, String otp) async {
    print("$email $otp ${confirmPassword.text} ${password.text}");
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _authRepository.resetPassword(ForgotPassword(
          confirmPassword: confirmPassword.text,
          newPassword: password.text,
          email: email,
          otp: otp));

      if (response.data["statusCode"] == 200) {
        WayaNav.toNamed('/changed-password-success');
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void validatePasswords() {
    _isButtonEnabled = password.text.isNotEmpty &&
        confirmPassword.text.isNotEmpty &&
        password.text.length >= 8 &&
        confirmPassword.text.length >= 8 &&
        password.text == confirmPassword.text;
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    password.addListener(validatePasswords);
    confirmPassword.addListener(validatePasswords);
  }

  @override
  void dispose() {
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }
}

final createNewPasswordProvider = ChangeNotifierProvider.autoDispose((ref) {
  return CreateNewPasswordVm(ref);
});

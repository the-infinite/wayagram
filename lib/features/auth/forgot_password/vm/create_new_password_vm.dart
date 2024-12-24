import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class CreateNewPasswordVm extends ChangeNotifier {
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  bool _isButtonEnabled = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  final Ref ref;

  CreateNewPasswordVm(this.ref);

  bool get isButtonEnabled => _isButtonEnabled;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  void submit() {
    WayaNav.toNamed('/changed-password-success');
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

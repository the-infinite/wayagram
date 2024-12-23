import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class CreateNewPasswordState {
  final TextEditingController password;
  final TextEditingController confirmPassword;

  bool isPasswordVisible;
  bool isConfirmPasswordVisible;

  CreateNewPasswordState(
      {this.isConfirmPasswordVisible = false,
      this.isPasswordVisible = false,
      String password = '',
      String confirmPassword = ''})
      : password = TextEditingController(text: password),
        confirmPassword = TextEditingController(text: confirmPassword);

  CreateNewPasswordState copyWith(
      {bool? isPasswordVisible, bool? isConfirmPasswordVisible}) {
    return CreateNewPasswordState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      password: password.text,
      confirmPassword: confirmPassword.text,
    );
  }
}

class CreateNewPasswordVm extends Notifier<CreateNewPasswordState> {
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

  void submit() {
    WayaNav.toNamed('/changed-password-success');
  }
}

final createNewPasswordProvider =
    NotifierProvider<CreateNewPasswordVm, CreateNewPasswordState>(() {
  return CreateNewPasswordVm();
});

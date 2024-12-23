import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalFirstStepState {
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController email;
  final TextEditingController referralCode;
  final TextEditingController password;
  final TextEditingController confirmPassword;
  final TextEditingController phone;
  bool isPasswordVisible;
  bool isConfirmPasswordVisible;
  bool isAgreeToTerm;

  PersonalFirstStepState(
      {this.isConfirmPasswordVisible = false,
      this.isPasswordVisible = false,
      this.isAgreeToTerm = false,
      String firstName = '',
      String lastName = '',
      String email = '',
      String referralCode = '',
      String password = '',
      String phone = '',
      String confirmPassword = ''})
      : firstName = TextEditingController(text: firstName),
        lastName = TextEditingController(text: lastName),
        email = TextEditingController(text: email),
        password = TextEditingController(text: password),
        referralCode = TextEditingController(text: referralCode),
        confirmPassword = TextEditingController(text: confirmPassword),
        phone = TextEditingController(text: phone);
}

class PersonalFirstStepVm extends Notifier<PersonalFirstStepState> {
  @override
  PersonalFirstStepState build() {
    return PersonalFirstStepState();
  }

  void togglePasswordVisibility() {
    state = PersonalFirstStepState(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state = PersonalFirstStepState(isConfirmPasswordVisible: !state.isConfirmPasswordVisible);
  }

  void toggleTerm(bool value) {
    state = PersonalFirstStepState(isAgreeToTerm: value);
  }

  void submit() {}
}

// Add provider
final personalFirstStepProvider =
    NotifierProvider<PersonalFirstStepVm, PersonalFirstStepState>(() {
  return PersonalFirstStepVm();
});

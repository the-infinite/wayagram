import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalFirstStepVm extends ChangeNotifier {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController referralCode = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController phone = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isAgreeToTerm = false;
  bool _isButtonEnabled = false;

  final Ref ref;

  PersonalFirstStepVm(this.ref);

  bool get isButtonEnabled => _isButtonEnabled;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  void toggleTerm(bool? value) {
    isAgreeToTerm = value!;
    notifyListeners();
  }

  void validateInputs() {
    final RegExp regexp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    _isButtonEnabled = firstName.text.isNotEmpty &&
        lastName.text.isNotEmpty &&
        email.text.isNotEmpty &&
        regexp.hasMatch(email.text) &&
        password.text.isNotEmpty &&
        password.text.length >= 8 &&
        confirmPassword.text == password.text && phone.text.isNotEmpty &&
        isAgreeToTerm;
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    email.addListener(validateInputs);
    phone.addListener(validateInputs);
    firstName.addListener(validateInputs);
    lastName.addListener(validateInputs);
    password.addListener(validateInputs);
    confirmPassword.addListener(validateInputs);
    
  }

   @override
  void dispose() {
    phone.dispose();
    email.dispose();
    firstName.dispose();
    lastName.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  void submit() {}
}

final personalFirstStepProvider =
    ChangeNotifierProvider.autoDispose((ref) => PersonalFirstStepVm(ref));

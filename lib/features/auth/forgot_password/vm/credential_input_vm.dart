import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CredentialInputVm extends ChangeNotifier {
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  bool isEmail = true;
  bool _isButtonEnabled = false;

  final Ref ref;

  CredentialInputVm(this.ref);

  bool get isButtonEnabled => _isButtonEnabled;

  void toggle() {
    if (isEmail) {
      email.text = '';
    } else {
      phone.text = '';
    }
    notifyListeners();
  }

  void submit() {}

  void validateInputs() {
    final RegExp regexp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    _isButtonEnabled = email.text.isNotEmpty && regexp.hasMatch(email.text) ||
        phone.text.isNotEmpty;

    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    email.addListener(validateInputs);
    phone.addListener(validateInputs);
  }

  @override
  void dispose() {
    phone.dispose();
    email.dispose();
    super.dispose();
  }
}

final credentialInputProvider = ChangeNotifierProvider.autoDispose((ref) {
  return CredentialInputVm(ref);
});

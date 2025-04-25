import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/core/service/snackbar_service.dart';
import 'package:wayagram/features/chat/state/default.dart';

class CredentialInputVm extends ChangeNotifier {
  final _logger = getLogger("CredentialInputVm");
  final AuthRepository _authRepository = AuthRepository();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final SnackbarService _snackbarService = SnackbarService();

  bool isEmail = true;
  bool _isButtonEnabled = false;
  bool _isLoading = false;

  final Ref ref;

  CredentialInputVm(this.ref);

  bool get isButtonEnabled => _isButtonEnabled;
  bool get isLoading => _isLoading;

  void toggle() {
    if (isEmail) {
      email.text = '';
    } else {
      phone.text = '';
    }
    notifyListeners();
  }

  Future<void> onSubmit(VoidCallback onSuccess) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await _authRepository.verifyEmail(email.text);

      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message: "A Password reset Otp has been resend to ${email.text}");
        onSuccess();
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onSubmitPin(VoidCallback onSuccess) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await _authRepository.resendOtp('${ConversationState.self.email}', purpose: 'Reset_PIN');

      if (response.data["statusCode"] == 200) {
        _snackbarService.showCustomSnackbar(
            variant: SnackbarType.success,
            message: "A Password reset Otp has been sent to ${ConversationState.self.email}");
        onSuccess();
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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

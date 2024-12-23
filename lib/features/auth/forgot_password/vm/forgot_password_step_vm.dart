import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordStepState {
  String accountType = "";

  ForgotPasswordStepState({this.accountType = ''});
}

class ForgotPasswordStepVm extends Notifier<ForgotPasswordStepState> {
  @override
  ForgotPasswordStepState build() {
    return ForgotPasswordStepState();
  }

  void updateSelectedType(String type) {
    state = ForgotPasswordStepState(accountType: type);
  }
}

// Add provider
final accountCreationProvider =
    NotifierProvider<ForgotPasswordStepVm, ForgotPasswordStepState>(() {
  return ForgotPasswordStepVm();
});

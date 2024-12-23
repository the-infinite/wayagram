import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyAccountState {
  bool isEditing;
  String inputCode;

  VerifyAccountState({this.inputCode = '', this.isEditing = false});
}

class VerifyAccountVm extends Notifier<VerifyAccountState> {
  @override
  VerifyAccountState build() {
    return VerifyAccountState();
  }

  void onCodeChanged(String value) {
    state = VerifyAccountState(inputCode: value);
  }

  void onEditited(bool value) {
    state = VerifyAccountState(isEditing: value);
  }

  void verifyAccount() {
    
  }
}

final verifyAccountProvider =
    NotifierProvider<VerifyAccountVm, VerifyAccountState>(() {
  return VerifyAccountVm();
});

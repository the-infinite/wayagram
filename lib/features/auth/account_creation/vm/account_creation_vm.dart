import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountCreationState {
  String accountType = "";

  AccountCreationState({this.accountType = ''});
}

class AccountCreationVm extends Notifier<AccountCreationState> {
  @override
  AccountCreationState build() {
    return AccountCreationState();
  }

  void updateSelectedType(String type) {
    state = AccountCreationState(accountType: type);
  }
}

// Add provider
final accountCreationProvider =
    NotifierProvider<AccountCreationVm, AccountCreationState>(() {
  return AccountCreationVm();
});

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_creation_vm.g.dart';

class AccountCreationState {
  String accountType = "";

  AccountCreationState({this.accountType = ''});
}

@riverpod
class AccountCreation extends _$AccountCreation {
  @override
  AccountCreationState build() {
    return AccountCreationState();
  }

  void updateSelectedType(String type) {
    state = AccountCreationState(accountType: type);
  }
}

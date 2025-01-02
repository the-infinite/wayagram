import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/auth/account_creation/data/select_account_data.dart';

class AccountState {
  String selectedType;

  AccountState({this.selectedType = ""});
}

class SelectAccountVm extends StateNotifier<AccountState> {
  SelectAccountVm() : super(AccountState());

  String get selectedType => state.selectedType;
  List<SelectAccountData> get data => selectAccountData;

  void setSelectedType(String type) {
    state = AccountState(selectedType: type);
  }

}

final selectAccountProvider =
    StateNotifierProvider<SelectAccountVm, AccountState>((ref) {
  return SelectAccountVm();
});

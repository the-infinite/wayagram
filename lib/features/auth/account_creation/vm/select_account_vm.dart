import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/features/auth/account_creation/data/select_account_data.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';

part 'select_account_vm.g.dart';

class AccountState {
  SelectAccountData? selectedType;

  AccountState({this.selectedType});

  AccountState copyWith({
    SelectAccountData? selectedType,
  }) {
    return AccountState(
      selectedType: selectedType ?? this.selectedType,
    );
  }
}

@riverpod
class SelectAccount extends _$SelectAccount {
  @override
  AccountState build() {
    return AccountState();
  }

  void setSelectedType(SelectAccountData account) {
    state = state.copyWith(selectedType: account);
  }
}

@riverpod
class SelectAccountTypes extends _$SelectAccountTypes {
  @override
  Future<List<SelectAccountData>> build() async {
    return fetchAccountType();
  }

  Future<List<SelectAccountData>> fetchAccountType() async {
    try {
      final authRepository = ref.watch(authRepositoryProvider);
      final response = await authRepository.getAccountType();
      final accountTypes = response.data['data'] as List;

      final accountData = selectAccountData
          .map((item) => SelectAccountData(
                avatar: item.avatar,
                title: item.title,
                description: item.description,
                type: item.type,
                id: accountTypes.firstWhere(
                    (element) => element['name'] == item.type)['id'],
              ))
          .toList();
      return accountData;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/features/auth/account_creation/data/select_account_data.dart';

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

class SelectAccountVm extends StateNotifier<AccountState> {
  final Ref ref;
  SelectAccountVm(this.ref) : super(AccountState());



  void setSelectedType(SelectAccountData account) {
    state = state.copyWith(selectedType: account);
  }
}

final selectAccountProvider =
    StateNotifierProvider<SelectAccountVm, AccountState>((ref) {
  return SelectAccountVm(ref);
});

class SelectAccountTypes
    extends StateNotifier<AsyncValue<List<SelectAccountData>>> {
  final AuthRepository _authRepository;
  final _logger = getLogger('SelectAccountTypes');

  SelectAccountTypes(this._authRepository) : super(const AsyncValue.loading()) {
    fetchAccountType();
  }

  Future<List<SelectAccountData>?> fetchAccountType() async {
    try {
      state = const AsyncValue.loading();
      final response = await _authRepository.getAccountType();
      _logger.d(response.data);
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
      state = AsyncValue.data(accountData);
      return accountData;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);

      _logger.e(e);
      return null;
    }
  }

  Future<void> refresh() async {
    await fetchAccountType();
  }
}

final authRepositoryProvider = Provider((ref) => AuthRepository());

final selectAccountTypesProvider = StateNotifierProvider<SelectAccountTypes,
    AsyncValue<List<SelectAccountData>>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SelectAccountTypes(authRepository);
});

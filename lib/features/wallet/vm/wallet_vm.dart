import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/service/repos/wallet/wallet_repository.dart';
import 'package:wayagram/features/wallet/model/wallet_model.dart';
import 'package:wayagram/features/wallet/model/wallet_state_model.dart';

class WalletVm extends StateNotifier<WalletState> {
  final WalletRepository? _walletRepository;
  WalletVm(this._walletRepository) : super(WalletState());

  Future<void> getUserWallet() async {
    state = state.copyWith(isLoading: true);
    final response = await _walletRepository!.getUserWallet();
    if (response.success == true) {
      state = state.copyWith(
          data: Wallet.fromJson(response.data), isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }
}

final walletVmProvider = StateNotifierProvider<WalletVm, WalletState>((ref) {
  return WalletVm(WalletRepository());
});

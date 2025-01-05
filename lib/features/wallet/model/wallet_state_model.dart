import 'package:wayagram/features/wallet/model/wallet_model.dart';

class WalletState {
  final bool? isLoading;
  final Wallet? data;
  WalletState({this.isLoading = false, this.data});

  WalletState copyWith({bool? isLoading, Wallet? data}) => WalletState(
      isLoading: isLoading ?? this.isLoading, data: data ?? this.data);
}

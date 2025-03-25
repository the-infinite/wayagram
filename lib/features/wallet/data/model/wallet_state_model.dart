import 'package:wayagram/features/wallet/data/model/external_wallet_model.dart';
import 'package:wayagram/features/wallet/data/model/wallet_model.dart';

class WalletState {
  final bool? isLoading;
  final bool? isMakePaymentLoading;
  final Wallet? data;
  final List<ExternalWalletModel>? externalWallets;
  WalletState({
    this.isLoading = false,
    this.isMakePaymentLoading = false,
    this.data,
    this.externalWallets,
  });

  WalletState copyWith({
    bool? isLoading,
    Wallet? data,
    List<ExternalWalletModel>? externalWallets,
  }) =>
      WalletState(
        isLoading: isLoading ?? this.isLoading,
        data: data ?? this.data,
        externalWallets: externalWallets ?? this.externalWallets,
      );
}

class WalletFundingOptionState {
  final bool? isLoading;
  final List<WalletFundingOptionModel>? fundingOptions;
  WalletFundingOptionState({this.isLoading = false, this.fundingOptions});

  WalletFundingOptionState copyWith({bool? isLoading, List<WalletFundingOptionModel>? fundingOptions}) =>
      WalletFundingOptionState(
          isLoading: isLoading ?? this.isLoading, fundingOptions: fundingOptions ?? this.fundingOptions);
}

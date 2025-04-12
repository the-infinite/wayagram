import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/shared/features/wallet/model/dto.dart';

part 'wallet_model.g.dart';

@JsonSerializable()
class CreateWalletPin {
  final String userId;
  final String pin;
  final String confirmPin;

  CreateWalletPin(
      {required this.confirmPin, required this.pin, required this.userId});

  factory CreateWalletPin.fromJson(Map<String, dynamic> json) =>
      _$CreateWalletPinFromJson(json);

  Map<String, dynamic> toJson() {
    return _$CreateWalletPinToJson(this);
  }
}

@JsonSerializable()
class ConfirmWalletPin {
  final String userId;
  final String pin;

  ConfirmWalletPin({required this.pin, required this.userId});

  factory ConfirmWalletPin.fromJson(Map<String, dynamic> json) =>
      _$ConfirmWalletPinFromJson(json);

  Map<String, dynamic> toJson() {
    return _$ConfirmWalletPinToJson(this);
  }
}

@JsonSerializable()
class FundWallet {
  final String userId;
  final String fundOptionCode;
  final double amount;
  final String email;
  final String description;
  final String? callbackUrl;

  FundWallet({
    required this.userId,
    required this.fundOptionCode,
    required this.amount,
    required this.email,
    required this.description,
    this.callbackUrl,
  });

  factory FundWallet.fromJson(Map<String, dynamic> json) =>
      _$FundWalletFromJson(json);

  Map<String, dynamic> toJson() {
    return _$FundWalletToJson(this);
  }
}

@JsonSerializable()
class VerifyTransaction {
  final String userId;
  final String fundOptionCode;
  final String transactionId;

  VerifyTransaction({
    required this.userId,
    required this.fundOptionCode,
    required this.transactionId,
  });

  factory VerifyTransaction.fromJson(Map<String, dynamic> json) =>
      _$VerifyTransactionFromJson(json);

  Map<String, dynamic> toJson() {
    return _$VerifyTransactionToJson(this);
  }
}

typedef PayForService = WalletPaymentData;

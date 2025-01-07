import 'package:json_annotation/json_annotation.dart';

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

@JsonSerializable()
class PayForService {
  final String recipientId;
  final String userId;
  final double amount;
  final String purpose;
  final String referenceId;
  final String description;
  final Map<String, dynamic>? metadata;

  PayForService({
    required this.recipientId,
    required this.userId,
    required this.amount,
    required this.purpose,
    required this.referenceId,
    required this.description,
    this.metadata,
  });

  factory PayForService.fromJson(Map<String, dynamic> json) =>
      _$PayForServiceFromJson(json);

  Map<String, dynamic> toJson() => _$PayForServiceToJson(this);
}

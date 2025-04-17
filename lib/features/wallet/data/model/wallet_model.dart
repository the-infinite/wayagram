import 'package:json_annotation/json_annotation.dart';

part 'wallet_model.g.dart';

@JsonSerializable()
class Wallet {
  final String id;
  final String userId;
  final String balance;
  final String currency;
  final String provider;
  final bool isDefault;
  final bool isAdmin;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Wallet({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    required this.provider,
    required this.isDefault,
    required this.isAdmin,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  double get balanceNumber => double.tryParse(balance.replaceAll(",", "")) ?? 0;

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
  Map<String, dynamic> toJson() => _$WalletToJson(this);
}

@JsonSerializable()
class WalletFundingOptionModel {
  final String code;
  final String name;
  final String description;

  WalletFundingOptionModel({
    required this.code,
    required this.name,
    required this.description,
  });

  factory WalletFundingOptionModel.fromJson(Map<String, dynamic> json) => _$WalletFundingOptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletFundingOptionModelToJson(this);
}

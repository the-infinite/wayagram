import 'package:json_annotation/json_annotation.dart';

part 'external_wallet_model.g.dart';

@JsonSerializable()
class ExternalWalletModel {
  final String id;
  final String userId;
  final String provider;
  final String accountName;
  final String accountNumber;
  final String providerName;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExternalWalletModel({
    required this.id,
    required this.userId,
    required this.provider,
    required this.accountName,
    required this.accountNumber,
    required this.providerName,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExternalWalletModel.fromJson(Map<String, dynamic> json) =>
      _$ExternalWalletModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExternalWalletModelToJson(this);

  @override
  String toString() {
    return 'ExternalWalletModel{'
        'id: $id,'
        'userId: $userId,'
        'provider: $provider,'
        'accountName: $accountName,'
        'accountNumber: $accountNumber,'
        'providerName: $providerName,'
        'type: $type,'
        'createdAt: $createdAt,'
        'updatedAt: $updatedAt}';
  }
}

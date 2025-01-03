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

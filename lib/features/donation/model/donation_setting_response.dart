import 'package:json_annotation/json_annotation.dart';

part 'donation_setting_response.g.dart';

@JsonSerializable()
class DonationSettingsModel {
  DonationSettingsModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
    required this.responseCode,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final Data? data;
  final int? responseCode;

  factory DonationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$DonationSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DonationSettingsModelToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    required this.id,
    required this.userId,
    required this.notifyFriends,
    required this.makeDonationsPublic,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? userId;
  final bool? notifyFriends;
  final bool? makeDonationsPublic;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

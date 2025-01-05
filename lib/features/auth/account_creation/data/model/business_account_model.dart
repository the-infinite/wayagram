import 'package:json_annotation/json_annotation.dart';

part 'business_account_model.g.dart';

@JsonSerializable()
class BusinessAccountData {
  final String id;
  final bool isActive;
  final String? deletedAt;
  final String name;
  final String address;
  final String businessTypeId;
  final String userId;
  final String businessId;
  final String updatedAt;
  final String createdAt;
  final String? contactEmail;
  final String? contactPhone;
  final String? description;
  final String? logoUrl;
  final String? websiteUrl;
  final String? city;
  final String? state;
  final String? country;
  final String? verifiedAt;
  @JsonKey(name: '_v')
  final String? v;

  BusinessAccountData({
    required this.id,
    required this.isActive,
    this.deletedAt,
    required this.v,
    required this.name,
    required this.address,
    required this.businessTypeId,
    required this.userId,
    required this.businessId,
    required this.updatedAt,
    required this.createdAt,
    this.contactEmail,
    this.contactPhone,
    this.description,
    this.logoUrl,
    this.websiteUrl,
    this.city,
    this.state,
    this.country,
    this.verifiedAt,
  });

  factory BusinessAccountData.fromJson(Map<String, dynamic> json) => _$BusinessAccountDataFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessAccountDataToJson(this);
}
import 'package:json_annotation/json_annotation.dart';

part 'business_account_model.g.dart';

@JsonSerializable()
class BusinessAccountData {
  final String? id;
  final bool isActive;
  final String? deletedAt;
  final String? name;
  final String? address;
  final String? businessTypeId;
  final String? userId;
  final String? businessId;
  final String? updatedAt;
  final String? createdAt;
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
  final String? lga;

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
    this.lga,
  });

  factory BusinessAccountData.fromJson(Map<String, dynamic> json) {
    return BusinessAccountData(
      id: json['id'] as String?,
      isActive: json['isActive'] as bool? ?? false,
      deletedAt: json['deletedAt'] as String?,
      v: json['_v'] as String?,
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      businessTypeId: json['businessTypeId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      businessId: json['businessId'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      verifiedAt: json['verifiedAt'] as String?,
      lga: json['lga'] as String?
    );
  }

  Map<String, dynamic> toJson() => _$BusinessAccountDataToJson(this);
}

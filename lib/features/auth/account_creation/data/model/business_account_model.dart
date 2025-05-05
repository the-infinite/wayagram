import 'package:json_annotation/json_annotation.dart';

part 'business_account_model.g.dart';

@JsonSerializable(createFactory: false)
class BusinessAccountData {
  final dynamic id;
  final bool isActive;
  final dynamic deletedAt;
  final dynamic name;
  final dynamic address;
  final dynamic businessTypeId;
  final dynamic userId;
  final dynamic businessId;
  final dynamic updatedAt;
  final dynamic createdAt;
  final dynamic contactEmail;
  final dynamic contactPhone;
  final dynamic description;
  final dynamic logoUrl;
  final dynamic websiteUrl;
  final dynamic city;
  final dynamic state;
  final dynamic country;
  final dynamic verifiedAt;
  @JsonKey(name: '_v')
  final dynamic v;
  final dynamic lga;

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
      id: json['id'] ,
      isActive: json['isActive'] as bool? ?? false,
      deletedAt: json['deletedAt'],
      v: json['_v'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      businessTypeId: json['businessTypeId']  ?? '',
      userId: json['userId'] ??'',
      businessId: json['businessId']?? '',
      updatedAt: json['updatedAt']  ?? '',
      createdAt: json['createdAt']  ?? '',
      contactEmail: json['contactEmail'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      description: json['description'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      websiteUrl: json['websiteUrl'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'],
      verifiedAt: json['verifiedAt'] ?? '',
      lga: json['lga'] ?? ''
    );
  }

  Map<String, dynamic> toJson() => _$BusinessAccountDataToJson(this);
}

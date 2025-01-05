// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessAccountData _$BusinessAccountDataFromJson(Map<String, dynamic> json) =>
    BusinessAccountData(
      id: json['id'] as String,
      isActive: json['isActive'] as bool,
      deletedAt: json['deletedAt'] as String?,
      v: json['_v'] as String?,
      name: json['name'] as String,
      address: json['address'] as String,
      businessTypeId: json['businessTypeId'] as String,
      userId: json['userId'] as String,
      businessId: json['businessId'] as String,
      updatedAt: json['updatedAt'] as String,
      createdAt: json['createdAt'] as String,
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      verifiedAt: json['verifiedAt'] as String?,
    );

Map<String, dynamic> _$BusinessAccountDataToJson(
        BusinessAccountData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isActive': instance.isActive,
      'deletedAt': instance.deletedAt,
      'name': instance.name,
      'address': instance.address,
      'businessTypeId': instance.businessTypeId,
      'userId': instance.userId,
      'businessId': instance.businessId,
      'updatedAt': instance.updatedAt,
      'createdAt': instance.createdAt,
      'contactEmail': instance.contactEmail,
      'contactPhone': instance.contactPhone,
      'description': instance.description,
      'logoUrl': instance.logoUrl,
      'websiteUrl': instance.websiteUrl,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'verifiedAt': instance.verifiedAt,
      '_v': instance.v,
    };

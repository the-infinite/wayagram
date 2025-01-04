// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAccountModel _$UserAccountModelFromJson(Map<String, dynamic> json) =>
    UserAccountModel(
      message: json['message'] as String?,
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : UserAccountData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserAccountModelToJson(UserAccountModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'statusCode': instance.statusCode,
      'data': instance.data,
    };

UserAccountData _$UserAccountDataFromJson(Map<String, dynamic> json) =>
    UserAccountData(
      id: json['id'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      passwordHash: json['passwordHash'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      countryCode: json['countryCode'],
      middleName: json['middleName'],
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      twoFactorEnabled: json['twoFactorEnabled'] as bool?,
      profilePicture: json['profilePicture'],
      fcmToken: json['fcmToken'],
      emailVerified: json['emailVerified'] as bool?,
      phoneVerified: json['phoneVerified'] as bool?,
      accountStatus: json['accountStatus'] as String?,
      tcAgreement: json['tcAgreement'] as bool?,
      policyAgreement: json['policyAgreement'] as bool?,
      emailVerifiedDate: json['emailVerifiedDate'] == null
          ? null
          : DateTime.parse(json['emailVerifiedDate'] as String),
      deletedAt: json['deletedAt'],
      roleId: json['roleId'] as String?,
      accountTypeId: json['accountTypeId'] as String?,
      v: json['_v'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      role: json['role'] == null
          ? null
          : Role.fromJson(json['role'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserAccountDataToJson(UserAccountData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'passwordHash': instance.passwordHash,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'gender': instance.gender,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'countryCode': instance.countryCode,
      'middleName': instance.middleName,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'twoFactorEnabled': instance.twoFactorEnabled,
      'profilePicture': instance.profilePicture,
      'fcmToken': instance.fcmToken,
      'emailVerified': instance.emailVerified,
      'phoneVerified': instance.phoneVerified,
      'accountStatus': instance.accountStatus,
      'tcAgreement': instance.tcAgreement,
      'policyAgreement': instance.policyAgreement,
      'emailVerifiedDate': instance.emailVerifiedDate?.toIso8601String(),
      'deletedAt': instance.deletedAt,
      'roleId': instance.roleId,
      'accountTypeId': instance.accountTypeId,
      '_v': instance.v,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'role': instance.role,
    };

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
      name: json['name'] as String?,
    );

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'name': instance.name,
    };

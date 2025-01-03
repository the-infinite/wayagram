// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Register _$RegisterFromJson(Map<String, dynamic> json) => Register(
      email: json['email'] as String?,
      password: json['password'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      gender: json['gender'] as String?,
      accountTypeId: json['accountTypeId'] as String?,
      tcAgreement: json['tcAgreement'] as bool?,
      policyAgreement: json['policyAgreement'] as bool?,
      confirmPassword: json['confirmPassword'] as String?,
      business: json['business'] as Map<String, dynamic>?,
      referenceCode: json['referenceCode'] as String?,
    );

Map<String, dynamic> _$RegisterToJson(Register instance) => <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'dateOfBirth': instance.dateOfBirth,
      'gender': instance.gender,
      'accountTypeId': instance.accountTypeId,
      'tcAgreement': instance.tcAgreement,
      'policyAgreement': instance.policyAgreement,
      'referenceCode': instance.referenceCode,
      'business': instance.business,
    };

VerifyOtp _$VerifyOtpFromJson(Map<String, dynamic> json) => VerifyOtp(
      email: json['email'] as String,
      otp: json['otp'] as String,
    );

Map<String, dynamic> _$VerifyOtpToJson(VerifyOtp instance) => <String, dynamic>{
      'email': instance.email,
      'otp': instance.otp,
    };

ForgotPassword _$ForgotPasswordFromJson(Map<String, dynamic> json) =>
    ForgotPassword(
      confirmPassword: json['confirmPassword'] as String,
      newPassword: json['newPassword'] as String,
      email: json['email'] as String,
      otp: json['otp'] as String,
    );

Map<String, dynamic> _$ForgotPasswordToJson(ForgotPassword instance) =>
    <String, dynamic>{
      'email': instance.email,
      'otp': instance.otp,
      'newPassword': instance.newPassword,
      'confirmPassword': instance.confirmPassword,
    };

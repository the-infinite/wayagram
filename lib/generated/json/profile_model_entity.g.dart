import 'package:wayagram/generated/json/base/json_convert_content.dart';
import 'package:wayagram/app/data/model/profile_model_entity.dart';

ProfileModelEntity $ProfileModelEntityFromJson(Map<String, dynamic> json) {
	final ProfileModelEntity profileModelEntity = ProfileModelEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		profileModelEntity.id = id;
	}
	final String? email = jsonConvert.convert<String>(json['email']);
	if (email != null) {
		profileModelEntity.email = email;
	}
	final String? firstName = jsonConvert.convert<String>(json['firstName']);
	if (firstName != null) {
		profileModelEntity.firstName = firstName;
	}
	final String? surname = jsonConvert.convert<String>(json['surname']);
	if (surname != null) {
		profileModelEntity.surname = surname;
	}
	final String? dateOfBirth = jsonConvert.convert<String>(json['dateOfBirth']);
	if (dateOfBirth != null) {
		profileModelEntity.dateOfBirth = dateOfBirth;
	}
	final String? gender = jsonConvert.convert<String>(json['gender']);
	if (gender != null) {
		profileModelEntity.gender = gender;
	}
	final String? phoneNumber = jsonConvert.convert<String>(json['phoneNumber']);
	if (phoneNumber != null) {
		profileModelEntity.phoneNumber = phoneNumber;
	}
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		profileModelEntity.userId = userId;
	}
	final String? referral = jsonConvert.convert<String>(json['referral']);
	if (referral != null) {
		profileModelEntity.referral = referral;
	}
	final String? referenceCode = jsonConvert.convert<String>(json['referenceCode']);
	if (referenceCode != null) {
		profileModelEntity.referenceCode = referenceCode;
	}
	final bool? smsAlertConfig = jsonConvert.convert<bool>(json['smsAlertConfig']);
	if (smsAlertConfig != null) {
		profileModelEntity.smsAlertConfig = smsAlertConfig;
	}
	final bool? corporate = jsonConvert.convert<bool>(json['corporate']);
	if (corporate != null) {
		profileModelEntity.corporate = corporate;
	}
	final ProfileModelOtherDetails? otherDetails = jsonConvert.convert<ProfileModelOtherDetails>(json['otherDetails']);
	if (otherDetails != null) {
		profileModelEntity.otherDetails = otherDetails;
	}
	return profileModelEntity;
}

Map<String, dynamic> $ProfileModelEntityToJson(ProfileModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['email'] = entity.email;
	data['firstName'] = entity.firstName;
	data['surname'] = entity.surname;
	data['dateOfBirth'] = entity.dateOfBirth;
	data['gender'] = entity.gender;
	data['phoneNumber'] = entity.phoneNumber;
	data['userId'] = entity.userId;
	data['referral'] = entity.referral;
	data['referenceCode'] = entity.referenceCode;
	data['smsAlertConfig'] = entity.smsAlertConfig;
	data['corporate'] = entity.corporate;
	data['otherDetails'] = entity.otherDetails?.toJson();
	return data;
}

ProfileModelOtherDetails $ProfileModelOtherDetailsFromJson(Map<String, dynamic> json) {
	final ProfileModelOtherDetails profileModelOtherDetails = ProfileModelOtherDetails();
	final String? organisationName = jsonConvert.convert<String>(json['organisationName']);
	if (organisationName != null) {
		profileModelOtherDetails.organisationName = organisationName;
	}
	final String? organisationEmail = jsonConvert.convert<String>(json['organisationEmail']);
	if (organisationEmail != null) {
		profileModelOtherDetails.organisationEmail = organisationEmail;
	}
	final String? organisationPhone = jsonConvert.convert<String>(json['organisationPhone']);
	if (organisationPhone != null) {
		profileModelOtherDetails.organisationPhone = organisationPhone;
	}
	final String? organizationCity = jsonConvert.convert<String>(json['organizationCity']);
	if (organizationCity != null) {
		profileModelOtherDetails.organizationCity = organizationCity;
	}
	final String? organizationAddress = jsonConvert.convert<String>(json['organizationAddress']);
	if (organizationAddress != null) {
		profileModelOtherDetails.organizationAddress = organizationAddress;
	}
	final String? organizationState = jsonConvert.convert<String>(json['organizationState']);
	if (organizationState != null) {
		profileModelOtherDetails.organizationState = organizationState;
	}
	final String? organisationType = jsonConvert.convert<String>(json['organisationType']);
	if (organisationType != null) {
		profileModelOtherDetails.organisationType = organisationType;
	}
	final String? businessType = jsonConvert.convert<String>(json['businessType']);
	if (businessType != null) {
		profileModelOtherDetails.businessType = businessType;
	}
	final bool? phoneVerified = jsonConvert.convert<bool>(json['phoneVerified']);
	if (phoneVerified != null) {
		profileModelOtherDetails.phoneVerified = phoneVerified;
	}
	final bool? emailVerified = jsonConvert.convert<bool>(json['emailVerified']);
	if (emailVerified != null) {
		profileModelOtherDetails.emailVerified = emailVerified;
	}
	return profileModelOtherDetails;
}

Map<String, dynamic> $ProfileModelOtherDetailsToJson(ProfileModelOtherDetails entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['organisationName'] = entity.organisationName;
	data['organisationEmail'] = entity.organisationEmail;
	data['organisationPhone'] = entity.organisationPhone;
	data['organizationCity'] = entity.organizationCity;
	data['organizationAddress'] = entity.organizationAddress;
	data['organizationState'] = entity.organizationState;
	data['organisationType'] = entity.organisationType;
	data['businessType'] = entity.businessType;
	data['phoneVerified'] = entity.phoneVerified;
	data['emailVerified'] = entity.emailVerified;
	return data;
}
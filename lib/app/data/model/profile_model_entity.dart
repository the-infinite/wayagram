import 'package:wayagram/generated/json/base/json_field.dart';
import 'package:wayagram/generated/json/profile_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class ProfileModelEntity {
	String? id;
	String? email;
	String? firstName;
	String? surname;
	String? dateOfBirth;
	String? gender;
	String? phoneNumber;
	String? userId;
	String? referral;
	String? referenceCode;
	bool? smsAlertConfig;
	bool? corporate;
	ProfileModelOtherDetails? otherDetails;
  
  ProfileModelEntity();

  factory ProfileModelEntity.fromJson(Map<String, dynamic> json) => $ProfileModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $ProfileModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ProfileModelOtherDetails {

	String? organisationName;
	String? organisationEmail;
	String? organisationPhone;
	String? organizationCity;
	String? organizationAddress;
	String? organizationState;
	String? organisationType;
	String? businessType;
	bool? phoneVerified;
	bool? emailVerified;
  
  ProfileModelOtherDetails();

  factory ProfileModelOtherDetails.fromJson(Map<String, dynamic> json) => $ProfileModelOtherDetailsFromJson(json);

  Map<String, dynamic> toJson() => $ProfileModelOtherDetailsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
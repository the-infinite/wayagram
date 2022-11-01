import 'package:wayagram/generated/json/base/json_field.dart';
import 'package:wayagram/generated/json/log_in_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class LogInModelEntity{
	String? corporateAccess;
	List<String>? roles;
	bool? pinCreated;
	String? userLocation;
	List<dynamic>? privilege;
	String? token;
	int? passwordAge;
	int? tokenAge;
	bool? corporate;
	int? transactionLimit;
	LogInModelUser? user;
  
  LogInModelEntity();

  factory LogInModelEntity.fromJson(Map<String, dynamic> json) => $LogInModelEntityFromJson(json);

  Map<String, dynamic> toJson() => $LogInModelEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class LogInModelUser {
	int? id;
	String? email;
	bool? isEmailVerified;
	String? phoneNumber;
	String? firstName;
	String? lastName;
	bool? isAdmin;
	bool? isPhoneVerified;
	bool? isAccountLocked;
	bool? isAccountExpired;
	bool? isCredentialsExpired;
	bool? isActive;
	bool? isAccountDeleted;
	String? referenceCode;
	bool? pinCreated;
	bool? isCorporate;
	String? gender;
	String? middleName;
	String? dateOfBirth;
	String? profileImage;
	String? district;
	String? address;
	String? city;
	String? state;
	String? createdAt;
	List<String>? roles;
	List<dynamic>? permits;
	List<dynamic>? links;
  
  LogInModelUser();

  factory LogInModelUser.fromJson(Map<String, dynamic> json) => $LogInModelUserFromJson(json);

  Map<String, dynamic> toJson() => $LogInModelUserToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
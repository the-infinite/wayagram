import 'package:wayagram/generated/json/base/json_convert_content.dart';
import 'package:wayagram/app/data/model/log_in_model_entity.dart';

LogInModelEntity $LogInModelEntityFromJson(Map<String, dynamic> json) {
	final LogInModelEntity logInModelEntity = LogInModelEntity();
	final String? corporateAccess = jsonConvert.convert<String>(json['corporateAccess']);
	if (corporateAccess != null) {
		logInModelEntity.corporateAccess = corporateAccess;
	}
	final List<String>? roles = jsonConvert.convertListNotNull<String>(json['roles']);
	if (roles != null) {
		logInModelEntity.roles = roles;
	}
	final bool? pinCreated = jsonConvert.convert<bool>(json['pinCreated']);
	if (pinCreated != null) {
		logInModelEntity.pinCreated = pinCreated;
	}
	final String? userLocation = jsonConvert.convert<String>(json['userLocation']);
	if (userLocation != null) {
		logInModelEntity.userLocation = userLocation;
	}
	final List<dynamic>? privilege = jsonConvert.convertListNotNull<dynamic>(json['privilege']);
	if (privilege != null) {
		logInModelEntity.privilege = privilege;
	}
	final String? token = jsonConvert.convert<String>(json['token']);
	if (token != null) {
		logInModelEntity.token = token;
	}
	final int? passwordAge = jsonConvert.convert<int>(json['passwordAge']);
	if (passwordAge != null) {
		logInModelEntity.passwordAge = passwordAge;
	}
	final int? tokenAge = jsonConvert.convert<int>(json['tokenAge']);
	if (tokenAge != null) {
		logInModelEntity.tokenAge = tokenAge;
	}
	final bool? corporate = jsonConvert.convert<bool>(json['corporate']);
	if (corporate != null) {
		logInModelEntity.corporate = corporate;
	}
	final int? transactionLimit = jsonConvert.convert<int>(json['transactionLimit']);
	if (transactionLimit != null) {
		logInModelEntity.transactionLimit = transactionLimit;
	}
	final LogInModelUser? user = jsonConvert.convert<LogInModelUser>(json['user']);
	if (user != null) {
		logInModelEntity.user = user;
	}
	return logInModelEntity;
}

Map<String, dynamic> $LogInModelEntityToJson(LogInModelEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['corporateAccess'] = entity.corporateAccess;
	data['roles'] =  entity.roles;
	data['pinCreated'] = entity.pinCreated;
	data['userLocation'] = entity.userLocation;
	data['privilege'] =  entity.privilege;
	data['token'] = entity.token;
	data['passwordAge'] = entity.passwordAge;
	data['tokenAge'] = entity.tokenAge;
	data['corporate'] = entity.corporate;
	data['transactionLimit'] = entity.transactionLimit;
	data['user'] = entity.user?.toJson();
	return data;
}

LogInModelUser $LogInModelUserFromJson(Map<String, dynamic> json) {
	final LogInModelUser logInModelUser = LogInModelUser();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		logInModelUser.id = id;
	}
	final String? email = jsonConvert.convert<String>(json['email']);
	if (email != null) {
		logInModelUser.email = email;
	}
	final bool? isEmailVerified = jsonConvert.convert<bool>(json['isEmailVerified']);
	if (isEmailVerified != null) {
		logInModelUser.isEmailVerified = isEmailVerified;
	}
	final String? phoneNumber = jsonConvert.convert<String>(json['phoneNumber']);
	if (phoneNumber != null) {
		logInModelUser.phoneNumber = phoneNumber;
	}
	final String? firstName = jsonConvert.convert<String>(json['firstName']);
	if (firstName != null) {
		logInModelUser.firstName = firstName;
	}
	final String? lastName = jsonConvert.convert<String>(json['lastName']);
	if (lastName != null) {
		logInModelUser.lastName = lastName;
	}
	final bool? isAdmin = jsonConvert.convert<bool>(json['isAdmin']);
	if (isAdmin != null) {
		logInModelUser.isAdmin = isAdmin;
	}
	final bool? isPhoneVerified = jsonConvert.convert<bool>(json['isPhoneVerified']);
	if (isPhoneVerified != null) {
		logInModelUser.isPhoneVerified = isPhoneVerified;
	}
	final bool? isAccountLocked = jsonConvert.convert<bool>(json['isAccountLocked']);
	if (isAccountLocked != null) {
		logInModelUser.isAccountLocked = isAccountLocked;
	}
	final bool? isAccountExpired = jsonConvert.convert<bool>(json['isAccountExpired']);
	if (isAccountExpired != null) {
		logInModelUser.isAccountExpired = isAccountExpired;
	}
	final bool? isCredentialsExpired = jsonConvert.convert<bool>(json['isCredentialsExpired']);
	if (isCredentialsExpired != null) {
		logInModelUser.isCredentialsExpired = isCredentialsExpired;
	}
	final bool? isActive = jsonConvert.convert<bool>(json['isActive']);
	if (isActive != null) {
		logInModelUser.isActive = isActive;
	}
	final bool? isAccountDeleted = jsonConvert.convert<bool>(json['isAccountDeleted']);
	if (isAccountDeleted != null) {
		logInModelUser.isAccountDeleted = isAccountDeleted;
	}
	final String? referenceCode = jsonConvert.convert<String>(json['referenceCode']);
	if (referenceCode != null) {
		logInModelUser.referenceCode = referenceCode;
	}
	final bool? pinCreated = jsonConvert.convert<bool>(json['pinCreated']);
	if (pinCreated != null) {
		logInModelUser.pinCreated = pinCreated;
	}
	final bool? isCorporate = jsonConvert.convert<bool>(json['isCorporate']);
	if (isCorporate != null) {
		logInModelUser.isCorporate = isCorporate;
	}
	final String? gender = jsonConvert.convert<String>(json['gender']);
	if (gender != null) {
		logInModelUser.gender = gender;
	}
	final String? middleName = jsonConvert.convert<String>(json['middleName']);
	if (middleName != null) {
		logInModelUser.middleName = middleName;
	}
	final String? dateOfBirth = jsonConvert.convert<String>(json['dateOfBirth']);
	if (dateOfBirth != null) {
		logInModelUser.dateOfBirth = dateOfBirth;
	}
	final String? profileImage = jsonConvert.convert<String>(json['profileImage']);
	if (profileImage != null) {
		logInModelUser.profileImage = profileImage;
	}
	final String? district = jsonConvert.convert<String>(json['district']);
	if (district != null) {
		logInModelUser.district = district;
	}
	final String? address = jsonConvert.convert<String>(json['address']);
	if (address != null) {
		logInModelUser.address = address;
	}
	final String? city = jsonConvert.convert<String>(json['city']);
	if (city != null) {
		logInModelUser.city = city;
	}
	final String? state = jsonConvert.convert<String>(json['state']);
	if (state != null) {
		logInModelUser.state = state;
	}
	final String? createdAt = jsonConvert.convert<String>(json['createdAt']);
	if (createdAt != null) {
		logInModelUser.createdAt = createdAt;
	}
	final List<String>? roles = jsonConvert.convertListNotNull<String>(json['roles']);
	if (roles != null) {
		logInModelUser.roles = roles;
	}
	final List<dynamic>? permits = jsonConvert.convertListNotNull<dynamic>(json['permits']);
	if (permits != null) {
		logInModelUser.permits = permits;
	}
	final List<dynamic>? links = jsonConvert.convertListNotNull<dynamic>(json['links']);
	if (links != null) {
		logInModelUser.links = links;
	}
	return logInModelUser;
}

Map<String, dynamic> $LogInModelUserToJson(LogInModelUser entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['email'] = entity.email;
	data['isEmailVerified'] = entity.isEmailVerified;
	data['phoneNumber'] = entity.phoneNumber;
	data['firstName'] = entity.firstName;
	data['lastName'] = entity.lastName;
	data['isAdmin'] = entity.isAdmin;
	data['isPhoneVerified'] = entity.isPhoneVerified;
	data['isAccountLocked'] = entity.isAccountLocked;
	data['isAccountExpired'] = entity.isAccountExpired;
	data['isCredentialsExpired'] = entity.isCredentialsExpired;
	data['isActive'] = entity.isActive;
	data['isAccountDeleted'] = entity.isAccountDeleted;
	data['referenceCode'] = entity.referenceCode;
	data['pinCreated'] = entity.pinCreated;
	data['isCorporate'] = entity.isCorporate;
	data['gender'] = entity.gender;
	data['middleName'] = entity.middleName;
	data['dateOfBirth'] = entity.dateOfBirth;
	data['profileImage'] = entity.profileImage;
	data['district'] = entity.district;
	data['address'] = entity.address;
	data['city'] = entity.city;
	data['state'] = entity.state;
	data['createdAt'] = entity.createdAt;
	data['roles'] =  entity.roles;
	data['permits'] =  entity.permits;
	data['links'] =  entity.links;
	return data;
}
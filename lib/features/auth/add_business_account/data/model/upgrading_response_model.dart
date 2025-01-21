class User {
  final String id;
  final String phoneNumber;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String address;
  final String city;
  final String lga;
  final String state;
  final String country;
  final String? profilePicture;
  final String fcmToken;
  final bool emailVerified;
  final bool phoneVerified;
  final String accountStatus;
  final String roleId;
  final String accountTypeId;
  final DateTime dateOfBirth;
  final DateTime emailVerifiedDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.phoneNumber,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.address,
    required this.city,
    required this.lga,
    required this.state,
    required this.country,
    this.profilePicture,
    required this.fcmToken,
    required this.emailVerified,
    required this.phoneVerified,
    required this.accountStatus,
    required this.roleId,
    required this.accountTypeId,
    required this.dateOfBirth,
    required this.emailVerifiedDate,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a User object from the JSON response
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      address: json['address'],
      city: json['city'],
      lga: json['lga'],
      state: json['state'],
      country: json['country'],
      profilePicture: json['profilePicture'],
      fcmToken: json['fcmToken'] ?? '',
      emailVerified: json['emailVerified'],
      phoneVerified: json['phoneVerified'],
      accountStatus: json['accountStatus'],
      roleId: json['roleId'],
      accountTypeId: json['accountTypeId'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      emailVerifiedDate: DateTime.parse(json['emailVerifiedDate']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Business {
  final String id;
  final bool isActive;
  final String name;
  final String contactEmail;
  final String contactPhone;
  final String address;
  final String city;
  final String state;
  final String country;
  final String lga;
  final String userId;
  final String businessId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Business({
    required this.id,
    required this.isActive,
    required this.name,
    required this.contactEmail,
    required this.contactPhone,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.lga,
    required this.userId,
    required this.businessId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a Business object from the JSON response
  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'],
      isActive: json['isActive'],
      name: json['name'],
      contactEmail: json['contactEmail'],
      contactPhone: json['contactPhone'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      lga: json['lga'],
      userId: json['userId'],
      businessId: json['businessId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class UpgradingResponseModel {
  final User user;
  final Business business;
  final bool status;
  final String message;
  final int statusCode;

  UpgradingResponseModel({
    required this.user,
    required this.business,
    required this.status,
    required this.message,
    required this.statusCode,
  });

  // Factory method to create the UpgradingResponseModel from the raw JSON response
  factory UpgradingResponseModel.fromJson(Map<String, dynamic> json) {
    return UpgradingResponseModel(
      user: User.fromJson(json['data']['user']),
      business: Business.fromJson(json['data']['business']),
      status: json['status'],
      message: json['message'],
      statusCode: json['statusCode'],
    );
  }
}

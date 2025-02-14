import 'package:wayagram/shared/model/base_model.dart';

class UserDetails extends BaseModel<UserDetails> {
  final String? id;
  final String? phoneNumber;
  final String? email;
  final String? passwordHash;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final dynamic countryCode;
  final dynamic middleName;
  final DateTime? dateOfBirth;
  final bool? twoFactorEnabled;
  final dynamic profilePicture;
  final dynamic fcmToken;
  final bool? emailVerified;
  final bool? phoneVerified;
  final String? accountStatus;
  final bool? tcAgreement;
  final bool? policyAgreement;
  final DateTime? emailVerifiedDate;
  final dynamic deletedAt;
  final String? roleId;
  final String? accountTypeId;
  final String? lga;
  final String? v;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserRole? role;

  UserDetails({
    required this.id,
    required this.phoneNumber,
    required this.email,
    required this.passwordHash,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.countryCode,
    required this.middleName,
    required this.dateOfBirth,
    required this.twoFactorEnabled,
    required this.profilePicture,
    required this.fcmToken,
    required this.emailVerified,
    required this.phoneVerified,
    required this.accountStatus,
    required this.tcAgreement,
    required this.policyAgreement,
    required this.emailVerifiedDate,
    required this.deletedAt,
    required this.roleId,
    required this.accountTypeId,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.lga,
  });

  String get fullname => "$firstName $lastName";

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      passwordHash: json['passwordHash'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      countryCode: json['countryCode'],
      middleName: json['middleName'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      twoFactorEnabled: json['twoFactorEnabled'],
      profilePicture: json['profilePicture'],
      fcmToken: json['fcmToken'],
      emailVerified: json['emailVerified'],
      phoneVerified: json['phoneVerified'],
      accountStatus: json['accountStatus'],
      tcAgreement: json['tcAgreement'],
      policyAgreement: json['policyAgreement'],
      emailVerifiedDate: json['emailVerifiedDate'] != null
          ? DateTime.parse(json['emailVerifiedDate'])
          : null,
      deletedAt: json['deletedAt'],
      roleId: json['roleId'],
      accountTypeId: json['accountTypeId'],
      lga: json['lga'],
      v: json['_v'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      role: json['role'] != null ? UserRole.fromJson(json['role']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'email': email,
      'passwordHash': passwordHash,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'countryCode': countryCode,
      'middleName': middleName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'twoFactorEnabled': twoFactorEnabled,
      'profilePicture': profilePicture,
      'fcmToken': fcmToken,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'accountStatus': accountStatus,
      'tcAgreement': tcAgreement,
      'policyAgreement': policyAgreement,
      'emailVerifiedDate': emailVerifiedDate?.toIso8601String(),
      'deletedAt': deletedAt,
      'roleId': roleId,
      'accountTypeId': accountTypeId,
      'lga': lga,
      '_v': v,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'role': role?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      };
}

class UserRole {
  final String? id;
  final String? name;

  UserRole({required this.id, required this.name});

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

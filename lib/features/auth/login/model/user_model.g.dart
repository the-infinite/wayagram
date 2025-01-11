// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      message: json['message'] as String?,
      status: json['status'] as bool?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : UserModelData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'statusCode': instance.statusCode,
      'data': instance.data,
    };

UserModelData _$UserModelDataFromJson(Map<String, dynamic> json) =>
    UserModelData(
      userdata: json['userdata'] == null
          ? null
          : Userdata.fromJson(json['userdata'] as Map<String, dynamic>),
      token: json['token'] == null
          ? null
          : Token.fromJson(json['token'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelDataToJson(UserModelData instance) =>
    <String, dynamic>{
      'userdata': instance.userdata,
      'token': instance.token,
    };

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };

Userdata _$UserdataFromJson(Map<String, dynamic> json) => Userdata(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      profile: json['profile'] == null
          ? null
          : Profile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserdataToJson(Userdata instance) => <String, dynamic>{
      'user': instance.user,
      'profile': instance.profile,
    };

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      avatar: json['avatar'],
      coverImage: json['coverImage'],
      bio: json['bio'],
      username: json['username'] as String?,
      displayName: json['displayName'] as String?,
      isPublic: json['isPublic'] as bool?,
      isBanned: json['isBanned'] as bool?,
      deletedAt: json['deletedAt'],
      simulatedUser: json['simulatedUser'] as bool?,
      isMuted: json['isMuted'] as bool?,
      referenceCode: json['referenceCode'] as String?,
      referredBy: json['referredBy'],
      streamKey: json['streamKey'] as String?,
      hasFollowedAll: json['hasFollowedAll'] as bool?,
      v: json['_v'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'avatar': instance.avatar,
      'coverImage': instance.coverImage,
      'bio': instance.bio,
      'username': instance.username,
      'displayName': instance.displayName,
      'isPublic': instance.isPublic,
      'isBanned': instance.isBanned,
      'deletedAt': instance.deletedAt,
      'simulatedUser': instance.simulatedUser,
      'isMuted': instance.isMuted,
      'referenceCode': instance.referenceCode,
      'referredBy': instance.referredBy,
      'streamKey': instance.streamKey,
      'hasFollowedAll': instance.hasFollowedAll,
      '_v': instance.v,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
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
 
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
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
      
    };



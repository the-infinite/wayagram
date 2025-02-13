

class PostReponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final Data data;

  PostReponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory PostReponseModel.fromJson(Map<String, dynamic> json) {
    return PostReponseModel(
      message: json['message'],
      status: json['status'],
      statusCode: json['statusCode'],
      data: Data.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusCode': statusCode,
      'data': data.toJson(),
    };
  }
}

class Data {
  final List<Post> docs;
  final int totalDocs;
  final int limit;
  final int page;
  final int totalPages;
  final bool hasNextPage;
  final int? nextPage;
  final bool hasPrevPage;
  final int? prevPage;
  final int pagingCounter;

  Data({required this.docs,  required this.totalDocs,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.hasNextPage,
    this.nextPage,
    required this.hasPrevPage,
    this.prevPage,
    required this.pagingCounter,});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      docs: (json['docs'] as List).map((e) => Post.fromJson(e)).toList(),
        totalDocs: json["totalDocs"],
      limit: json["limit"],
      page: json["page"],
      totalPages: json["totalPages"],
      hasNextPage: json["hasNextPage"],
      nextPage: json["nextPage"],
      hasPrevPage: json["hasPrevPage"],
      prevPage: json["prevPage"],
      pagingCounter: json["pagingCounter"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docs': docs.map((e) => e.toJson()).toList(),
    };
  }
}

class Post {
  final String id;
  final String userId;
  final List<dynamic>? categories;
  final String? groupId;
  final String? pageId;
  final String contentType;
  final String content;
  final List<String> media;
  final List<String> hashtags;
  final String sourceType;
  final String? linkedServiceId;
  final String privacy;
  final String? url;
  final String status;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final double popularityScore;
  final bool isPromoted;
  final bool isReposted;
  final String? promotionExpiry;
  final String? deletedAt;
  final String? originalPostId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;

  Post({
    required this.id,
    required this.userId,
    this.categories,
    this.groupId,
    this.pageId,
    required this.contentType,
    required this.content,
    required this.media,
    required this.hashtags,
    required this.sourceType,
    this.linkedServiceId,
    required this.privacy,
    this.url,
    required this.status,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.popularityScore,
    required this.isPromoted,
    required this.isReposted,
    this.promotionExpiry,
    this.deletedAt,
    this.originalPostId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      categories: json['categories'],
      groupId: json['groupId'],
      pageId: json['pageId'],
      contentType: json['contentType'],
      content: json['content'],
      media: List<String>.from(json['media']),
      hashtags: List<String>.from(json['hashtags']),
      sourceType: json['sourceType'],
      linkedServiceId: json['linkedServiceId'],
      privacy: json['privacy'],
      url: json['url'],
      status: json['status'],
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      shareCount: json['shareCount'],
      popularityScore: (json['popularityScore'] as num).toDouble(),
      isPromoted: json['isPromoted'],
      isReposted: json['isReposted'],
      promotionExpiry: json['promotionExpiry'],
      deletedAt: json['deletedAt'],
      originalPostId: json['originalPostId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'categories': categories,
      'groupId': groupId,
      'pageId': pageId,
      'contentType': contentType,
      'content': content,
      'media': media,
      'hashtags': hashtags,
      'sourceType': sourceType,
      'linkedServiceId': linkedServiceId,
      'privacy': privacy,
      'url': url,
      'status': status,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'popularityScore': popularityScore,
      'isPromoted': isPromoted,
      'isReposted': isReposted,
      'promotionExpiry': promotionExpiry,
      'deletedAt': deletedAt,
      'originalPostId': originalPostId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'user': user.toJson(),
    };
  }
}

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
  final String? countryCode;
  final String? postalCode;
  final String? middleName;
  final DateTime dateOfBirth;
  final bool twoFactorEnabled;
  final String? profilePicture;
  final String? fcmToken;
  final bool emailVerified;
  final bool phoneVerified;
  final String accountStatus;
  final bool tcAgreement;
  final bool policyAgreement;
  final DateTime emailVerifiedDate;
  final String? deletedAt;
  final String roleId;
  final String accountTypeId;
  final String role;

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
    this.countryCode,
    this.postalCode,
    this.middleName,
    required this.dateOfBirth,
    required this.twoFactorEnabled,
    this.profilePicture,
    this.fcmToken,
    required this.emailVerified,
    required this.phoneVerified,
    required this.accountStatus,
    required this.tcAgreement,
    required this.policyAgreement,
    required this.emailVerifiedDate,
    this.deletedAt,
    required this.roleId,
    required this.accountTypeId,
    required this.role,
  });

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
      countryCode: json['countryCode'],
      postalCode: json['postalCode'],
      middleName: json['middleName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      twoFactorEnabled: json['twoFactorEnabled'],
      profilePicture: json['profilePicture'],
      fcmToken: json['fcmToken'],
      emailVerified: json['emailVerified'],
      phoneVerified: json['phoneVerified'],
      accountStatus: json['accountStatus'],
      tcAgreement: json['tcAgreement'],
      policyAgreement: json['policyAgreement'],
      emailVerifiedDate: DateTime.parse(json['emailVerifiedDate']),
      deletedAt: json['deletedAt'],
      roleId: json['roleId'],
      accountTypeId: json['accountTypeId'],
      role: json['role']['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'address': address,
      'city': city,
      'lga': lga,
      'state': state,
      'country': country,
      'countryCode': countryCode,
      'postalCode': postalCode,
      'middleName': middleName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'twoFactorEnabled': twoFactorEnabled,
      'profilePicture': profilePicture,
      'fcmToken': fcmToken,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'accountStatus': accountStatus,
      'tcAgreement': tcAgreement,
      'policyAgreement': policyAgreement,
      'emailVerifiedDate': emailVerifiedDate.toIso8601String(),
      'deletedAt': deletedAt,
      'roleId': roleId,
      'accountTypeId': accountTypeId,
      'role': role,
    };
  }
}

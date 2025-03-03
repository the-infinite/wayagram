import 'dart:convert';
KycModel kycModelFromJson(String str) => KycModel.fromJson(json.decode(str));
String kycModelToJson(KycModel data) => json.encode(data.toJson());
class KycModel {
  KycModel({
      this.message,
      this.status, 
      this.statusCode, 
      this.data, 
      this.responseCode,});

  KycModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? KYCModelData.fromJson(json['data']) : null;
    responseCode = json['responseCode'];
  }
  String? message;
  bool? status;
  num? statusCode;
  KYCModelData? data;
  num? responseCode;
KycModel copyWith({  String? message,
  bool? status,
  num? statusCode,
  KYCModelData? data,
  num? responseCode,
}) => KycModel(  message: message ?? this.message,
  status: status ?? this.status,
  statusCode: statusCode ?? this.statusCode,
  data: data ?? this.data,
  responseCode: responseCode ?? this.responseCode,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['status'] = status;
    map['statusCode'] = statusCode;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['responseCode'] = responseCode;
    return map;
  }

}

KYCModelData dataFromJson(String str) => KYCModelData.fromJson(json.decode(str));
String dataToJson(KYCModelData data) => json.encode(data.toJson());
class KYCModelData {
  KYCModelData({
      this.id, 
      this.businessId, 
      this.businessAddress, 
      this.businessName, 
      this.cacDocument, 
      this.cacNumber, 
      this.nin, 
      this.passport, 
      this.utilityBill, 
      this.status, 
      this.reasons, 
      this.verifiedAt, 
      this.createdAt, 
      this.updatedAt, 
      this.business,});

  KYCModelData.fromJson(dynamic json) {
    id = json['id'];
    businessId = json['businessId'];
    businessAddress = json['businessAddress'];
    businessName = json['businessName'];
    cacDocument = json['cacDocument'];
    cacNumber = json['cacNumber'];
    nin = json['nin'];
    passport = json['passport'];
    utilityBill = json['utilityBill'];
    status = json['status'];
    reasons = json['reasons'];
    verifiedAt = json['verifiedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    business = json['business'] != null ? Business.fromJson(json['business']) : null;
  }
  String? id;
  String? businessId;
  String? businessAddress;
  String? businessName;
  String? cacDocument;
  String? cacNumber;
  String? nin;
  String? passport;
  String? utilityBill;
  String? status;
  dynamic reasons;
  dynamic verifiedAt;
  String? createdAt;
  String? updatedAt;
  Business? business;
  KYCModelData copyWith({  String? id,
  String? businessId,
  String? businessAddress,
  String? businessName,
  String? cacDocument,
  String? cacNumber,
  String? nin,
  String? passport,
  String? utilityBill,
  String? status,
  dynamic reasons,
  dynamic verifiedAt,
  String? createdAt,
  String? updatedAt,
  Business? business,
}) => KYCModelData(  id: id ?? this.id,
  businessId: businessId ?? this.businessId,
  businessAddress: businessAddress ?? this.businessAddress,
  businessName: businessName ?? this.businessName,
  cacDocument: cacDocument ?? this.cacDocument,
  cacNumber: cacNumber ?? this.cacNumber,
  nin: nin ?? this.nin,
  passport: passport ?? this.passport,
  utilityBill: utilityBill ?? this.utilityBill,
  status: status ?? this.status,
  reasons: reasons ?? this.reasons,
  verifiedAt: verifiedAt ?? this.verifiedAt,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  business: business ?? this.business,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['businessId'] = businessId;
    map['businessAddress'] = businessAddress;
    map['businessName'] = businessName;
    map['cacDocument'] = cacDocument;
    map['cacNumber'] = cacNumber;
    map['nin'] = nin;
    map['passport'] = passport;
    map['utilityBill'] = utilityBill;
    map['status'] = status;
    map['reasons'] = reasons;
    map['verifiedAt'] = verifiedAt;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    if (business != null) {
      map['business'] = business?.toJson();
    }
    return map;
  }

}

Business businessFromJson(String str) => Business.fromJson(json.decode(str));
String businessToJson(Business data) => json.encode(data.toJson());
class Business {
  Business({
      this.id, 
      this.userId, 
      this.name, 
      this.businessTypeId, 
      this.contactEmail, 
      this.contactPhone, 
      this.description, 
      this.logoUrl, 
      this.businessId, 
      this.websiteUrl, 
      this.address, 
      this.city, 
      this.lga, 
      this.state, 
      this.country, 
      this.isActive, 
      this.verifiedAt, 
      this.deletedAt, 
      this.v, 
      this.createdAt, 
      this.updatedAt,});

  Business.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    businessTypeId = json['businessTypeId'];
    contactEmail = json['contactEmail'];
    contactPhone = json['contactPhone'];
    description = json['description'];
    logoUrl = json['logoUrl'];
    businessId = json['businessId'];
    websiteUrl = json['websiteUrl'];
    address = json['address'];
    city = json['city'];
    lga = json['lga'];
    state = json['state'];
    country = json['country'];
    isActive = json['isActive'];
    verifiedAt = json['verifiedAt'];
    deletedAt = json['deletedAt'];
    v = json['_v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? userId;
  String? name;
  String? businessTypeId;
  dynamic contactEmail;
  dynamic contactPhone;
  dynamic description;
  dynamic logoUrl;
  String? businessId;
  dynamic websiteUrl;
  String? address;
  String? city;
  String? lga;
  String? state;
  String? country;
  bool? isActive;
  dynamic verifiedAt;
  dynamic deletedAt;
  String? v;
  String? createdAt;
  String? updatedAt;
Business copyWith({  String? id,
  String? userId,
  String? name,
  String? businessTypeId,
  dynamic contactEmail,
  dynamic contactPhone,
  dynamic description,
  dynamic logoUrl,
  String? businessId,
  dynamic websiteUrl,
  String? address,
  String? city,
  String? lga,
  String? state,
  String? country,
  bool? isActive,
  dynamic verifiedAt,
  dynamic deletedAt,
  String? v,
  String? createdAt,
  String? updatedAt,
}) => Business(  id: id ?? this.id,
  userId: userId ?? this.userId,
  name: name ?? this.name,
  businessTypeId: businessTypeId ?? this.businessTypeId,
  contactEmail: contactEmail ?? this.contactEmail,
  contactPhone: contactPhone ?? this.contactPhone,
  description: description ?? this.description,
  logoUrl: logoUrl ?? this.logoUrl,
  businessId: businessId ?? this.businessId,
  websiteUrl: websiteUrl ?? this.websiteUrl,
  address: address ?? this.address,
  city: city ?? this.city,
  lga: lga ?? this.lga,
  state: state ?? this.state,
  country: country ?? this.country,
  isActive: isActive ?? this.isActive,
  verifiedAt: verifiedAt ?? this.verifiedAt,
  deletedAt: deletedAt ?? this.deletedAt,
  v: v ?? this.v,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['name'] = name;
    map['businessTypeId'] = businessTypeId;
    map['contactEmail'] = contactEmail;
    map['contactPhone'] = contactPhone;
    map['description'] = description;
    map['logoUrl'] = logoUrl;
    map['businessId'] = businessId;
    map['websiteUrl'] = websiteUrl;
    map['address'] = address;
    map['city'] = city;
    map['lga'] = lga;
    map['state'] = state;
    map['country'] = country;
    map['isActive'] = isActive;
    map['verifiedAt'] = verifiedAt;
    map['deletedAt'] = deletedAt;
    map['_v'] = v;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}
import 'package:json_annotation/json_annotation.dart';

class ShopResponseModel {
  final String message;
  final bool status;
  final int statusCode;
  final Data data;

  ShopResponseModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  factory ShopResponseModel.fromJson(Map<String, dynamic> json) {
    return ShopResponseModel(
      message: json["message"],
      status: json["status"],
      statusCode: json["statusCode"],
      data: Data.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "status": status,
      "statusCode": statusCode,
      "data": data
    };
  }
}

class Data {
  final String message;
  final List<ShopData> shops;

  Data({required this.message, required this.shops});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      message: json["message"] ?? "",
      shops: (json["shops"] != null)
          ? List<ShopData>.from(json["shops"].map((x) => ShopData.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {"message": message, "shops": shops};
  }
}

class ShopData {
  final String id;
  final String vendorId;
  final String name;
  final String description;
  final bool deactivated;
  final dynamic logo;
  final dynamic coverImage;
  final String address;
  final String state;
  final String lga;
  final String phone;
  final String email;
  final dynamic rating;
  final int totalOrders;
  final dynamic socialLinks;
  final dynamic businessHours;
  @JsonKey(name: '_v')
  final String? v;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShopData({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.description,
    required this.deactivated,
    required this.logo,
    this.coverImage,
    required this.address,
    required this.phone,
    required this.email,
    this.rating,
    required this.totalOrders,
    this.socialLinks,
    this.businessHours,
    required this.state,
    required this.lga,
    required this.v,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShopData.fromJson(Map<String, dynamic> json) {
    return ShopData(
      id: json["id"],
      vendorId: json["vendorId"],
      name: json["name"],
      description: json["description"],
      deactivated: json["deactivated"],
      logo: json["logo"],
      coverImage: json["coverImage"],
      address: json["address"],
      phone: json["phone"],
      email: json["email"],
      rating: json["rating"],
      totalOrders: json["totalOrders"],
      socialLinks: json["socialLinks"],
      businessHours: json["businessHours"],
      state: json['state'],
      lga: json['lga'],
      v: json["_v"] ?? "",
      isDeleted: json["isDeleted"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "vendorId": vendorId,
      "name": name,
      "description": description,
      "deactivated": deactivated,
      "logo": logo,
      "coverImage": coverImage,
      "address": address,
      "phone": phone,
      "email": email,
      "rating": rating,
      "totalOrders": totalOrders,
      "socialLinks": socialLinks,
      "businessHours": businessHours,
      "state": state,
      "lga":lga,
      "_v": v,
      "isDeleted": isDeleted,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}

import 'package:json_annotation/json_annotation.dart';

part 'shop_setting_response.g.dart';

@JsonSerializable()
class ShopSettingsModel {
    ShopSettingsModel({
        required this.message,
        required this.status,
        required this.statusCode,
        required this.data,
    });

    final String? message;
    final bool? status;
    final int? statusCode;
    final Data? data;

    factory ShopSettingsModel.fromJson(Map<String, dynamic> json) => _$ShopSettingsModelFromJson(json);

    Map<String, dynamic> toJson() => _$ShopSettingsModelToJson(this);

}

@JsonSerializable()
class Data {
    Data({
        required this.id,
        required this.userId,
        required this.avatar,
        required this.coverImage,
        required this.bio,
        required this.username,
        required this.displayName,
        required this.receiveQuotationRequests,
        required this.makeRequestsPublic,
        required this.displayQuotationRequestsInFeed,
        required this.notifyFriendsAboutProductPosts,
        required this.makeProductPostsPublic,
        required this.createdAt,
        required this.updatedAt,
    });

    final String? id;
    final String? userId;
    final String? avatar;
    final String? coverImage;
    final String? bio;
    final String? username;
    final String? displayName;
    final bool? receiveQuotationRequests;
    final bool? makeRequestsPublic;
    final bool? displayQuotationRequestsInFeed;
    final bool? notifyFriendsAboutProductPosts;
    final bool? makeProductPostsPublic;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

    Map<String, dynamic> toJson() => _$DataToJson(this);

}

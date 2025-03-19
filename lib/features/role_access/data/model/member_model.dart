import 'package:json_annotation/json_annotation.dart';

part 'member_model.g.dart';

@JsonSerializable()
class MemberModelBase {
  MemberModelBase({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final List<MemberModel>? data;

  factory MemberModelBase.fromJson(Map<String, dynamic> json) =>
      _$MemberModelBaseFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelBaseToJson(this);
}

@JsonSerializable()
class MemberModel {
  MemberModel({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.roles,
    required this.email,
    required this.isActive,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? userId;
  final String? shopId;
  final List<String>? roles;
  final String? email;
  final bool? isActive;

  @JsonKey(name: '_v')
  final String? v;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);
}

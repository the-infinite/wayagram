import 'package:json_annotation/json_annotation.dart';

part 'role_management_model.g.dart';

@JsonSerializable()
class RoleManagementModelBase {
  RoleManagementModelBase({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final Data? data;

  factory RoleManagementModelBase.fromJson(Map<String, dynamic> json) =>
      _$RoleManagementModelBaseFromJson(json);

  Map<String, dynamic> toJson() => _$RoleManagementModelBaseToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    required this.totalRoles,
    required this.roles,
  });

  final int? totalRoles;
  final List<RoleManagementModel>? roles;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class RoleManagementModel {
  RoleManagementModel({
    required this.roleId,
    required this.roleName,
    required this.description,
    required this.userCount,
  });

  final String? roleId;
  final String? roleName;
  final String? description;
  final int? userCount;

  factory RoleManagementModel.fromJson(Map<String, dynamic> json) =>
      _$RoleManagementModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoleManagementModelToJson(this);
}

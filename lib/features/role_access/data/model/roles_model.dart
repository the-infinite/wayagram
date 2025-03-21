import 'package:json_annotation/json_annotation.dart';

part 'roles_model.g.dart';

@JsonSerializable()
class RolesModelBase {
  RolesModelBase({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final List<RolesModel>? data;

  factory RolesModelBase.fromJson(Map<String, dynamic> json) =>
      _$RolesModelBaseFromJson(json);

  Map<String, dynamic> toJson() => _$RolesModelBaseToJson(this);
}

@JsonSerializable()
class RolesModel {
  RolesModel({
    required this.roleId,
    required this.name,
    required this.description,
    required this.permissionsWithActions,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? roleId;
  final String? name;
  final String? description;
  final List<PermissionsWithAction>? permissionsWithActions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory RolesModel.fromJson(Map<String, dynamic> json) =>
      _$RolesModelFromJson(json);

  Map<String, dynamic> toJson() => _$RolesModelToJson(this);
}

@JsonSerializable()
class PermissionsWithAction {
  PermissionsWithAction({
    required this.actions,
    required this.permissionId,
  });

  final List<String>? actions;
  final String? permissionId;

  factory PermissionsWithAction.fromJson(Map<String, dynamic> json) =>
      _$PermissionsWithActionFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionsWithActionToJson(this);
}

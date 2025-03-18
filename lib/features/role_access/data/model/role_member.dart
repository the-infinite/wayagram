import 'package:json_annotation/json_annotation.dart';

part 'role_member.g.dart';

@JsonSerializable()
class ShopMemberBase {
  ShopMemberBase({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.data,
  });

  final String? message;
  final bool? status;
  final int? statusCode;
  final Data? data;

  factory ShopMemberBase.fromJson(Map<String, dynamic> json) =>
      _$ShopMemberBaseFromJson(json);

  Map<String, dynamic> toJson() => _$ShopMemberBaseToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.hasNextPage,
    required this.nextPage,
    required this.hasPrevPage,
    required this.prevPage,
    required this.pagingCounter,
    required this.metadata,
  });

  final List<ShopMember>? docs;
  final int? totalDocs;
  final int? limit;
  final int? page;
  final int? totalPages;
  final bool? hasNextPage;
  final int? nextPage;
  final bool? hasPrevPage;
  final int? prevPage;
  final int? pagingCounter;
  final Metadata? metadata;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class ShopMember {
  ShopMember({
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
  final List<Role>? roles;
  final String? email;
  final bool? isActive;

  @JsonKey(name: '_v')
  final String? v;
  final String? createdAt;
  final String? updatedAt;

  factory ShopMember.fromJson(Map<String, dynamic> json) =>
      _$ShopMemberFromJson(json);

  Map<String, dynamic> toJson() => _$ShopMemberToJson(this);
}

@JsonSerializable()
class Role {
  Role({
    required this.roleId,
    required this.roleName,
    required this.description,
    required this.permissionsWithActions,
  });

  final String? roleId;
  final String? roleName;
  final String? description;
  final List<PermissionsWithAction>? permissionsWithActions;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  Map<String, dynamic> toJson() => _$RoleToJson(this);
}

@JsonSerializable()
class PermissionsWithAction {
  PermissionsWithAction({
    required this.permissionId,
    required this.permissionScreen,
    required this.actions,
  });

  final String? permissionId;
  final String? permissionScreen;
  final List<Action>? actions;

  factory PermissionsWithAction.fromJson(Map<String, dynamic> json) =>
      _$PermissionsWithActionFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionsWithActionToJson(this);
}

@JsonSerializable()
class Action {
  Action({
    required this.actionId,
    required this.actionName,
  });

  final String? actionId;
  final String? actionName;

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  Map<String, dynamic> toJson() => _$ActionToJson(this);
}

@JsonSerializable()
class Metadata {
  Metadata({
    required this.offset,
    required this.searchApplied,
    required this.searchFields,
    required this.appliedFilters,
  });

  final int? offset;
  final bool? searchApplied;
  final List<dynamic>? searchFields;
  final AppliedFilters? appliedFilters;

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}

@JsonSerializable()
class AppliedFilters {
  AppliedFilters({
    required this.shopId,
  });

  final String? shopId;

  factory AppliedFilters.fromJson(Map<String, dynamic> json) =>
      _$AppliedFiltersFromJson(json);

  Map<String, dynamic> toJson() => _$AppliedFiltersToJson(this);
}

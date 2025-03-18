import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/role_access/data/model/role_management_model.dart';
import 'package:wayagram/features/role_access/data/model/role_member.dart';
import 'package:wayagram/features/role_access/data/model/roles_model.dart';
import 'package:wayagram/features/role_access/data/model/shop_model.dart';

class RoleAccessState {
  final int? revenueGenerated;
  final bool? isLoading;
  final List<RolesModel> listRoleModel;
  final List<Select> listSelect;
  final List<Select> listShop;
  final List<ShopModel> originalListShop;
  final List<ShopMember> listMember;
  final List<RoleManagementModel> listRoleManagement;

  RoleAccessState({
    this.revenueGenerated = 0,
    this.isLoading = false,
    this.listRoleModel = const [],
    this.listSelect = const [],
    this.listShop = const [],
    this.originalListShop = const [],
    this.listMember = const [],
    this.listRoleManagement = const [],
  });

  RoleAccessState copyWith({
    int? revenueGenerated,
    bool? isLoading,
    List<RolesModel>? listRoleModel,
    List<Select>? listSelect,
    List<Select>? listShop,
    List<ShopModel>? originalListShop,
    List<ShopMember>? listMember,
    List<RoleManagementModel>? listRoleManagement,
  }) =>
      RoleAccessState(
        revenueGenerated: revenueGenerated ?? this.revenueGenerated,
        listRoleModel: listRoleModel ?? this.listRoleModel,
        listSelect: listSelect ?? this.listSelect,
        listShop: listShop ?? this.listShop,
        originalListShop: originalListShop ?? this.originalListShop,
        listMember: listMember ?? this.listMember,
        isLoading: isLoading ?? this.isLoading,
        listRoleManagement: listRoleManagement ?? this.listRoleManagement,
      );
}

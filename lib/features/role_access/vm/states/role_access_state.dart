import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/role_access/data/model/roles_model.dart';

class RoleAccessState {
  final int? revenueGenerated;
  final List<RolesModel> listRoleModel;
  final List<Select> listSelect;
  final List<Select> listShop;

  RoleAccessState({
    this.revenueGenerated = 0,
    this.listRoleModel = const [],
    this.listSelect = const [],
    this.listShop = const [],
  });

  RoleAccessState copyWith({
    int? revenueGenerated,
    List<RolesModel>? listRoleModel,
    List<Select>? listSelect,
    List<Select>? listShop,
  }) =>
      RoleAccessState(
        revenueGenerated: revenueGenerated ?? this.revenueGenerated,
        listRoleModel: listRoleModel ?? this.listRoleModel,
        listSelect: listSelect ?? this.listSelect,
        listShop: listShop ?? this.listShop,
      );
}

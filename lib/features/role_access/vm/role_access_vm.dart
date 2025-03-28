import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/features/role_access/data/model/role_management_model.dart';
import 'package:wayagram/features/role_access/data/model/role_member.dart';
import 'package:wayagram/features/role_access/data/model/roles_model.dart';
import 'package:wayagram/features/role_access/data/model/shop_model.dart';
import 'package:wayagram/features/role_access/data/role_access_repo.dart';

import 'package:wayagram/features/role_access/vm/states/role_access_state.dart';
import '../../../core/data/local_data_source.dart';

class RoleAccessVm extends StateNotifier<RoleAccessState> {
  final RoleAccessRepo _roleAccessRepository;
  final WayaLocalDataSource _localDataSource;
//this is ok
// controllers
  late TextEditingController firstName;
  late TextEditingController lastName;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController confirmPassword;
  // final _logger = getLogger('ContestRepo');

  RoleAccessVm(this._roleAccessRepository, this._localDataSource)
      : super(RoleAccessState()) {
    getRoles();
    firstName = TextEditingController();
    lastName = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
  }

  Future<void> getRoles() async {
    final response = await _roleAccessRepository.getRoles();
    if (response.success == true) {
      RolesModelBase responseModel = RolesModelBase.fromJson(response.data);
      state = state.copyWith(listRoleModel: responseModel.data);
      state = state.copyWith(listSelect: getRolesSelect());

      // contestList = responseModel.data?.docs ?? [];
    } else {
      //state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getShops() async {
    final response = await _roleAccessRepository
        .getShopByUserId(_localDataSource.getUserId().toString());
    if (response.success == true) {
      ShopModelBase responseModel = ShopModelBase.fromJson(response.data);

      state = state.copyWith(
          originalListShop: responseModel.data?.shops ?? [],
          listShop: getShopsSelect(responseModel.data?.shops ?? []));

      // contestList = responseModel.data?.docs ?? [];
    } else {
      //state = state.copyWith(isLoading: false);
    }
  }

  void addTeamMember(
    // BuildContext context,
    ValueNotifier<bool> isLoading,
    String shopId,
    String roleId,
    String memberId,
    bool isEditing,
    VoidCallback onTap,
  ) async {
    isLoading.value = true;
    var map = {
      // "userId": _localDataSource.getUserId().toString(),
      "email": email.text,
      "shopId": shopId,
      // "username": "ChimuOs",
      "roles": [roleId]
    };
    print(map);
    WayaRequestResponse response;
    if (isEditing) {
      response = await _roleAccessRepository.editMember(memberId, map);
    } else {
      response = await _roleAccessRepository.addTeamMember(map);
    }
    isLoading.value = false;

    if (response.success) {
      onTap();
      WayaSnackBar.showToast("Team Member added", showSuccess: true);
      getAllMembers(true);
    } else {
      WayaSnackBar.showToast("Unable to add member, please try again later");
    }
  }

  Future<void> getAllMembers(bool isFirst) async {
    if (isFirst) {
      state = state.copyWith(page: 1);
    }
    if (state.isLastPage && isFirst == false) {
      return;
    }
    if (state.isLoading == true) {
      return;
    }
    try {
      state = state.copyWith(isLoading: true);
      final response = await _roleAccessRepository.getMemberList(
          _localDataSource.getUserId().toString(), state.page);
      state = state.copyWith(isLoading: false);
      if (response.success == true) {
        ShopMemberBase responseModel = ShopMemberBase.fromJson(response.data);
        state = state.copyWith(
            isLastPage: responseModel.data?.hasNextPage == true ? false : true);
        if (isFirst) {
          state = state.copyWith(listMember: responseModel.data?.docs ?? []);
        } else {
          state = state.copyWith(listMember: [
            ...state.listMember,
            ...responseModel.data?.docs ?? []
          ]);
        }
        state = state.copyWith(page: state.page + 1);
        // contestList = responseModel.data?.docs ?? [];
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print(e);
    } finally {}
  }

  Future<void> getRoleManagementMemberList() async {
    state = state.copyWith(isLoading: true);
    final response = await _roleAccessRepository
        .getRoleManagementMemberList(_localDataSource.getUserId().toString());
    state = state.copyWith(isLoading: false);
    if (response.success == true) {
      RoleManagementModelBase responseModel =
          RoleManagementModelBase.fromJson(response.data);

      state =
          state.copyWith(listRoleManagement: responseModel.data?.roles ?? []);

      // contestList = responseModel.data?.docs ?? [];
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  List<Select> getRolesSelect() {
    return state.listRoleModel.asMap().entries.map((entries) {
      return Select(
          value: entries.value.roleId.toString(),
          label: entries.value.name ?? "id");
    }).toList();
  }

  List<Select> getShopsSelect(List<ShopModel> list) {
    return list.asMap().entries.map((entries) {
      return Select(
          value: entries.value.id.toString(),
          label: entries.value.name ?? "id");
    }).toList();
  }

  Future<bool> activateDeactivateShopMember(ValueNotifier<bool> isLoading,
      String shopMemberId, bool isActive, VoidCallback onTap) async {
    final response = await _roleAccessRepository
        .activateDeactivateShopMember(shopMemberId, {"isActive": !isActive});
    isLoading.value = false;
    getAllMembers(true);
    if (response.success) {
      onTap();
      WayaSnackBar.showToast("Member Status Updated", showSuccess: true);
      return true;
    } else {
      WayaSnackBar.showToast(
        "Please try again later unable to update status",
      );
      return false;
    }
  }
}

final selectedRoleMemberProvider = StateProvider<ShopMember?>((ref) {
  return null;
});

final editingRoleMemberProvider = StateProvider<bool>((ref) {
  return false;
});

final roleAccessVm = StateNotifierProvider<RoleAccessVm, RoleAccessState>(
  (ref) {
    return RoleAccessVm(RoleAccessRepo(), WayaLocalDataSource());
  },
);

final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

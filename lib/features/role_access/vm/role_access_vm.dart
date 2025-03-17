import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/role_access/data/model/roles_model.dart';
import 'package:wayagram/features/role_access/data/model/shop_model.dart';
import 'package:wayagram/features/role_access/data/role_access_repo.dart';

import 'package:wayagram/features/role_access/vm/states/role_access_state.dart';
import 'package:wayagram/features/ugt/data/repository/ContestRepo.dart';
import 'package:wayagram/features/wallet/data/repo/wallet_repository.dart';
import '../../../core/data/local_data_source.dart';

class RoleAccessVm extends StateNotifier<RoleAccessState> {
  final RoleAccessRepo _roleAccessRepository;
  final WayaLocalDataSource _localDataSource;

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
    final response = await _roleAccessRepository.addTeamMember(map);
    isLoading.value = false;

    if (response.success) {
      onTap();
      WayaSnackBar.showToast("Team Member added", showSuccess: true);
    } else {
      WayaSnackBar.showToast("Unable to add member, please try again later");
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
}

final roleAccessVm = StateNotifierProvider<RoleAccessVm, RoleAccessState>(
  (ref) {
    return RoleAccessVm(RoleAccessRepo(), WayaLocalDataSource());
  },
);

final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

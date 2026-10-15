import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/utils/waya_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/service/repos/base_repository_riverpod.dart';

part 'role_access_repo.g.dart';

class RoleAccessRepo extends BaseRepositoryRiverpod {
  static const serviceUrl2 = WayaServiceUri.shop;
  static const serviceUrl1 = WayaServiceUri.contest;

  RoleAccessRepo(super.ref);

  Future<WayaRequestResponse> getRoles() {
    return get('$serviceUrl2/admin/role/get-roles');
  }

  Future<WayaRequestResponse> getContestRoles() {
    return get('$serviceUrl1/admin/role/get-roles');
  }

  Future<WayaRequestResponse> addContestTeamMember(
      Map<String, dynamic>? payLoad) {
    return post('$serviceUrl1/judges/create', payLoad, formdata: false);
  }

  Future<WayaRequestResponse> editContestTeamMember(
      String judgeId, Map<String, dynamic>? payLoad) {
    return patch('$serviceUrl1/judges/update/$judgeId', payLoad,
        formdata: false);
  }

  Future<WayaRequestResponse> getShopByUserId(String userId) {
    return get('$serviceUrl2/shops/$userId');
  }

  Future<WayaRequestResponse> getMemberList(String vendorId, int page) {
    return get('$serviceUrl2/shopMember/get-members/$vendorId?page=$page');
  }

  Future<WayaRequestResponse> getAllJudgeList(String userId, int page) {
    return get('$serviceUrl1/judges/$userId?page=$page');
  }

  Future<WayaRequestResponse> getRoleManagementMemberList(String vendorId) {
    return get('$serviceUrl2/shopMember/role-management/$vendorId');
  }

  Future<WayaRequestResponse> addTeamMember(Map<String, dynamic>? payLoad) {
    return post('$serviceUrl2/shopMember/create', payLoad, formdata: false);
  }

  Future<WayaRequestResponse> activateDeactivateShopMember(
      String shopMemberId, payLoad) {
    return put('$serviceUrl2/shopMember/status/$shopMemberId', payLoad,
        formdata: false);
  }

  Future<WayaRequestResponse> editMember(String shopMemberId, payLoad) {
    return put('$serviceUrl2/shopMember/status/$shopMemberId', payLoad,
        formdata: false);
  }
}

@riverpod
RoleAccessRepo roleAccessRepository(Ref ref) {
  return RoleAccessRepo(ref);
}

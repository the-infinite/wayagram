import 'dart:io';

import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';


class RoleAccessRepo extends BaseRepository {
  static const serviceUrl2 = "wayagram-shop/api/v2";

  Future<WayaRequestResponse> getRoles() {
    return get('$serviceUrl2/admin/role/get-roles');
  }

    Future<WayaRequestResponse> getShopByUserId(String userId) {
    return get('$serviceUrl2/shops/$userId');
  }

     Future<WayaRequestResponse> getMemberList(String vendorId, int page) {
    return get('$serviceUrl2/shopMember/get-members/$vendorId?page=$page');
  }
      Future<WayaRequestResponse> getRoleManagementMemberList(String vendorId) {
    return get('$serviceUrl2/shopMember/role-management/$vendorId');
  }

    Future<WayaRequestResponse> addTeamMember(payLoad) {
    return post('$serviceUrl2/shopMember/create', payLoad, formdata: false);
  }

    Future<WayaRequestResponse> activateDeactivateShopMember(String shopMemberId, payLoad) {
    return put('$serviceUrl2/shopMember/status/$shopMemberId', payLoad, formdata: false);
  }


      Future<WayaRequestResponse> editMember(String shopMemberId, payLoad) {
    return put('$serviceUrl2/shopMember/status/$shopMemberId', payLoad, formdata: false);
  }

/* 
  Future<WayaRequestResponse> createContest(payLoad) {
    return post('$serviceUrl2/contests/create', payLoad, formdata: false);
  }

  Future<WayaRequestResponse> editContest(String contestId, payLoad) {
    return patch('$serviceUrl2/contests/edit-contest/$contestId', payLoad,
        formdata: false);
  }

  Future<WayaRequestResponse> registerContest(payLoad) {
    return post('$serviceUrl2/application/', payLoad, formdata: false);
  }

  Future<WayaRequestResponse> getContestForYou(int page) {
    return get('$serviceUrl2/contests/contest-for-you?page=$page');
  }

  Future<WayaRequestResponse> fetchHostedContest(String userId, int page) {
    return get(
        '$serviceUrl2/contests/hostedContests-by-profile?profileId=$userId&page=$page');
  }

  Future<WayaRequestResponse> fetchAppliedContest(String userId) {
    return get('$serviceUrl2/application/$userId/appliedContest');
  }
 */


}

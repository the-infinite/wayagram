import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/core/utils/waya_constants.dart';

import '../../../../../core/service/api_service/api_service.dart';

class ReferralRepo extends BaseRepository {
  String get serviceUrl => WayaServiceUri.account;

  Future<WayaRequestResponse> getReferralCount(String profileId) {
    return get('$serviceUrl/client/referral/count/$profileId');
  }

  Future<WayaRequestResponse> getReferralEarned(String profileId) {
    return get('$serviceUrl/client/referral/total-amount/$profileId');
  }

  Future<WayaRequestResponse> getUserReferral(String profileId, int page,
      {String startDate = "1990-12-31", String endDate = "3021-12-31"}) {
    // /client/referral/users/:profileId?limit=&page=&startDate=&endDate=&isPaid=&isEligible=
    return get(
        '$serviceUrl/client/referral/users/$profileId?limit=20&page=$page&startDate=$startDate&endDate=$endDate');
  }
}

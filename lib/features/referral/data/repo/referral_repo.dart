import 'package:wayagram/core/utils/waya_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/service/repos/base_repository_riverpod.dart';
import '../../../../../core/service/api_service/api_service.dart';

part 'referral_repo.g.dart';

class ReferralRepo extends BaseRepositoryRiverpod {
  String get serviceUrl => WayaServiceUri.account;

  ReferralRepo(super.ref);

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
        '$serviceUrl/client/referral/users/$profileId?limit=1000&page=$page&startDate=$startDate&endDate=$endDate');
  }
}

@riverpod
ReferralRepo referralRepository(Ref ref) {
  return ReferralRepo(ref);
}

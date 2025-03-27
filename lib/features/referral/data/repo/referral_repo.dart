import 'package:wayagram/core/service/repos/base_repository.dart';

import '../../../../../core/service/api_service/api_service.dart';

class ReferralRepo extends BaseRepository {
  String get serviceUrl => 'wayagram-profile/api/v2';

  Future<WayaRequestResponse> getReferralCount(String profileId) {
   
    return get('$serviceUrl/client/referral/count/$profileId');
  }

    Future<WayaRequestResponse> getReferralEarned(String profileId) {
   
    return get('$serviceUrl/client/referral/total-amount/$profileId');
  }

  
    Future<WayaRequestResponse> getUserReferral(String profileId, int page ) {
   
    return get('$serviceUrl/client/referral/users/$profileId?limit=20&page=$page');
  }
}


import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class KycRepository extends BaseRepository {
  static const serviceUrl = "wayagram-profile/api/v2";

  Future<WayaRequestResponse> getMyKYC(String userId,) {
    return get("$serviceUrl/client/kyc/get-business-kyc-by-user-id?userId=$userId", useBase: false);
  }

}
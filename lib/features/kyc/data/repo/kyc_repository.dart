import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/service/repos/base_repository_riverpod.dart';

part 'kyc_repository.g.dart';

class KycRepository extends BaseRepositoryRiverpod {
  static const serviceUrl = "wayagram-profile/api/v2";

  KycRepository(super.ref);

  Future<WayaRequestResponse> getMyKYC(
    String userId,
  ) {
    return get(
        "$serviceUrl/client/kyc/get-business-kyc-by-user-id?userId=$userId",
        useBase: false);
  }
}

@riverpod
KycRepository kycRepository(Ref ref) {
  return KycRepository(ref);
}

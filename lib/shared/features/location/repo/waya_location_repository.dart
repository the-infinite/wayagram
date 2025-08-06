import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/service/repos/base_repository_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';

part 'waya_location_repository.g.dart';

class WayaLocationRepository extends BaseRepositoryRiverpod {
  static const serviceUrl = WayaServiceUri.account;

  WayaLocationRepository(super.ref);

  Future<WayaRequestResponse> getAllCountries() {
    return get("$serviceUrl/client/location/countries?countryCode=NG");
  }

  Future<WayaRequestResponse> getAllStates() {
    return get("$serviceUrl/client/location/states?countryCode=NG");
  }

  Future<WayaRequestResponse> getAllLGA(
      {required String stateCode, required String countryCode}) {
    return get(
        "$serviceUrl/client/location/lgas?stateCode=$stateCode&countryCode=$countryCode");
  }

  Future<WayaRequestResponse> getAllCities(
      {required String stateCode, required String countryCode}) {
    return get(
        "$serviceUrl/client/location/cities?stateCode=$stateCode&countryCode=$countryCode");
  }
}

@riverpod
WayaLocationRepository wayaLocationRepository(Ref ref) {
  return WayaLocationRepository(ref);
}

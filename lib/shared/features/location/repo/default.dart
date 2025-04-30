import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/core/utils/utils.dart';

class WayaLocationRepository extends BaseRepository {
  static const serviceUrl = WayaServiceUri.account;
  static final instance = WayaLocationRepository._();

  WayaLocationRepository._();

  Future<WayaRequestResponse> getAllCountries() {
    return get("$serviceUrl/client/location/countries?countryCode=NG");
  }

  Future<WayaRequestResponse> getAllStates() {
    return get("$serviceUrl/client/location/states?countryCode=NG");
  }

  Future<WayaRequestResponse> getAllLGA({required String stateCode, required String countryCode}) {
    return get("$serviceUrl/client/location/lgas?stateCode=$stateCode&countryCode=$countryCode");
  }

  Future<WayaRequestResponse> getAllCities({required String stateCode, required String countryCode}) {
    return get("$serviceUrl/client/location/cities?stateCode=$stateCode&countryCode=$countryCode");
  }
}

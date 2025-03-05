import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/features/auth/data/model/auth_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/auth/upgrade_to_business/data/model/upgrade_to_business_model.dart';

class AuthRepository extends BaseRepository {
  static const serviceUrl = "wayagram-profile/api/v2";
  static const graphServiceUrl = "wayagram-graph/api/v2";

  Future<WayaRequestResponse> register(Register payload) {
    return post('$serviceUrl/client/auth/register', payload.toJson());
  }

  Future<WayaRequestResponse> verifyOtp(VerifyOtp payload) {
    return post(
        '$serviceUrl/client/auth/register/verify-email', payload.toJson());
  }

  Future<WayaRequestResponse> resendOtp(String email) {
    return post('$serviceUrl/client/auth/resend-otp',
        {"email": email, "purpose": 'REGISTER_USER'});
  }

  Future<WayaRequestResponse> verifyEmail(String email) {
    return post(
        '$serviceUrl/client/auth/password/reset-password', {"email": email});
  }

  Future<WayaRequestResponse> resetPassword(ForgotPassword payload) {
    return post(
        '$serviceUrl/client/auth/password/new-password', payload.toJson());
  }

  Future<WayaRequestResponse> login(
      {required String password,
      String? email,
      String? businessId,
      bool? isBusinessLogin}) {
    final payload = <String, dynamic>{};
    if (isBusinessLogin == true) {
      payload['businessId'] = businessId;
      payload['password'] = password;
    } else {
      payload['email'] = email;
      payload['password'] = password;
    }

    return post('$serviceUrl/client/auth/login', payload);
  }

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

  Future<WayaRequestResponse> businessKyc(dynamic data) {
    return post('$serviceUrl/client/kyc/add-business-kyc', data,
        formdata: true);
  }

  Future<WayaRequestResponse> getAccountType() async {
    return get('$serviceUrl/client/account-types');
  }

  Future<WayaRequestResponse> getBusinessTypes() async {
    return get('$serviceUrl/client/businesses/types/all');
  }

  Future<WayaRequestResponse> upgradeToBusiness(
      {required UpgradeToBusinessModel payload, required String id}) {
    return post(
        '$serviceUrl/client/users/$id/upgrade-to-business', payload.toJson());
  }

  Future<WayaRequestResponse> selectInterest(dynamic data) {
    return post(
      '$graphServiceUrl/interests',
      data,
    );
  }

  Future<WayaRequestResponse> getSelectedInterests(
      {required String userId}) async {
    return get('$graphServiceUrl/interests/$userId');
  }

  Future<WayaRequestResponse> getInterestsCategories() async {
    return get("$graphServiceUrl/interests/categories");
  }

//
}

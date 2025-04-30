import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/data/model/auth_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/auth/upgrade_to_business/data/model/upgrade_to_business_model.dart';

class AuthRepository extends BaseRepository {
  static const serviceUrl = WayaServiceUri.account;
  static const graphServiceUrl = WayaServiceUri.graph;

  Future<WayaRequestResponse> register(Register payload) {
    return post('$serviceUrl/client/auth/register', payload.toJson(),
        showErrors: true);
  }

  Future<WayaRequestResponse> verifyOtp(VerifyOtp payload) {
    return post(
        '$serviceUrl/client/auth/register/verify-email', payload.toJson(),
        showErrors: true);
  }

  Future<WayaRequestResponse> verify(VerifyOtp payload) {
    final data = {...payload.toJson(), "purpose": "USER_RESET_PASSWORD"};
    return post('$serviceUrl/client/auth/verify-otp', data, showErrors: true);
  }

  Future<WayaRequestResponse> resendOtp(String email,
      {String purpose = 'REGISTER_USER'}) {
    return post('$serviceUrl/client/auth/resend-otp',
        {"email": email, "purpose": purpose});
  }

  Future<WayaRequestResponse> oauth(String token, String authType) {
    return post('$serviceUrl/client/auth/login/oauth',
        {"oauthProvider": authType, "token": token});
  }

  Future<WayaRequestResponse> phoneVerification(String code, String phone) {
    return post('$serviceUrl/client/auth/verify-phoneNumber',
        {"otp": code, "phoneNumber": phone},
        showErrors: true);
  }

  Future<WayaRequestResponse> verifyEmail(String email) {
    return post(
        '$serviceUrl/client/auth/password/reset-password',
        {
          "email": email,
        },
        showErrors: true);
  }
   Future<WayaRequestResponse> verifyCAC(String cacNumber) {
    return post(
        '$serviceUrl/client/kyc/verify-cac-number',
        {
          "cacNumber": cacNumber,
           "mode": "basic"
        },
        showErrors: true);
  }

     Future<WayaRequestResponse> verifyBVN(String bvnNumber) {
    return post(
        '$serviceUrl/client/kyc/verify-bvn',
        {
          "bvn": bvnNumber,
           "mode": "basic"
        },
        showErrors: true);
  }

  Future<WayaRequestResponse> resetPassword(ForgotPassword payload) {
    return post(
        '$serviceUrl/client/auth/password/new-password', payload.toJson(),
        showErrors: true);
  }

  Future<WayaRequestResponse> login(
      {required String password,
      String? email,
      String? businessInfo,
      bool? isBusinessLogin}) {
    final payload = <String, dynamic>{};

    if (isBusinessLogin == true && businessInfo != null) {
      if (WayaValidators.isValidEmail(businessInfo) == null) {
        payload['email'] = businessInfo;
      } else {
        payload['businessId'] = businessInfo;
      }

      payload['password'] = password;
    } else {
      payload['email'] = email;
      payload['password'] = password;
    }

    return post('$serviceUrl/client/auth/login', payload, showErrors: true);
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
        '$serviceUrl/client/users/$id/upgrade-to-business', payload.toJson(),
        showErrors: true);
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

  Future<WayaRequestResponse> refreshToken({required String token}) async {
    return post("$serviceUrl/client/auth/refresh-token", {"token": token});
  }
//
}
